$(function() {
	// jQuery to handle chart pagination
    $('#charts .pagination a').live('click', function(){
        $('#charts .pagination').html("<img src='/images/ajax-loader.gif' style='margin-left: -20px;'>");  
        $.get(this.href,null,null,"script");
        return false;
    });
	// jQuery to handle download pagination
	$('#topdownloads .pagination a').live('click', function(){
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
		$(this).addClass("justclicked")
		$(this).html("<img src='/images/favorite_ajax_loader.gif'/>");
		$.get(this.href,null,null,"script");
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
