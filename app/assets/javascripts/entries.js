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

function load_duplicates () {

  title = document.getElementById("entry_title").value;
  title_other = document.getElementById("entry_title_other").value;

  if(title != "" || title_other != "") {
    http = new XMLHttpRequest();
    http.open("GET", "check_duplicates.json?titles=" + encodeURIComponent(title + " " + title_other), true);

    http.onreadystatechange = function() {
      if (http.readyState==4 && http.status==200) {
        var data = JSON.parse(http.responseText)

        if(data.length != 0) {
          var msg_window = document.getElementById("duplicates_alert_text")
          msg_window.innerHTML = "";
          for (var i = 0; i < data.length; i++) {
            msg_window.innerHTML += "<br><a href=\"" + data[i].table.url + "\" target=\"_blank\">" + data[i].table.title + "</a>"
          }
          $('#duplicates_alert').fadeIn('fast');
        }
        else {
          $('#duplicates_alert').fadeOut('fast');
        }

      }
    }

    http.send();
  }
  else {
    $('#duplicates_alert').fadeOut('fast');
  }

}

function material_start(material) {
  if(material.value == '') {
    material.value += "- ";
  }
  else {
    material.value += "\n- ";
  }
  try {
    var range = material.createTextRange();
    range.collapse(false);
    range.select();
  }
  catch(err) {}
}


function material_check (material) {
  if(material.value.substr(material.value.length-2, 2) == '\n-') {
    material.value = material.value.substr(0, material.value.length-2);
  }
  else if(material.value == '-') {
    material.value = '- ';
  }
  else if(material.value.substr(material.value.length-1, 1) == '\n') {
    material.value += "- ";
  }
}


function material_quit(material) {
  if(material.value.substr(material.value.length-3, 3) == '\n- ') {
    material.value = material.value.substr(0, material.value.length-3);
  }
  else if(material.value == '- ') {
    material.value = '';
  }
}