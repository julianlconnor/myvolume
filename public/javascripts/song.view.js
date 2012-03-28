myvolume.views.SongRow = Backbone.View.extend({
    tagName: 'tr',
    
    events: {
      "click" : "play"
    },

    template: _.template($('#song-item-template').html()),
    templateGenre: _.template($('#genre-item-template').html()),

    initialize: function() {
        console.log("ChartItemView::Init");

        _.bindAll(this, 'render', 'play');
        this.model.bind('change', this.render);
    },
 
    render: function() {
        console.log("ChartItemView::Render", this.model);

        $(this.el).html(this.template(this.model.toJSON()));
        
        //TODO: Add Genres
        var genre = this.model.get('genre');
        var node = this.$(".genre");
        node.append(this.templateGenre({ name: genre }));

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
