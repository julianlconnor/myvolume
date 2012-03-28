myvolume.collections.Songs = Backbone.Collection.extend({
    model: myvolume.models.Song,
    url: "/songs"
});
