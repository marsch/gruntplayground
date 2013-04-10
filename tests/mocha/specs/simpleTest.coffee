'use strict'

describe 'test setup', () ->
  it 'should run the tests', () ->
    '1'.should.be.a 'string'
    '1'.should.be.equal '1'
    expect(1).to.be.equal 1

  it 'should find the compiled source and loaded with requirejs', (done) ->
    require ['app'], (Application) ->
      should.exist(Application)
      done()

describe 'application init', () ->
  it 'should fill the #testbed with the index-view', (done) ->
    require ['app', 'chaplin'], (Application, Chaplin) ->
      console.log 'happy load'
      app = new Application()
      app.initialize()
      mediator = Chaplin.mediator

      mediator.subscribe 'startupController', () =>
        console.log 'addedToDOM fired'
        expect($('[data-id="container"]').find('[data-id="index-view"]').length).to.be.equal(1)

        app.dispose()
        done()

describe 'index view', () ->
  IndexViewClass = null
  view = null
  testbedSelector = '[data-id="container"]'

  beforeEach (done) ->
    console.log 'beforeEach'
    require ['views/index'], (IndexView) ->
      IndexViewClass = IndexView
      done()

  afterEach (done) ->
    console.log 'afterEach'
    #view.dispose()
    #view = null
    done()


  it 'should attach to the right container', (done) ->
    view = new IndexViewClass container: $(testbedSelector)
    expect(view.el.parentNode).to.be $(testbedSelector).get(0)
    done()

  it 'should render the given template', (done) ->

    view = new IndexViewClass container: $(testbedSelector)
    tplFunc = view.getTemplateFunction()

    #a bit confusing but the view, compiles mustache internally
    lowercaseTemplate = tplFunc(view).toLowerCase()
    lowercaseInnerhtml = view.$el.html().toLowerCase()

    expect(lowercaseInnerhtml).to.be lowercaseTemplate
    done()

  it 'should unbind the modelbinder if exists', (done) ->
    view = new IndexViewClass container: $(testbedSelector)
    view.modelBinder = {}
    view.modelBinder.unbind = sinon.spy()
    view.dispose()
    expect(view.modelBinder.unbind).was.calledOnce()
    done()
