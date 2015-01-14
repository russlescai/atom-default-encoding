{CompositeDisposable} = require 'atom'

module.exports = AtomDefaultEncoding =

  activate: (state) ->
    atom.workspace.onDidOpen (openEventArgs) ->
      scopeDescriptor = atom.workspace.getActiveTextEditor()?.getRootScopeDescriptor()
      defaultEncoding = atom.config.get('defaultEncoding', { scope: scopeDescriptor })

      if defaultEncoding?
        atom.workspace.getActiveTextEditor()?.setEncoding(defaultEncoding)
