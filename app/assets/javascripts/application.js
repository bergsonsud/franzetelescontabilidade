// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require autocomplete-rails
//= require maskmoney
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .


$(document).ajaxError(function(event,xhr,options,exc) {
    
    var errors = JSON.parse(xhr.responseText);
    var kk ="<ul>";
    var erro = " erro";

    if (errors.length>1) {erro = " erros"};

    kk+= "<h1><span class='section'>"+errors.length+erro+"</span></h1><br>"

    for(var i = 0; i < errors.length; i++){
        var list = errors[i];
        kk += "<li><span class='section'>"+list+"</span></li>"
    }
 
    kk +="</ul>"

    $("#error_explanation").html(kk);
    //$('#error_explanation').focus();


     $('#dialog').animate({
                    scrollTop: $('#dialog #error_explanation').offset().top
                }, 500);
    
  });





