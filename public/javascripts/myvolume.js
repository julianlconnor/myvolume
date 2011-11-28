(function($) {


    var Router = Backbone.Router.extend({
      
      routes: {
        "charts/:id"  : "showChart",
        ""            : "showIndex"
      },
      
      showChart: function(chartId) {
        console.log("Router::showChart");
        if (typeof window._ChartsView === 'undefined') window._ChartsView = new ChartsView(chartId);
        if (typeof window._ChartSongsView === 'undefined') window._ChartSongsView = new ChartSongsView(chartId);
      },

      showIndex: function() {
        console.log("Router::showIndex");
        if (typeof window._ChartsView === 'undefined') window._ChartsView = new ChartsView;
      },

      startApp: function() {
        //if (typeof window.App === 'undefined') window.App = new 
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
            this.goTo();
        },

        goTo: function() {
            window._Router.navigate( 'charts/'+this.get('id'), true);
        }

    });

    var ChartList = Backbone.Collection.extend({
        
        model: ChartModel,
        url: "/charts"



    });

    window.Charts = new ChartList;

    var ChartsView = Backbone.View.extend({
        el: $("#charts"),

        initialize: function(chartId) {
             console.log("ChartsView::Init");
             _.bindAll(this, "render", "addOne", "addAll");

            Charts.bind("reset", this.addAll, this);

            if (typeof chartId !== 'undefined') Charts.fetch({ data: { top: chartId }});
            else Charts.fetch();

            this.render();
        },

        render: function() {
            console.log("ChartsView::Render");
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
        tagName: 'div',

        className: 'chart clearfix',
        
        events: {
            "click": "activateChart"
        },
        
        initialize: function() {
            console.log("ChartItemView::Init");
            _.bindAll(this, 'render', "activateChart");
            console.log(this);
            this.model.bind('change', this.render);
        },
     
        render: function() {
            console.log("ChartItemView::Render");

            var template = ich.chart_item_template(this.model.toJSON());
            $(this.el)
            .addClass(this.model.get('id'))
            .attr('title', this.model.get('name'))
            .attr('active', this.model.get('active'))
            .html(template);
            
            var genres = this.model.attributes.genres;
            var node = $(this.el).find(".genres");
            for (var i = 0; i < genres.length; i++) {
                node.append(ich.genre_item_template({ name: genres[i] }));
            }
            
            return this;
        },
     
        activateChart: function() {
            console.log("ChartItemView::activateChart");
            window.activeChartModel.isInactive();
            window.activeChartModel = this.model;
            window.activeChartModel.isActive();
        }
    
    });
      

    window.AppView = Backbone.View.extend({
        el: $("body"),

        initialize: function() {
            console.log("AppView::Init");
            Backbone.history.start();
        }
    });
    window.App = new AppView;

})(jQuery);
