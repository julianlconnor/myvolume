(function($) {

    window.ChartModel = Backbone.Model.extend({
        
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

    window.ChartList = Backbone.Collection.extend({
        
        model: ChartModel,
        url: "/charts"

    });

    window.Charts = new ChartList;

    window.ChartsView = Backbone.View.extend({
        //template: _.template($("chart-template").html()),
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
            console.log(this);
            $(this.el).html("<div class='chart_list'></div>");
            return this;
        },
        
        addOne: function(result) {
            console.log("ChartsView::addOne");
            var chart = new ChartItemView({model: result});
            $(this.el).append(chart.render().el);
        },
        
        addAll: function() {
            console.log("ChartsView::addAll");
            Charts.each(this.addOne);
        }
       
    });
    
    window.ChartItemView = Backbone.View.extend({
        initialize: function() {
            console.log("ChartItemView::Init");
            _.bindAll(this, 'render');
            Charts.bind("change", this.render, this);
        },
     
        render: function() {
            console.log("ChartItemView::Render");
            $(this.el).html("<div class='chart'>" + "lolol" + "</div>");
            return this;
        }   
    
    });

    window.AppView = Backbone.View.extend({
        el: $("body"),

        initialize: function() {
            console.log("AppView yay");
            var view = new ChartsView();
        }
    });

    window.App = new AppView;

})(jQuery);
