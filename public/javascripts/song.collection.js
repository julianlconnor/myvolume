myvolume.collections.Songs = Backbone.Collection.extend({
    model: myvolume.models.Song,
    initialize: function() {
        _.bindAll(this, 'url');
    },
    url: function() {
        return "/songs?chart_id=" + this.id;
    },
    parse: function(response) {
        return response;
    }
});
