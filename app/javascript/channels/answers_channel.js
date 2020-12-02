import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  if (window.location.href.match(/questions\/\d+/)) {
    let subscription = consumer.subscriptions.create("AnswersChannel", {
      connected() {
        subscription.perform('follow', gon.params)
      },

      received(data) {
        if (gon.user_id === data.answer.author_id) return

        const template = require('../templates/answer.hbs')

        data.is_guest = gon.user === null
        $('.answers').append(template(data))

        voting()
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
