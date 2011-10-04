
    $('a.menu').live('click', function(e){
        $(this).parent().toggleClass('open');
    });
    var a = audiojs.createAll({
        trackEnded: function() {
            var playing = $('ol li.playing');
            var next = $('ol li.playing').next();
            if (!next.length) next = $('ol li').first();
            // Image juggle
            playing.find('.play_button').html("<img src='/images/player_play.png'>");
            next.find('.play_button').html("<img src='/images/player_pause.png'>");

            next.addClass('playing').siblings().removeClass('playing');
            audio.load($('.track_info a', next).attr('data-src'));
            audio.play();
        }
    });

    var audio = a[0];
    first = $('#charts ul .track_info a').attr('data-src');
    audio.load(first);

    function playAudio(url){
        audio.load(url);
        audio.play();
    }

    // Setup the player to autoplay the next track
    // Load in the first track
    // Expand a playlist on header click
    $('div.chartheader').live('click',function(e) {
        var chart_id = $(this).attr("id");
        $("." + chart_id).slideToggle("slow");
    });

    $(window).scroll(function(){
        var x = 0 - ($(this).scrollLeft() / 15);
        $("#player_fixed").offset({
            left: x + 30
        });
    });

    // Load in a track on click from right div playlists
    $('ul li div.play_button').live('click',function(e) {
        // Copy selected node
        var clicked_node = $(this).parent().parent().parent().parent().parent().clone();
        $('ol li.playing').find('.play_button').html("<img src='/images/player_play.png'>");
        var playing = $(".playing").removeClass('playing');
        // Hide play and queue button during playback
        clicked_node.find('.play_button').html("<img src='/images/player_pause.png'>");
        clicked_node.find('.queue_button').html("<img src='/images/minus.png'>");
        // Show play and queue button for previously playing track
        // playing.find('.play_button').show();
        // playing.find('.queue_button').show();
        // Load the track into the player

        e.preventDefault();
        //$(this).addClass('playing').siblings().removeClass('playing');
        clicked_node.addClass('playing').addClass('playlist').prependTo($("#player_playlist"));
        if ( $("#player_playlist li").length > 5 )
        $("#player_playlist li:last").remove();
        playAudio($('.track_info a', clicked_node).attr('data-src'));
        // audio.load($('.track_info a', clicked_node).attr('data-src'));
        // 		audio.play();
    });

    // Queue track on playlist, same but append
    $('ul li div.queue_button').live('click', function(e) {
        var clicked_node = $(this).parent().parent().parent().parent().parent().clone();
        // Load the track into the player
        //e.preventDefault();
        clicked_node.find('.queue_button').html("<img src='/images/minus.png'>");
        //$(this).addClass('playing').siblings().removeClass('playing');
        clicked_node.appendTo($("#player_playlist"));
        if ( $("#player_playlist li").length > 5 )
        $("#player_playlist li:last").remove()
    });

    // Load in a track on click from the player playlist
    $('ol li:not(.playing) div.play_button').live('click', function(e) {
        var clicked_node = $(this).parent().parent().parent().parent().parent();
        // Load the track into the player
        e.preventDefault();
        // If there's a track currently playing, change it's play icon to 'paused'
        $('ol li.playing').find('.play_button').html("<img src='/images/player_play.png'>");
        clicked_node.find('.play_button').html("<img src='/images/player_pause.png'>");
        clicked_node.addClass('playing').siblings().removeClass('playing');
        audio.load($('.track_info a', clicked_node).attr('data-src'));
        audio.play();
    });

    // Track that's playing, gets paused, etc..
    $('ol li.playing div.play_button').live('click', function(e) {
        var clicked_node = $(this).parent().parent().parent().parent().parent();
        e.preventDefault();
        // If the track is currently paused
        //if ( clicked_node.find('.play_button img').attr("src") == '/images/player_pause.png'){
            if (audio.playing){
                //alert("let's pause");
                clicked_node.find('.play_button').html("<img src='/images/player_play.png'>");
                audio.pause();
            }
            else {
                //alert("let's play");
                clicked_node.find('.play_button').html("<img src='/images/player_pause.png'>");
                audio.play();
            }
        });

        // Track that's not playing gets removed
        $('ol li:not(.playing) div.queue_button').live('click', function(e) {
            var clicked_node = $(this).parent().parent().parent().parent().parent();
            e.preventDefault();
            $('ol li').eq($('ol li').index(clicked_node)).remove();
        });

        // Track that's playing is removed
        $('ol li.playing div.queue_button').live('click', function(e) {
            var clicked_node = $(this).parent().parent().parent().parent().parent();
            e.preventDefault();
            var next = $('ol li.playing').next();
            $('ol li').eq($('ol li').index(clicked_node)).remove();

            if (!next.length && !($('ol li').length)) {
                // Removing node, empties player_playlist, load first node
                first = $('ul .track_info a').attr('data-src');
                audio.load(first);
            }
            else if ( $('ol li').first() != null ) {
                // Removed last node in player_playlist, set first to playing
                var next = $('ol li').first();
                next.addClass('playing');
                next.find('.play_button').html("<img src='/images/player_pause.png'>");
                audio.load($('.track_info a', next).attr('data-src'));
                audio.play();
            }
            else {
                // Simply set next node in player_playlist to playing
                next.addClass('playing');
                next.find('.play_button').html("<img src='/images/player_pause.png'>")
                audio.load($('.track_info a', next).attr('data-src'));
                audio.play();
            }
        });
        // Handles the toggle for logging in and registration
        $('span.registerToggle').live('click',function(e) {
            $("#loginbox").slideToggle("slow");
            $("#user_box").slideToggle("slow");
        });
