struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

{ TYPES } = require './const'

getType = (type, meta) ->
  switch type
    when TYPES.STRICT_ARRAY then meta.amf0.strictArray
    when TYPES.AMF3 then meta.amf3.type
    else throw new Error "unsupported AMF0 type: #{type}"

module.exports = struct (meta) ->
  @read = ->
    type = @read uint8
    value = @read (getType type, meta)
    return { type, value }

  @write = (data) ->
    @write uint8, data.type
    @write (getType data.type, meta), data.value

