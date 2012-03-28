myvolume.views.Chart = Backbone.View.extend({
    tagName: 'div',
    className: 'chart clearfix',

    template : _.template($('#chart-item-template').html()),
    templateGenre : _.template($('#genre-item-template').html()),

    events: {
        "click" : "triggerClicked"
    },
    
    initialize: function() {
        console.log("ChartItemView::Init");
        _.bindAll(this,
            'render',
            'triggerClicked', 
            'triggerActivate',
            'triggerDeactivate',
            'activate',
            'deactivate');

        this.model.on('activate', this.activate);
        this.model.on('deactivate', this.deactivate);
    },
 
    render: function() {
        console.log("ChartItemView::Render");

        $(this.el).addClass(this.model.get('id')).attr('title', this.model.get('name')).attr('active', this.model.get('active')).html(this.template(this.model.toJSON()));
        
        var genres = this.model.get('genres');
        var node = $(this.el).find(".genres");
        for (var i = 0; i < genres.length; i++) {
            node.append(this.templateGenre({ name: genres[i] }));
        }
        
        return this;
    },

    triggerClicked: function() {
        this.trigger('chart:clicked', this.model);
    },
    triggerActivate: function() {
        this.trigger('activate', this.model);
    },
    triggerDeactivate: function() {
        this.trigger('deactivate', this.model);
    },
    activate: function() {
        $(this.el).attr('active', 'true');
    },
    deactivate: function() {
        $(this.el).attr('active', 'false');
    }


});
