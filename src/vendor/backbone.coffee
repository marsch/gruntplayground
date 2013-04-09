'use strict'

require 'depend!../../vendor/js/backbone/backbone[jquery,underscore]'

# Ensure we're working with an unmodified version of Backbone.
Backbone = window.Backbone.noConflict()

# Require any backbone extensions here; attaching as neccessary.
# Example:
#   require 'backbone-stickit'

#Backbone.ModelBinder = require '../vendor/js/backbone.modelbinder/Backbone.ModelBinder'

#require '../vendor/js/backbone.paginator/backbone.paginator'


# Export the backbone library.
module.exports = Backbone
