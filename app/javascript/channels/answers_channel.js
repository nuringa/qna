import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  if (window.location.href.match(/questions\/\d+/)) {
    var subscription = consumer.subscriptions.create("AnswersChannel", {
      connected() {
        subscription.perform('follow', gon.params)
      },

      received(data) {
        if (!(gon.user === data.author_id)) {
          let template = require('../templates/answer.hbs')(data)
          $('.answers').append(template)

          voting()
        }
      }
    })
  }

  let voting = function () {
    $('.vote').on('ajax:success', function (e) {
      const xhr = e.detail[0]

      const type = xhr.type.toLowerCase()
      const id = xhr.id
      const rating = xhr.rating

      $('.' + type + '-' + id + ' .vote .rating').html(rating)
    })
  }
})
