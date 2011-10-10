$(function() {
    
    // jQuery to handle Chart click
    $('.chart').live('mousedown', function() {   
        var $chart = $(this);
        $chart.css('position', 'relative');
        $chart.css('left', '2px');
        $chart.css('top', '2px');   
    }).live('mouseup', function() {  
        var $chart = $(this);
        $chart.css('left', '0px');
        $chart.css('top', '0px');   
    }).live('click', function() {
        var $chart = $(this);
        $('.chart_list .active').removeClass('active');
        $chart.addClass('active');
        var $chart_title = $chart.attr('title');
        var url = $chart.attr('name');
        //$('#chart_title').html('<h3>' + $chart_title + '</h3>');
        $.get(url, null, null, "script");
        return false;
    });
    
    $('.heart, .download').live('mousedown', function() {   
        var $chart = $(this);
        $chart.css('background-position', '55% 65%');  
    }).live('mouseup', function() {  
        var $chart = $(this);
         $chart.css('background-position', '50% 50%');    
    });
    
    // $('.download').live('click', function(){
    //     window.open($(this).attr('url'));
    // })
    
    
	// jQuery to handle chart pagination
    $('#charts .pagination a').live('click', function(){
      var $list = $('.chart_outside');
      $list.css('left', '0px');
      $list.animate({
        left: parseInt($list.css('left'), 10) == 0 ? $list.outerWidth() : 0  
      });     
      $.get(this.href,null,null,"script");
      return false;
    });

  // jQuery to handle chart song load
    

	// jQuery to handle download pagination
	$('#top-downloads .pagination a').live('click', function(){
		$('#topdownloads .pagination').html("<img src='/images/ajax-loader.gif' style='margin-left: -20px;'>");
		$.get(this.href,null,null,"script");
		return false;
	});
	// jQuery to handle logging in
	$('#ajaxSessionForm').live('submit', function(){
		$('#rightbar').html("<img src='/images/ajax-loader.gif' style='margin-left: -20px;'>");
		$.post(this.action,$(this).serialize(),null,"script");
		return false;
	});
	// jQuery to handle logging out
	$('#logout').live('click', function() {
		$('#rightbar').html("<img src='/images/ajax-loader.gif' style='margin-left: -20px;'>");
		$.get(this.href,null,null,"script");
		return false;
	});
	// jQuery to handle registration
 //$('#new_user').live('submit', function() {
		//$('#rightbar').html("<img src='/images/ajax-loader.gif' style='margin-left: -20px;'>");
		//$.post(this.action,$(this).serialize(),null,"script");
		//return false;
	//});
	// jQuery to handle favorites
	$('.heart').live('click', function() {
		// $(this).html("<a href='/favorite/1265' class='heart'><img src='/images/favorite_ajax_loader.gif'/></a>");
		console.log($(this).attr('url'));
		$.get($(this).attr('url'),null,null,"script");
		return false;
	});
	// jQuery to handle playing a mostFavorited Track
	$('.lovedElement .track_icons a.play_button').live('click',function(e) {
		$(this).addClass("justclicked");
		$(this).html("<img src='/images/favorite_ajax_loader.gif'/>");
		$.get(this.href,null,null,"script");
		return false;
	});
	// Favoriting a song in the player_playlist
	$('ul li .track_info .tags .track_icons div.play_button a').live('click',function(e) {
		$(this).addClass("justclicked");
		$(this).html("<img src='/images/favorite_ajax_loader.gif'/>");
		$.get(this.href,null,null,"script");
		return false;
	});
	// Ajax for viewing a track
	$('.showtrack').live('click',function(e) {
		$.get(this.href,null,null,"script");
		return false;
	});
	$('.showhome').live('click',function(e) {
		$.get(this.href,null,null,"script");
		return false;
	});
	$('#activeUsers .alias a').live('click',function(e) {
	  $.get(this.href,null,null,"script");
	  return false;
	});
	
	
});
