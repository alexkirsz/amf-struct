struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

UInt29 = require './uint29'

module.exports = struct (meta) ->
  @read = ->
    ref = @read UInt29
    if (ref & 1) is 0
      return meta.objects[ref >> 1]

    len = ref >> 1
    array = (@read uint8 for i in [0...len])
    meta.objects.push array
    return array
