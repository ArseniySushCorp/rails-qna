const commentConsumer = ActionCable.createConsumer()

commentConsumer.subscriptions.create("CommentChannel", {
  connected() {},

  disconnected() {},

  received(data) {
    const comment = Comment.jsonRender(data)
    const resource = JSON.parse(data).resource_name
    resource === "answer" ? $(".comments_answer").append(comment) : $(".comments").append(comment)
  }
})
