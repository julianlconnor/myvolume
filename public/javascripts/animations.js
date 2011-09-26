$(function() {
    alert('lol');
    $('.alert-message').delay(5000).slideUp(1000, function () {
      });

    console.log("called");
    $('.register').live('click', function(event) {
      event.preventDefault();
      $('.login-box').slideUp(400, function() {
        $('.login-box').html('<%= escape_javascript(render(:partial => 'users/new')) %>');
        $('.login-box').slideDown(400, function() {
          $('.registerbutton').html('<%= link_to "Login to myvolu.me", sessions_path, :class => "login btn info" %>');
          });
        });
      });

    $('.login').live('click', function(event) {
      event.preventDefault();
      $('.login-box').slideUp(400, function() {
        $('.login-box').html('<%= escape_javascript(render(:partial => 'login')) %>');
        console.log('done');
        $('.login-box').slideDown(400, function() {
          $('.registerbutton').html('<%= link_to "Register with myvolu.me", new_user_path, :class => "register btn info" %>');
          });
        });
      });
})(jQuery);

