import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    this.perform('follow')
  },

  received(data) {
    if (gon.user_id === data.question.author_id) return

    const template = require('../templates/question.hbs')

    $('.questions').append(template(data))
  }
});
