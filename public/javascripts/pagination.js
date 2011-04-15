$(function() {
	$('.pagination a').live('click',function(){
		$(".pagination").html("<img src='/images/ajax-loader.gif'>");
		$.get(this.href,null,null,"script");
		return false;
	});
});