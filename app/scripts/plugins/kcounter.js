/*!
 * jQuery counter Plugin
 * http://kcounter.kudoslabs.co.uk
 * Copyright (c) 2012 Kudos
 * Version: 0.1
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 * Requires: jQuery v1.7 or later
 */
(function($){

  var methods = {
    init : function( options ){

      // defaults
      settings = $.extend({
        height: 50,
        width: 50,
        initial: false,
        easing: 'swing',
        duration: 'fast'
      }, options);

      $(this).data('settings',settings) ;

      return this.each(function(){

        var $this = $(this),
        initialContent = settings.initial ? settings.initial : $this.html() , // get the initial content
        chars = initialContent.toString() //.split("") , // everything is a string!

        html = "<ul><li><span>"+ chars +"</span></li></ul>" ;

        console.log(chars);

        // $.each(chars, function(index, value) { // build individual counters
        //   if( $.isNumeric(value) ) {
        //     html += "<ul><li style=\"top:-"+(value*settings.height)+"px\">" ;
        //     for (var i = 0; i < 10; i++) {
        //       html += '<span>'+ i +'</span>' ;
        //     }
        //     html += "</li></ul>" ;
        //   } else {
        //     html += '<ul><li><span>'+value+'</span></li></ul>' ;
        //   }
        // });
        $this.html(html) ;

        methods.updateCss.call($this, settings);

      }) ;

    },
    updateCss : function(settings) {

      return this.each(function(){

        var $this = $(this);

        $this.css({
          'overflow' : 'hidden'
        }) ;
        $('ul', $this).css({
          'position' : 'relative',
          'float' : 'left',
          'maring': 0,
          'padding': 0,
          'height' : settings.height+'px',
          'width' : settings.width+'px',
          'line-height' : settings.height+'px'
        }) ;
        $('li', $this).css({
          'position' : 'absolute',
          'width' : settings.width+'px'
        }) ;
        $('span', $this).css({
          'display' : 'block',
          'text-align' : 'center',
          'height' : settings.height+'px',
          'width' : settings.width+'px',
        }) ;
      }) ;
    },
    update : function( content ) {

      return this.each(function(){

        var $this = $(this),
        chars = content.toString()
        numberCounters = $('ul', $this).length,
        settings = $(this).data('settings');
        var diff, html;

        if(numberCounters!==chars.length){
          diff = chars.length-numberCounters ;
          numberCounters = chars.length ;

          // decide whether to add or remove values
          if( diff<0 ) {

            $('ul', $this).slice(diff).remove() ;

          } else {

            html = '' ;
             html = "<ul><li> <span>" + diff + "</span></li></ul>"



            // while (diff--) {
            //   html += "<ul><li>" ;
            //   for (var i = 0; i < 10; i++) {
            //     html += '<span>'+ i +'</span>' ;
            //   }
            //   html += "</li></ul>" ;
            // }
            $this.prepend(html) ;

          }
        }

        $.each(chars, function(index, value){
          if(value == 1) { return; }
          var html = '';
          if (settings.duration === 0) {
            $('ul:nth-child('+(index+1)+') li', $this).html("<span>"+value+"</span>").css({top: 0});
            return;
          }

          $('ul:nth-child('+(index+1)+') li', $this).html("<span>"+value+"</span>").animate({top: 0}, settings.duration, settings.easing) ;

        });

        methods.updateCss.call($this, settings);

      }) ;
    }
  };

  $.fn.kCounter = function( method ){

    if ( methods[method] ) {
      return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.kCounter' );
    }

  };
})( jQuery );
