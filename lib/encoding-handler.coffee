fs = require 'fs'

module.exports =
class EncodingHandler

  # Try to autodetect the editor's file encoding.
  # @param {editor} editor
  detectEncoding = (editor) ->
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
      console.log encoding

  # Verify and changes the active editor's encoding.
  handle: ->
    activeEditor = atom.workspace.getActiveTextEditor()
    scopeDescriptor = activeEditor?.getRootScopeDescriptor()
    defaultEncoding = atom.config.get('defaultEncoding', { scope: scopeDescriptor })

    if defaultEncoding?
      activeEditor?.setEncoding(defaultEncoding)
    else
      useAutoDetect = atom.config.get 'default-encoding.useAutoDetect'
      console.log useAutoDetect

      # No config found, try to autodetect.
      if useAutoDetect
        detectEncoding(activeEditor)
