$(document).on("turbolinks:load", () => {
  $(".question").on("click", ".edit-question", (e) => {
    e.preventDefault()

    $(e.target).hide()

    const questionId = $(e.target).data("questionId")

    $(`form#edit-question-${questionId}`).removeClass("hidden")
  })
})
