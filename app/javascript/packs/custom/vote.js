$(document).on('turbolinks:load', function () {
  $('.vote').on('ajax:success', function (e) {
    const xhr = e.detail[0]

    const type = xhr.type.toLowerCase()
    const id = xhr.id
    const rating = xhr.rating

    $('.' + type + '-' + id + ' .vote .rating').html(rating);
  });
});
