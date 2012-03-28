myvolume.views.Songs = Backbone.View.extend({
    id: 'songs',
    tagName: 'table',

    initialize: function(chartId) {
         console.log("ChartSongsView::Init");
         _.bindAll(this, "render", "addOne", "addAll");
    },

    render: function() {
        console.log("ChartSongsView::render");
        $('#content').append($(this.el));
        this.addAll();
        return this;
    },
    
    addOne: function(result) {
        console.log("ChartSongsView::addOne");
        var song = new SongItemView({model: result});
        $(this.el).append(song.render().el);
    },
    
    addAll: function() {
        console.log("ChartSongsView::addAll");
        $('table#songs').empty();
    }
   
});
