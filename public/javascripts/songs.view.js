myvolume.views.Songs = Backbone.View.extend({
    el: '#songs',

    initialize: function(chartId) {
         _.bindAll(this,
             'render',
             'fadeIn');
         this.view = new myvolume.views.SongsTable();
         this.view.on('ready', this.fadeIn);
    },

    render: function(id) {
        myvolume.routers.workspace.navigate('charts/' + id);
        $(this.el).empty();
        $(this.el).html('<div class="loader"><img src="/images/ajax-loader.gif" /></div>');
        this.view.render(id);
        return this;
    },

    fadeIn: function() {
        $(this.el).htmlFadeIn(this.view.el);
    }
    
});
