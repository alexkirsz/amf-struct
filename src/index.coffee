struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

Message = require './message'

module.exports = struct ->
  @read = ->
    version = @read uint16

    nHeaders = @read uint16
    headers = (@read Header for i in [0...nHeaders])

    nMessages = @read uint16
    messages = (@read Message for i in [0...nMessages])
    
    return { version, headers, messages }

  @write = (amf) ->
    @write uint16, amf.version

    @write uint16, amf.headers.length
    @write Header, header for header in amf.headers

    @write uint16, amf.messages.length
    @write Message, message for message in amf.messages
