fs = require 'fs'
{CompositeDisposable} = require 'atom'

module.exports = AtomDefaultEncoding =

  activate: (state) ->
    atom.workspace.onDidOpen (openEventArgs) ->
      editor = atom.workspace.getActiveTextEditor()
      scopeDescriptor = editor?.getRootScopeDescriptor()
      defaultEncoding = atom.config.get('defaultEncoding', { scope: scopeDescriptor })

      if defaultEncoding?
        editor?.setEncoding(defaultEncoding)
      else
        # No config found, try to autodetect.
        filePath = editor?.getPath()
        return unless fs.existsSync(filePath)

        jschardet = require 'jschardet'
        iconv = require 'iconv-lite'
        fs.readFile filePath, (error, buffer) =>
          return if error?

          {encoding} =  jschardet.detect(buffer) ? {}
          encoding = 'utf8' if encoding is 'ascii'
          return unless iconv.encodingExists(encoding)

          encoding = encoding.toLowerCase().replace(/[^0-9a-z]|:\d{4}$/g, '')
          editor.setEncoding(encoding)
