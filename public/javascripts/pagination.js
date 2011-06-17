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
	$('#new_user').live('submit', function() {
		$('#rightbar').html("<img src='/images/ajax-loader.gif' style='margin-left: -20px;'>");
		$.post(this.action,$(this).serialize(),null,"script");
		return false;
	});
	// jQuery to handle favorites
	$('#logout').live('click', function() {
		$('#rightbar').html("<img src='/images/ajax-loader.gif' style='margin-left: -20px;'>");
		$.get(this.href,null,null,"script");
		return false;
	});
});