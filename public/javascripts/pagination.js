$(function() {
	$('#charts .pagination a').live('click',function(){
		$("#charts .pagination").html("<img src='/images/ajax-loader.gif' style='margin-left: -20px;'>");
		$.get(this.href,null,null,"script");
		return false;
	});
	$('#topdownloads .pagination a').live('click',function(){
		$("#topdownloads .pagination").html("<img src='/images/ajax-loader.gif' style='margin-left: -20px;'>");
		$.get(this.href,null,null,"script");
		return false;
	});
});