myvolume.views.Charts = Backbone.View.extend({
    el: '#charts',

    initialize: function() {
        console.log("ChartsView::Init");
        _.bindAll(this, "render", "addAll", "addOne", "handleClick");

        this.collection = new myvolume.collections.Charts();
    },

    render: function() {
        console.log("ChartsView::Render");
        $(this.el).empty();
        $.when(this.collection.fetch()).then(this.addAll);
        return this;
    },
    
    addAll: function(callback) {
        this.collection.each(this.addOne);

        this.activeModel = this.collection.first();
        this.activeModel.trigger('activate');

        myvolume.views.songs.render(this.collection.first().get('id'));
        return this;
    },

    addOne: function(chart) {
        console.log("ChartsView::addOne");
        var item = new myvolume.views.Chart({ model: chart});
        item.on('chart:clicked', this.handleClick);
        $(this.el).append(item.render().el);
        return this;
    },
    handleClick: function(model) {

        this.activeModel.trigger('deactivate');
        this.activeModel = model;
        this.activeModel.trigger('activate');

        myvolume.views.songs.render(model.get('id'));
    }
    
   
});
