struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

FLAGS = (require './const').ABSTRACT_FLAGS

module.exports = struct ->
  @read = ->
    hasNextFlag = true
    flagsArray = []
    i = 0

    while hasNextFlag
      flags = @read uint8
      flagsArray.push flags
      hasNextFlag = !!((flags & FLAGS.HAS_NEXT) != 0)

    return flagsArray
