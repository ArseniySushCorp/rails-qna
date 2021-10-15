$(document).on("turbolinks:load", () => {
  $(".answers").on("click", ".edit-answer", (e) => {
    e.preventDefault()

    $(e.target).hide()

    const answerId = $(e.target).data("answerId")

    $(`form#edit-answer-${answerId}`).removeClass("hidden")
  })
})
