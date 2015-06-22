function init_delete_modal_comment () {
  $('#delete-modal-comment').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget)
    var id = button.data('id')
    var modal = $(this)
    modal.find('.modal-body #comment_id').val(id)
  })
}