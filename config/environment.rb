# Load the rails application
require File.expand_path('../application', __FILE__)
myvolume_js_deps = [
    "jquery.js",
    "jquery.jplayer.min.js",
    "underscore.js",
    "backbone.js"
]
myvolume_js_app = [
    "workspace.js"
]
# Initialize the rails application
Myvolume::Application.initialize!
