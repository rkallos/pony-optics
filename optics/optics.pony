"""
Pony-optics provides C bindings for the Optics metrics gathering library.
"""

use "lib:optics"

// Pointer types

primitive _OpticsPtr
primitive _LensPtr

class Optics
  let name: String
  let ptr: Pointer[_OpticsPtr]

  new create(name': String) ? =>
    ptr = @optics_create[Pointer[_OpticsPtr]](name'.cstring())

    if ptr.is_null() then
      error
    end

    name = name'

  new create_at(name': String, now: U64) ? =>
    ptr = @optics_create_at[Pointer[_OpticsPtr]](name'.cstring(), now)

    if ptr.is_null() then
      error
    end

    name = name'

  fun _final() =>
    @optics_close[Pointer[U8]](ptr)

  fun _epoch(): USize =>
    @optics_epoch[USize](ptr)
