struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

module.exports = struct ->
  @read = ->
    @read double

  @write = (n) ->
    @write double, n
