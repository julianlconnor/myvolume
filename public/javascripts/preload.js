(function ($) {
	preload([
		'hearthover.png',
		'download-hover.png'
	]);
	
	function preload(arrayOfImages) { 
		var cache = [];
		var path = '/images/';
		$(arrayOfImages).each(function(){
			var cacheImage = new Image();
			cacheImage.src = path + this;
			cache.push(cacheImage);
		});

	}
		
})(jQuery);

