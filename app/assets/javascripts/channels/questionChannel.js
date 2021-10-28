const questionConsumer = ActionCable.createConsumer()

questionConsumer.subscriptions.create("QuestionChannel", {
  connected() {},

  disconnected() {},

  received(data) {
    const question = Question.jsonRender(data)
    $(".questions").append(question)
  }
})
