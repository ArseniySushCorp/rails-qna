const answerConsumer = ActionCable.createConsumer()

answerConsumer.subscriptions.create("AnswerChannel", {
  connected() {},

  disconnected() {},

  received(data) {
    const answer = Answer.jsonRender(data)
    $(".answers").append(answer)
  }
})
