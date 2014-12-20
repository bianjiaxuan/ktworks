// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery-1.7.1
//= require jquery_ujs
//= require games
//= require home
//= require jquery-ui-1.8.18.custom.min
//= require jquery-ui-timepicker-addon
//= require jquery.jscrollpane.min
//= require jquery.mousewheel
//= require jquery.ui.datepicker-zh-CN
//= require jquery.ui.datepicker
//= require jquery.uploadify-3.1.min
//= require mwheelIntent.js
//= require new_plant.js
//= require rounds.js
//= require sitedata_bas
//= require slides.min.jquery


$(document).ready(function(){
    $("#current_user").hover(
        //function(){$('.small_nav').fadeIn(500);},
        //function(){$('.small_nav').fadeOut(200);}
    );
});

$(function() {
  $('.scroll-pane').jScrollPane();
});


function navAsyn(url,section){
  $.get(url,{section:section});
}

function strLength(s){
   var char_length = 0;
   for (var i = 0; i < s.length; i++){
     var son_char = s.charAt(i);
     encodeURI(son_char).length > 2 ? char_length += 3 : char_length += 1;
   }
   return char_length;
}