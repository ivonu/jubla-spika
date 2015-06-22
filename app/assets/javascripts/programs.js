function init_delete_modal () {
  $('#delete-modal-entry').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget)
    var id = button.data('id')
    var modal = $(this)
    modal.find('.modal-body #program_entry_id').val(id)
  })
}