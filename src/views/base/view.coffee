'use strict'

Chaplin = require 'chaplin'
Mustache = require 'mustache'

module.exports = class View extends Chaplin.View
  autoRender: true
  getTemplateFunction: ->
    Mustache.compile @template


  dispose: () ->

    # unbinding modelBinder if exists
    if @modelBinder
      @modelBinder.unbind()

    super

