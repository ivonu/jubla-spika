function slider_set_time (min, max, attribute) {

  $( "#" + attribute + "_min" ).val(minutes_rounded(min));
  $( "#" + attribute + "_max" ).val(minutes_rounded(max));
  $( "#" + attribute + "_min_show" ).html(minutes_to_string (min));
  $( "#" + attribute + "_max_show" ).html(minutes_to_string (max));

}

function minutes_rounded (time) {
  if(time < 60) return time - time%5;
  else return time - time%30;
}

function minutes_to_string (time) {
  time = minutes_rounded(time);
  if(time > 60) {
    time = time/60;
    time += " Stunden";
  }
  else if(time < 60) {
    time += " Minuten";
  }
  else {
    time = "1 Stunde";
  }
  return time;
}