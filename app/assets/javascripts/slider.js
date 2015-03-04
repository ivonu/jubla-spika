function init_slider () {
  $( ".simpleform-slider" ).each(function () {
    var min = $(this).data("min");
    var max = $(this).data("max");
    var act_min = slider_get ($(this).data("attribute"))[0];
    var act_max = slider_get ($(this).data("attribute"))[1];
    act_min = $.isNumeric(act_min) ? act_min : min;
    act_max = $.isNumeric(act_max) ? act_max : max;
    $(this).slider({
      range: true,
      min: min,
      max: max,
      values: [ act_min, act_max ],
      slide: function( event, ui ) {
        slider_set(ui.values[0], ui.values[1], $(this).data("attribute"), $(this).data("setter"))
      }
    });
  });
  $( ".simpleform-slider" ).each(function () {
    slider_set($(this).slider("values", 0), $(this).slider("values", 1), $(this).data("attribute"), $(this).data("setter"));
  });
}

function slider_set (min, max, attribute, setter) {
  if(setter.length > 0) window[setter](min, max, attribute);
  else {
    $( "#" + attribute + "_min" ).val(min);
    $( "#" + attribute + "_max" ).val(max);
    $( "#" + attribute + "_min_show" ).html(min);
    $( "#" + attribute + "_max_show" ).html(max);
  }
}

function slider_get (attribute) {
  var min = $( "#" + attribute + "_min" ).val();
  var max = $( "#" + attribute + "_max" ).val();
  return [min, max];
}