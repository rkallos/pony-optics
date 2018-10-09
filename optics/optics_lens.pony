use "lib:optics"

trait _Lens
  fun record(lens: Pointer[_LensPtr] val, value: Number): Bool

primitive _Counter is _Lens
  fun alloc(optics: Optics, name: String): Pointer[_LensPtr] val ? =>
    let ptr: Pointer[_LensPtr] val =
      @optics_counter_alloc[Pointer[_LensPtr] val](optics.ptr, name.cstring())

    if ptr.is_null() then
      error
    else
      ptr
    end

  fun tag record(lens: Pointer[_LensPtr] val, value: Number): Bool =>
    @optics_counter_inc[Bool](lens, value.i64())


primitive _Dist is _Lens
  fun alloc(optics: Optics, name: String): Pointer[_LensPtr] val ? =>
    let ptr: Pointer[_LensPtr] val =
      @optics_dist_alloc[Pointer[_LensPtr] val](optics.ptr, name.cstring())

    if ptr.is_null() then
      error
    else
      ptr
    end

  fun tag record(lens: Pointer[_LensPtr] val, value: Number): Bool =>
    @optics_dist_record[Bool](lens, value.f64())


primitive _Gauge is _Lens
  fun alloc(optics: Optics, name: String): Pointer[_LensPtr] val ? =>
    let ptr: Pointer[_LensPtr] val =
      @optics_gauge_alloc[Pointer[_LensPtr] val](optics.ptr, name.cstring())

    if ptr.is_null() then
      error
    else
      ptr
    end

  fun tag record(lens: Pointer[_LensPtr] val, value: Number): Bool =>
    @optics_gauge_set[Bool](lens, value.f64())


primitive _Histo is _Lens
  fun alloc(optics: Optics, name: String, buckets: Array[F64]):
    Pointer[_LensPtr] val ? =>

    let b_ptr: Pointer[F64] tag = buckets.cpointer()
    let b_len: USize = buckets.size()
    let ptr: Pointer[_LensPtr] val =
      @optics_histo_alloc[Pointer[_LensPtr] val](optics.ptr, name, b_ptr, b_len)

    if ptr.is_null() then
      error
    else
      ptr
    end

  fun tag record(lens: Pointer[_LensPtr] val, value: Number): Bool =>
    @optics_histo_inc[Bool](lens, value.f64())

primitive _Quantile is _Lens
  fun alloc(optics: Optics, name: String, target: F64, estimate: F64,
    adjustment_value: F64): Pointer[_LensPtr] val ? =>

    let ptr: Pointer[_LensPtr] val =
      @optics_quantile_alloc[Pointer[_LensPtr] val](optics.ptr, name.cstring(),
        target, estimate, adjustment_value)

    if ptr.is_null() then
      error
    else
      ptr
    end

  fun tag record(lens: Pointer[_LensPtr] val, value: Number): Bool =>
    @optics_quantile_update[Bool](lens, value.f64())

type _LensType is (_Counter | _Dist | _Gauge | _Histo | _Quantile)


class OpticsLens
  """
  The OpticsLens class wraps all lens types in optics.
  """
  let name: String
  let optics: Optics
  let _type: _LensType
  let _ptr: Pointer[_LensPtr] val

  new counter(optics': Optics, name': String) ? =>
    _ptr = _Counter.alloc(optics', name') ?
    _type = _Counter
    optics = optics'
    name = name'

  new dist(optics': Optics, name': String) ? =>
    _ptr = _Dist.alloc(optics', name') ?
    _type = _Dist
    optics = optics'
    name = name'

  new gauge(optics': Optics, name': String) ? =>
    _ptr = _Gauge.alloc(optics', name') ?
    _type = _Gauge
    optics = optics'
    name = name'

  new histo(optics': Optics, name': String, buckets: Array[F64]) ? =>
    _ptr = _Histo.alloc(optics', name', buckets) ?
    _type = _Histo
    optics = optics'
    name = name'

  new quantile(optics': Optics, name': String, target_quantile: Number,
    estimate: Number, adjustment_value: Number) ? =>
    _ptr = _Quantile.alloc(optics', name', target_quantile.f64(),
      estimate.f64(), adjustment_value.f64())?
    _type = _Quantile
    optics = optics'
    name = name'

  fun ptr(): USize val =>
    _ptr.usize()

  fun record(value: Number): Bool =>
    _type.record(_ptr, value)

  fun _final(): None =>
    @optics_lens_close[Bool](_ptr)
    None
