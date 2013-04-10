'use strict'

describe 'initial test setup', ->

  it 'tests are running', ->
    expect(true).toBeTruthy()

  it 'should know the application class', ->
    require ['app'], (Application) ->
      expect(Application).toBeDefined()
      expect(Application.prototype.initialize).toBeDefined()
