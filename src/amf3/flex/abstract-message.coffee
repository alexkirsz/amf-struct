struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

Flags = require './flags'
FLAGS = (require './const').ABSTRACT_FLAGS

module.exports = struct (meta) ->
  @read = ->
    message = {}

    flagsArray = @read Flags
    for flags, i in flagsArray
      reservedPosition = 0

      if i is 0
        message.body = @read meta.amf3.type if (flags & FLAGS.BODY)
        message.clientId = @read meta.amf3.type if (flags & FLAGS.CLIENT_ID)
        message.destination = @read meta.amf3.type if (flags & FLAGS.DESTINATION)
        message.headers = @read meta.amf3.type if (flags & FLAGS.HEADERS)
        message.messageId = @read meta.amf3.type if (flags & FLAGS.MESSAGE_ID)
        message.timestamp = @read meta.amf3.type if (flags & FLAGS.TIMESTAMP)
        message.timeToLive = @read meta.amf3.type if (flags & FLAGS.TIME_TO_LIVE)
        reservedPosition = 7
      else if i is 1
        message.clientIdBytes = @read meta.amf3.type if (flags & FLAGS.CLIENT_ID_BYTES)
        message.messageIdBytes = @read meta.amf3.type if (flags & FLAGS.MESSAGE_ID_BYTES)
        reservedPosition = 2

      # For forwards compatibility, read in any other flagged objects to
      # preserve the integrity of the input stream...
      if (flags >> reservedPosition) and reservedPosition < 6
        for j in [reservedPosition...6]
          @read meta.amf3.type if ((flags >> j) & 1)

    return message
