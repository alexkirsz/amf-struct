struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

UTF8 = require './utf8'
UInt29 = require './uint29'

module.exports = struct (meta) ->
  @read = ->
    ref = @read UInt29
    if (ref & 1) is 0
      return meta.strings[ref >> 1]

    len = ref >> 1
    str = ''
    if len > 0
      str = @read (UTF8 len)
      meta.strings.push str
    return str

  @write = (string) ->
    idx = meta.strings.indexOf string
    if idx isnt -1
      ref = idx << 1
      @write UInt29, ref
      return

    len = Buffer.byteLength string, 'utf8'
    ref = (len << 1) + 1
    @write UInt29, ref

    if len isnt 0
      meta.strings.push string
      @write UTF8, string

