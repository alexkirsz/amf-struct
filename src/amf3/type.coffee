struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

{ TYPES } = require './const'
Int = require './int'
_Array = require './array'

Undefined = struct ->
  @read = ->
    return undefined
  @write = ->

Null = struct ->
  @read = ->
    return null
  @write = ->

False = struct ->
  @read = ->
    return false
  @write = ->

True = struct ->
  @read = ->
    return true
  @write = ->

getType = (type, meta) ->
  switch type
    when TYPES.UNDEFINED then Undefined
    when TYPES.NULL then Null
    when TYPES.FALSE then False
    when TYPES.TRUE then True
    when TYPES.INTEGER then Int
    when TYPES.DOUBLE then throw new Error "not implemented: #{type}"
    when TYPES.STRING then meta.amf3.string
    when TYPES.XML_DOC then throw new Error "not implemented: #{type}"
    when TYPES.DATE then throw new Error "not implemented: #{type}"
    when TYPES.ARRAY then meta.amf3.array
    when TYPES.OBJECT then meta.amf3.object
    when TYPES.XML then throw new Error "not implemented: #{type}"
    when TYPES.BYTE_ARRAY then throw new Error "not implemented: #{type}"
    else throw new Error "unsupported AMF3 type: #{type}"

module.exports = struct (meta) ->
  @read = ->
    type = @read uint8
    value = @read (getType type, meta)
    return { value, type }

  @write = (data) ->
    @write uint8, data.type
    @write (getType data.type, meta), data.value
