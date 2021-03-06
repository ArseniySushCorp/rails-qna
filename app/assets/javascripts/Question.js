class Question {
  constructor() {
    this.formEdit()
    this.voteForm()
  }

  formEdit() {
    $(".questions").on("click", ".edit-question-link", (event) => {
      const questionId = $(event.target).data("questionId")

      event.preventDefault()
      $(event.target).hide()
      $("form#edit-question-" + questionId).removeClass("hidden")
    })
  }

  voteLink(id, liked) {
    let link = $(
      `<a class="voting ${liked ? "upVote" : "downVote"}">${liked ? "Like" : "Dislike"}</a>`
    )

    link.attr("data-type", "json")
    link.attr("data-remote", true)
    link.attr("rel", "nofollow")
    link.attr("data-method", "put")
    link.attr("href", `/questions/${id}/vote?liked=${liked}&amp`)
    link.on("ajax:success", (event) => {
      this.voteEvent(event)
    })

    return link
  }

  voteCancelLink(id) {
    let link = $(`<a class="voting cancelVote"> Cancel vote</a>`)

    link.attr("data-type", "json")
    link.attr("data-remote", true)
    link.attr("rel", "nofollow")
    link.attr("data-method", "delete")
    link.attr("href", `/questions/${id}/cancel_vote?votable_type=Question`)
    link.on("ajax:success", (event) => {
      this.voteCancelEvent(event)
    })

    return link
  }

  voteEvent(event) {
    const vote = event.detail[0]

    $(`#question-${vote.id} .upVote`).remove()
    $(`#question-${vote.id} .downVote`).replaceWith(this.voteCancelLink(vote.id))
  }

  voteCancelEvent(event) {
    const vote = event.detail[0]

    $(`#question-${vote.id} .cancelVote`).replaceWith(
      this.voteLink(vote.id, true),
      this.voteLink(vote.id, false)
    )
  }

  voteErrorEvent(event) {
    const errors = event.detail[0]

    $(".question-errors").text = ""

    errors.each((index, value) => {
      $(".question-errors").append(`<p>${value}</p>`)
    })
  }

  voteForm() {
    $(".upVote")
      .on("ajax:success", (event) => {
        this.voteEvent(event)
      })
      .on("ajax:error", (event) => {
        this.voteErrorEvent(event)
      })
    $(".downVote")
      .on("ajax:success", (event) => {
        this.voteEvent(event)
      })
      .on("ajax:error", (event) => {
        this.voteErrorEvent(event)
      })
    $(".cancelVote")
      .on("ajax:success", (event) => {
        this.voteCancelEvent(event)
      })
      .on("ajax:error", (event) => {
        this.voteErrorEvent(event)
      })
  }

  static jsonRender(data) {
    const locals = JSON.parse(data)

    const questions = $(".questions")

    const question = $("<li></li>").toggleClass("question")

    question.append(`<a href="/questions/${locals.question.id}">${locals.question.title}</a>`)

    questions.append(question)

    return questions
  }

  static newComment(locals) {
    const form = $("<form></form>")
    const token = $("<input></input>")

    form.attr({
      action: `/questions/${locals.question.id}/comments.js`,
      "accept-charset": "UTF-8",
      "data-remote": true,
      method: "post"
    })

    token
      .attr({
        type: "hide",
        name: "authenticity_token",
        value: locals.create_comment_token
      })
      .hide()

    form
      .append(token)
      .append($('<label for="comment_body">Comment:</label>'))
      .append(
        $("<textarea></textarea>").attr({
          name: "comment[body]",
          id: "comment_body"
        })
      )
      .append(
        $("<input></input>").attr({
          type: "submit",
          name: "commit",
          value: "Comment",
          "data-disable-with": "Comment"
        })
      )

    return form
  }
}
