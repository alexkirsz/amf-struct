struct = require 'binary-struct'
{ int8, uint8, int16, uint16, int24, uint24, int32, uint32, int64, uint64, float, double } = struct.be

{ CLASS_ALIAS_REGISTRY } = require './const'
UInt29 = require './uint29'

module.exports = struct (meta) ->
  @read = ->
    ref = @read UInt29
    if (ref & 1) is 0
      return meta.objects[ref >> 1]

  ﻿  # Read traits
    if (ref & 2) is 0
      traits = meta.traits[ref >> 2]
    else
      isExternalizable = (ref & 4) is 4
      isDynamic = (ref & 8) is 8

      className = @read meta.amf3.string

      classMemberCount = ref >> 4
      classMembers = (@read meta.amf3.string for i in [0...classMemberCount])
      
      traits = { className, classMembers, isExternalizable, isDynamic }

      meta.traits.push traits

    # Check for any registered class aliases 
    aliasedClass = CLASS_ALIAS_REGISTRY[traits.className];
    if aliasedClass?
      traits.className = aliasedClass
    
    object = {}

    meta.objects.push object

    if traits.isExternalizable
      # Read Externalizable
      throw new Error "unsupported externalizable"
      # try
      #   if (traits.className.indexOf 'flex.') is 0
      #     # Try to get a class
      #     classParts = traits.className.split '.'
      #     unqualifiedClassName = classParts[classParts.length - 1]
      #     if unqualifiedClassName and flex[unqualifiedClassName]
      #       object = @read flex[unqualifiedClassName]
      #     else
      #       object = @read meta.amf3.type
      # catch e
      #   throw new Error "unable to read externalizable data type '#{traits.className}': #{e}"

    else
      object.members = {}
      for key in traits.classMembers
        value = @read meta.amf3.type
        object.members[key] = value

      if traits.isDynamic
        object.dynamic = {}
        key = @read meta.amf3.string
        while key isnt ''
          value = @read meta.amf3.type
          object.dynamic[key] = value
          key = @read meta.amf3.string

    object.traits = traits
    return object

  @write = (object) ->
    idx = meta.objects.indexOf object
    if idx isnt -1
      ref = idx << 1
      @write UInt29, ref
      return

    { traits } = object
    idx = meta.traits.indexOf traits
    if idx isnt -1
      ref = idx << 2 + 1
      @write UInt29, ref
    else
      isDynamic = if traits.isDynamic then 1 else 0
      isExternalizable = if traits.isExternalizable then 1 else 0
      ref = (traits.classMembers.length << 4) + (isDynamic << 3) + (isExternalizable << 2) + 3
      @write UInt29, ref
      @write meta.amf3.string, traits.className
      @write meta.amf3.string, classMember for classMember in traits.classMembers
      meta.traits.push traits
  

    if traits.isExternalizable
      throw new Error "unsupported externalizable"
    else
      for key in traits.classMembers
        @write meta.amf3.type, object.members[key]

      if traits.isDynamic
        for key, value of object.dynamic
          @write meta.amf3.string, key
          @write meta.amf3.type, value
        @write meta.amf3.string, ''


