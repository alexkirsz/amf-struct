struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

module.exports = struct (len) ->
  @read = ->
    @read (struct.string len, 'utf8')

  @write = (utf8) ->
    @write (struct.string 'utf8'), utf8
