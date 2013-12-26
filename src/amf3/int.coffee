struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

UInt29 = require './uint29'

# Doesn't support signed ints
module.exports = struct ->
  @read = ->
    output = @read UInt29
    return output

  @write = (n) ->
    @write UInt29, n
