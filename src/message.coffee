struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

amf0 = require './amf0'
amf3 = require './amf3'

module.exports = struct ->
  meta = {}

  do reset = ->
    meta.objects = []
    meta.strings = []
    meta.traits = []

  meta.amf0 =
    type: amf0.Type meta
    strictArray: amf0.StrictArray meta

  meta.amf3 =
    type: amf3.Type meta
    string: amf3.String meta
    array: amf3.Array meta
    byteArray: amf3.ByteArray meta
    object: amf3.Object meta

  @read = ->
    reset()

    targetUriLen = @read uint16
    targetUri = @read (struct.string targetUriLen, 'utf8')

    responseUriLen = @read uint16
    responseUri = @read (struct.string responseUriLen, 'utf8')

    messageLen = @read uint32
    data = @read meta.amf0.type

    return { targetUri, responseUri, data }

  @write = (message) ->
    reset()

    @write uint16, message.targetUri.length
    @write (struct.string 'utf8'), message.targetUri

    @write uint16, message.responseUri.length
    @write (struct.string 'utf8'), message.responseUri

    @write uint32, 0
    messageLen = @write meta.amf0.type, message.data
    @buffer.write_offset -= messageLen + uint32.size
    @write uint32, messageLen
    @buffer.write_offset += messageLen

