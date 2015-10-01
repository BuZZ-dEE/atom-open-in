{$$, SelectListView} = require 'atom-space-pen-views'

{exec} = require 'child_process'
{spawn} = require 'child_process'

module.exports =
class OpenInAppView extends SelectListView
  path: null
  open: null

  activate: ->
    new OpenInAppView

  initialize: (serializeState) ->
    super
    @addClass 'open-in'

  cancelled: ->
    @hide()

  serialize: ->

  destroy: -> @detach()

  show: ->
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()

    @storeFocusedElement()

    apps = atom.config.get('open-file-in.applications').split(',')
    @setItems apps

    @focusFilterEditor()

  hide: ->
    @panel?.hide()

  toggle: () ->
    if @panel?.isVisible()
      @cancel()
    else
      @show()

  viewForItem: (app) ->
    $$ ->
      @li class: 'open-in-item', app

  confirmed: (app) =>
    @cancel()
    atom.workspace.observeTextEditors (editor) ->
      @path = atom.workspace.getActiveTextEditor().getPath()

    switch process.platform
      when 'darwin' then open = spawn '/usr/bin/open', ['-a', app, path]
      when 'win32'  then open = exec "#{app} #{path}" if path?
      when 'win64'  then open = exec "#{app} #{path}" if path?
      when 'linux'  then open = exec "#{app} #{path}" if path?

    open.stderr.on 'data', (data) ->
      console.warn "Unable to find application #{app}"
