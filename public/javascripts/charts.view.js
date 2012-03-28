myvolume.views.Charts = Backbone.View.extend({
    el: '#charts',

    initialize: function() {
        console.log("ChartsView::Init");
        _.bindAll(this, "render", "addAll", "addOne", "handleClick");

        this.collection = new myvolume.collections.Charts();
    },

    render: function(chart_id) {
        console.log("ChartsView::Render");
        $(this.el).empty();
        $.when(this.collection.fetch()).then(this.addAll);
        return this;
    },
    
    addAll: function(callback) {
        console.log("ChartsView::addAll");
        this.collection.each(this.addOne);
        return this;
    },

    addOne: function(chart) {
        console.log("ChartsView::addOne");
        var item = new myvolume.views.Chart({ model: chart});
        item.on('clicked', this.handleClick);
        $(this.el).append(item.render().el);
        return this;
    },
    handleClick: function() {
        console.log("clicked!", arguments);
    }
    
   
});
