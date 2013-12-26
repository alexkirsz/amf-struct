struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

UInt29 = require './uint29'

module.exports = struct (meta) ->
  @read = ->
    ref = @read UInt29
    return meta.objects[ref >> 1] if (ref & 1) is 0

    array =
      associative: {}
      strict: []

    meta.objects.push array

    # Associative values
    key = @read meta.amf3.string
    while key isnt ''
      array.associative[key] = @read meta.amf3.type
      key = @read meta.amf3.string

    # Strict values
    len = ref >> 1
    array.strict = (@read meta.amf3.type for i in [0...len])

    return array

  @write = (array) ->
    idx = meta.objects.indexOf array
    if idx isnt -1
      ref = idx << 1
      @write UInt29, ref
    else
      ref = (array.strict.length << 1) + 1
      @write UInt29, ref
      meta.objects.push array

      for key, value of array.associative
        @write meta.amf3.string, key
        @write meta.amf3.type, value
      @write meta.amf3.string, ''

      for value, i in array.strict
        @write meta.amf3.type, value

