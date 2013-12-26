struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

module.exports = struct ->
  @read = ->
    output = 0
    b = @read uint8
    return b if b < 0x80

    output = (b & 0x7F) << 7
    b = @read uint8
    return (output | b) if b < 0x80

    output = (output | (b & 0x7F)) << 7
    b = @read uint8
    return (output | b) if b < 0x80

    output = (output | (b & 0x7F)) << 8
    b = @read uint8
    return (output | b)

  @write = (n) ->
    if n < 0x80
      @write uint8, n
    else if n < 0x4000
      @write uint8, ((n >> 7 & 0x7f) | 0x80) # Shift bits by 7 to fill 1st byte and set next byte flag
      @write uint8, (n & 0x7f) # Shift bits by 7 to fill 2nd byte, leave next byte flag unset
    else if n < 0x200000
      @write uint8, ((n >> 14 & 0x7f) | 0x80)
      @write uint8, ((n >> 7 & 0x7f) | 0x80)
      @write uint8, (n & 0x7f)
    else if n < 0x40000000
      @write uint8, ((n >> 22 & 0x7f) | 0x80)
      @write uint8, ((n >> 15 & 0x7f) | 0x80)
      @write uint8, ((n >> 8 & 0x7f) | 0x80) # Shift bits by 8, since we can use all bits in the 4th byte
      @write uint8, (n & 0xff)
    else throw new Error "int too big"

