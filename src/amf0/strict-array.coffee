struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

module.exports = struct (meta) ->
  @read = ->
    count = @read uint32
    values = (@read meta.amf0.type for i in [0...count])
    return values

  @write = (array) ->
    @write uint32, array.length
    @write meta.amf0.type, item for item in array
