(function($) {

    var ChartModel = Backbone.Model.extend({
        
        defaults: function() {
            return {
                active: false
            };
        },
        
        isInactive: function() {
            this.set({ active: false });
        },
        
        isActive: function() {
            this.set({ active: true });
        }

    });

    var ChartList = Backbone.Collection.extend({
        
        model: ChartModel,
        url: "/charts"

    });

    window.Charts = new ChartList;

    var ChartsView = Backbone.View.extend({
        el: $("#charts"),

        initialize: function() {
             console.log("ChartsView::Init");
             _.bindAll(this, "render", "addOne", "addAll");

            Charts.bind("reset", this.addAll, this);
            Charts.fetch();

            this.render();
        },

        render: function() {
            console.log("ChartsView::Render");
            console.log(this.el);
            return this;
        },
        
        addOne: function(result) {
            console.log("ChartsView::addOne");
            var chart = new ChartItemView({model: result});
            $(this.el).append(chart.render().el);
        },
        
        addAll: function() {
            console.log("ChartsView::addAll");
            window.activeChartModel = Charts.models[0];
            window.activeChartModel.isActive();
            Charts.each(this.addOne);
        }
       
    });
    
    var ChartItemView = Backbone.View.extend({
        
        //template: ich.chart_item_template({ chart: this.model}),
        events: {
            "click div.chart": "activateChart"
            
        },
        
        initialize: function() {
            console.log("ChartItemView::Init");
            _.bindAll(this, 'render', "activateChart");
            Charts.bind("change", this.render, this);
        },
     
        render: function() {
            console.log("ChartItemView::Render");

            console.log(this.model.toJSON());
            var template = ich.chart_item_template(this.model.toJSON());
            $(this.el).html(template);
            
            var genres = this.model.attributes.genres;
            var node = $(this.el).find(".genres");
            for (var i = 0; i < genres.length; i++) {
                node.append(ich.genre_item_template({ name: genres[i] }));
            }
            
            return this;
        },
     
        activateChart: function() {
            window.activeChartModel.isInactive();
            window.activeChartModel = this.model;
            window.activeChartModel.isActive();
        }   
    
    });
      

    window.AppView = Backbone.View.extend({
        el: $("body"),

        initialize: function() {
            console.log("AppView::Init");
            window._ChartsView = new ChartsView;
        }
    });

    window.App = new AppView;

})(jQuery);
