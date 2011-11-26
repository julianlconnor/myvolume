(function($) {


    var Router = Backbone.Router.extend({
      
      routes: {
        "charts/:id"  : "showChart",
        ""            : "showIndex"
      },
      
      showChart: function() {
        console.log("Router::showChart");
      },

      showIndex: function() {
        console.log("Router::showIndex");
        _Router.navigate("charts/10", true);
      }

    });

    window._Router = new Router;

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
    
    var ChartItemView = Backbone.View.extend({
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
            console.log("AppView::Init");
            window._ChartsView = new ChartsView;
            Backbone.history.start();
        }
    });

    window.App = new AppView;

})(jQuery);
