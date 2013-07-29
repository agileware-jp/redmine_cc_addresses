function addCcField() {  
  var number = $('#div-cc-addresses p').length;
  var ccField = "<p> <label> CC Address </label> <input size=50 type='text' name='issue[cc_addresses_attributes][" + number + "][mail]'' /> </p>";  
  $('#div-cc-addresses').append(ccField);
}