(function($) { 
    $.fn.extend({
        htmlFadeIn: function(dom_obj) {
            $(this).hide().html(dom_obj);
            $(this).fadeIn();
        }
    });
})(jQuery);
