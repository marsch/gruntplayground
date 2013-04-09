'use strict'

Chaplin = require 'chaplin'
routes = require 'routes'
config = require 'config'

module.exports = class Application extends Chaplin.Application
  initialize: ->
    console.log 'initializing application /* @echo APP_NAME */'
    @initDispatcher controllerSuffix: ''
    @initLayout()
    @initMediator()
    @initControllers()

    @initRouter routes, {route: '/', pushState: false}

    Object.freeze? @

  initMediator: ->
    Chaplin.mediator.seal()

  initControllers: ->
