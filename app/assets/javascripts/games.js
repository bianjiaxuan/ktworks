$(function(){
	  $('#image_slides').slides({
		    preload: true,
		    preloadImage: 'assets/slides/loading.gif',
		    play: 5000,
		    pause: 2500,
		    hoverPause: true,
		    animationStart: function(current){
			      $('.image_caption').animate({
				        bottom:-35
			      },100);
		    },
		    animationComplete: function(current){
			      $('.image_caption').animate({
				        bottom:0
			      },200);
		    },
		    slidesLoaded: function() {
			      $('.image_caption').animate({
				        bottom:0
			      },200);
		    }
	  });
});

$(function(){
	  $('#intro_slides').slides({
		    preload: true,
		    preloadImage: 'assets/slides/loading.gif',
		    play: 5000,
		    pause: 2500,
		    hoverPause: true,
		    animationStart: function(current){
			      $('.intro_caption').animate({
				        bottom:-35
			      },100);
		    },
		    animationComplete: function(current){
			      $('.intro_caption').animate({
				        bottom:0
			      },200);
		    },
		    slidesLoaded: function() {
			      $('.intro_caption').animate({
				        bottom:0
			      },200);
		    }
	  });
});
