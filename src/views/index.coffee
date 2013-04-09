'use strict'

View = require 'views/base/view'

module.exports = class IndexView extends View

  template: require('templates').index
  container: '[data-id="container"]'

  render: () ->
    super
    console.log 'rendered', @template

