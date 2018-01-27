class PagesController < ApplicationController
  def search

  end

  def results
    @results = get_from_dipchip(params[:searchText], 0)
    render inline: "<%- @results.each_with_index do |result, index| %>
                        <div last_id = #{@results.last.id}>
                          <%= tag('img', :src => result[:img]) %>
                          <p><%= result[:count] %></p>
                          <p><%= result[:price] %> руб </p>
                        </div>
                    <% end %>"
  end

  def more_results
    @results = get_from_dipchip(params[:searchText], params[:lastID])
    render inline: "<%- @results.each_with_index do |result, index| %>
                        <div last_id = #{@results.last.id}>
                          <%= tag('img', :src => result[:img]) %>
                          <p><%= result[:count] %></p>
                          <p><%= result[:price] %> руб </p>
                        </div>
                    <% end %>"
  end

  private

  def get_from_belchip(searchText)
    mechanize = Mechanize.new
    mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    page = mechanize.get('http://belchip.by/search/')
    form = page.form
    form.field_with(:name=>"query").value=searchText
    results = form.submit
    img_arr = []
    results.search('.product-image > img').each do |image|
      img_arr.push("http://belchip.by/" + image['src'])
    end
    count_arr = []
    results.search('.shops > div').each do |div|
      count_arr.push(div.search('div').first.text.gsub(/\W+/,'').to_i)
    end
    price_arr = []
    results.search('.denoPrice').each do |div|
      price_arr.push(div.text.gsub(/[^0-9|^,]/,''))
    end
    first_count_arr = count_arr.drop(1).each_slice(2).map(&:first)
    second_count_arr = count_arr.drop(0).each_slice(2).map(&:first)
    {:counts => [first_count_arr, second_count_arr].transpose.map {|x| x.reduce(:+)}, :imgs => img_arr, :prices => price_arr}
  end

  def get_from_dipchip(searchText, id)
    Search.where("id >= :id and search_text like :search_text", id: id, search_text: "%#{searchText}%").limit(10)
  end
end
