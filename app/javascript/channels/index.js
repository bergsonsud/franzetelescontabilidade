// Load all the channels within this directory and all subdirectories.
// Channel files must be named *_channel.js.


import "@fortawesome/fontawesome-free/js/all";
import "bootstrap";

const channels = require.context('.', true, /_channel\.js$/)
channels.keys().forEach(channels)



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