function init_slider () {
  $( ".simpleform-slider" ).slider({
    range: true,
    min: 0,
    max: 500,
    values: [ 75, 300 ],
    slide: function( event, ui ) {
      $( "#" + $(this).data("attribute") + "_min" ).val(ui.values[ 0 ]);
      $( "#" + $(this).data("attribute") + "_max" ).val(ui.values[ 1 ]);
    }
  });
  $( ".simpleform-slider" ).each(function () {
    $( "#" + $(this).data("attribute") + "_min" ).val( $(this).slider("values", 0) );
    $( "#" + $(this).data("attribute") + "_max" ).val( $(this).slider("values", 1) );
  });
}