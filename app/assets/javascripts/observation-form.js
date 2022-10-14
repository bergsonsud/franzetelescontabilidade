var total = parseFloat($('#order-total-value').val());

$(".datepicker").datepicker({format: "dd/mm/yyyy", language: "pt-BR"});

function remove_customer(id, value) {
  $('#id_customer_' + id).remove();
  $('#customer_' + id).remove();
  update_total_value(-value);

var size = $('#customers').find('tr').length;

if (size==0){
  $('#submit').hide(); 
};

};




$('#customer-autocomplete').bind('railsAutocomplete.select', function(event, data){
  $('#customer-autocomplete').val("");

  alert("asd");

  var input_customer_id = "<input id='id_customer_" + data.customer.id + "' type='text' name='oberservation[customer_ids][]' hidden='true' value=" + data.customer.id + ">"; 
  $('#customers-list').append(input_customer_id);

  /*var customer_display = "<li id='display_customer_" + data.customer.id + "' class='list-group-customer'>" + data.customer.description + " - " + numberToCurrency(data.item.value) + "<button type='button' class='close' onclick='remove_item("+ data.item.id + ","+ data.item.value +")' aria-label='Close'><span aria-hidden='true'>&times;</span></button></li> ";
  */
  
  var customer = "<tr id='customer_" + data.customer.id + "' class='customer-row'><td>" + data.customer.razao + "</td>";
  /*$('#customers-display').append(customer_display);*/

  listEmployees = $('#list-employees').html();
 
  customer = customer+"<td><button type='button' class='close' onclick='remove_customer("+ data.customer.id + ","+ data.customer.razao +")' aria-label='Close'><span aria-hidden='true'>&times;</span></button></td>";  
  $('#customers').append(customer); 
  update_total_value(data.customer.value);

var size = $('#customers').find('tr').length;
if (size>0){
  $('#submit').show(); 
};

if (size==0){
  $('#submit').hide(); 
};

$('[data-toggle="popover"]').popover();
});

$(function () {
  $('[data-toggle="popover"]').popover();
})

function add_customer(customer_id,customer_id) {  
  /*alert(customer_id+' '+customer_id);*/
  $('input#customer_'+customer_id).val(customer_id);
};



  