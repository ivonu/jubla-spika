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

function update_checkboxes () {

  if(document.getElementsByName("filterrific[only_programs]")[1].checked) {
    document.getElementsByName("filterrific[with_part_start]")[1].disabled = true;
    document.getElementsByName("filterrific[with_part_main]")[1].disabled = true;
    document.getElementsByName("filterrific[with_part_end]")[1].disabled = true;
  }
  else if(document.getElementsByName("filterrific[with_part_start]")[1].checked ||
          document.getElementsByName("filterrific[with_part_main]")[1].checked ||
          document.getElementsByName("filterrific[with_part_end]")[1].checked) {
    document.getElementsByName("filterrific[only_programs]")[1].disabled = true;
  }
  else {
    document.getElementsByName("filterrific[only_programs]")[1].disabled = false;
    document.getElementsByName("filterrific[with_part_start]")[1].disabled = false;
    document.getElementsByName("filterrific[with_part_main]")[1].disabled = false;
    document.getElementsByName("filterrific[with_part_end]")[1].disabled = false;

  }


}