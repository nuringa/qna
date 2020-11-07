$(document).on('turbolinks:load', function(){
  $('.edit-question-link').on('click', function(e) {
    e.preventDefault()
    $(this).hide()
    $('#edit-question-form').removeClass('hidden')
  })
})
