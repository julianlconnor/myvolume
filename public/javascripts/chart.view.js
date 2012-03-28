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
        _.bindAll(this, 'render', 'triggerClicked');
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
        this.trigger('clicked', this.model);
        $('[active="true"]').attr('active', 'false');
        $(this.el).attr('active', 'true');
    }

});
