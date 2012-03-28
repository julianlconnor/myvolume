myvolume.views.SongsTable = Backbone.View.extend({
    id: 'songs',
    tagName: 'table',

    initialize: function(chartId) {
         console.log("ChartSongsView::Init");
         _.bindAll(this, "render", "addOne", "addAll");
         this.songs = new myvolume.collections.Songs();
         this.songs.on('reset', this.addAll);
    },

    render: function(id) {
        console.log("ChartSongsView::render");
        this.songs.id = id;
        //$(this.el).empty();
        this.songs.fetch();
        return this;
    },
    
    addAll: function() {
        console.log("ChartSongsView::addAll");
        $(this.el).empty();
        this.songs.each(this.addOne);

        this.trigger('ready');
    },

    addOne: function(result) {
        console.log("ChartSongsView::addOne");
        var song = new myvolume.views.SongRow({model: result});
        $(this.el).append(song.render().el);
    }
    
   
});
