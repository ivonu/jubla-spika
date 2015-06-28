function check_agb (box) {
  if(box.checked) {
    document.getElementById("new_user_submit").disabled = false;
  }
  else {
    document.getElementById("new_user_submit").disabled = true;
  }
}