myvolume.views.Song = Backbone.View.extend({
    tagName: 'tr',
    
    events: {
      "click" : "play"
    },

    initialize: function() {
        console.log("ChartItemView::Init");

        _.bindAll(this, 'render', 'play');
        this.model.bind('change', this.render);
    },
 
    render: function() {
        console.log("ChartItemView::Render");
        console.log(this.model.toJSON());

        var template = ich.song_item_template(this.model.toJSON());
        $(this.el).html(template);
        
        //TODO: Add Genres
        var genre = this.model.attributes.genre;
        var node = this.$(".genre");
        node.append(ich.genre_item_template({ name: genre }));

        return this;
    },

    play: function() {
        var sample_url = this.model.get('sample_url');
      
        $(".playing").removeClass("playing");
        $(this.el).addClass("playing");

        $("#jquery_jplayer_1").jPlayer("setMedia", {
          mp3: sample_url
        }).jPlayer("play");
    }

});
