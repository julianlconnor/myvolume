myvolume.routers.Workspace = Backbone.Router.extend({
    routes: {
    "charts/:id"  : "renderChart",
    ""            : "renderIndex"
    },

    initialize: function() {
        _.bindAll(this, "renderIndex", "renderChart");

        myvolume.views.charts = new myvolume.views.Charts();
        myvolume.views.songs = new myvolume.views.Songs();
    },

    renderIndex: function() {
        myvolume.views.charts.render();
    },
    renderChart: function(chart_id) {
        myvolume.views.charts.render(chart_id);
    }
});

/* This starts the backbone app */
myvolume.routers.workspace = new myvolume.routers.Workspace();
Backbone.history.start();
