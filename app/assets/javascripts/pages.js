$(document).ready(function() {
    $('.btn').click(function() {
        $.ajax({
            method: "POST",
            url: '/pages/results',
            data: {
                searchText: $('.search-field').val()
            },
            success: function(response) {
                $('body').append(response);
            }
        });
    });
});
