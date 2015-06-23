function init_delete_modal_attach () {
  $('#delete-modal-attach').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget)
    var id = button.data('id')
    var modal = $(this)
    modal.find('.modal-body #attach_id').val(id)
  })
}