struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

AsyncMessage = require './async-message'
Flags = require './flags'

module.exports = struct (meta) ->
  @read = ->
    message = @read (AsyncMessage meta)

    flagsArray = @read Flags
    for flags, i in flagsArray
      reservedPosition = 0

      # For forwards compatibility, read in any other flagged objects to
      # preserve the integrity of the input stream...
      if (flags >> reservedPosition) and reservedPosition < 6
        for j in [reservedPosition...6]
          @read meta.amf3.type if ((flags >> j) & 1)

    return message
