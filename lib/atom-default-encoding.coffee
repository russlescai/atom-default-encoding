{CompositeDisposable} = require 'atom'
EncodingHandler = require './encoding-handler'

module.exports = AtomDefaultEncoding =
  subscriptions: null
  encodingHandler: null

  config:
    useAutoDetect:
      title: 'Use Auto Detect'
      description: 'Auto detect file encoding if default is not configured.'
      type: 'boolean'
      default: true

  activate: ->
    @enabled();

  enabled: ->
    @subscriptions ?= new CompositeDisposable
    @encodingHandler ?= new EncodingHandler()

    @subscriptions.add atom.workspace.observeTextEditors => @encodingHandler.handle()
    @subscriptions.add atom.workspace.onDidChangeActivePaneItem => @encodingHandler.handle()

  disabled: ->
    @subscriptions?.dispose()
    @subscriptions = null
    @encodingHandler = null

  toggle: ->
    if not @subscriptions?
      @enabled()
    else
      @disabled()
