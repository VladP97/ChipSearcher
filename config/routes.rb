Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "pages#search"
  post 'pages/results', to: 'pages#results'
  get 'pages/show_results', to: 'pages#show_results'
  get 'pages/more_results', to: 'pages#more_results'
end
