# AbstractMessage Serialization Constants
exports.ABSTRACT_FLAGS =
  HAS_NEXT: 128
  BODY: 1
  CLIENT_ID: 2
  DESTINATION: 4
  HEADERS: 8
  MESSAGE_ID: 16
  TIMESTAMP: 32
  TIME_TO_LIVE: 64
  CLIENT_ID_BYTES: 1
  MESSAGE_ID_BYTES: 2

# AsyncMessage Serialization Constants
exports.ASYNC_FLAGS =
  CORRELATION_ID: 1
  CORRELATION_ID_BYTES: 2

# CommandMessage Serialization Constants
exports.COMMAND_FLAGS =
  OPERATION: 1
