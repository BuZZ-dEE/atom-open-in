module.exports =
  config:
    applications:
      type: 'string'
      default: 'gimp,inkscape,svgTester'

  openInAppView: null

  activate: (state) ->
    atom.commands.add 'atom-workspace',
      'open-in:toggle': =>
        @createOpenInAppView().toggle()

  createOpenInAppView: ->
    unless @openInAappView
      OpenInAppView = require './open-in-app-view'
      @openInAppView = new OpenInAppView()
    @openInAppView
