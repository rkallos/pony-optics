use "ponytest"
use ".."

actor Main is TestList
  new make() => None

  fun tag tests(test: PonyTest tag) =>
    test(_CounterTest)
    test(_DistTest)
    test(_GaugeTest)
    test(_HistoTest)
    test(_QuantileTest)


class iso _CounterTest is UnitTest
  fun name(): String => "CounterTest"

  fun apply(h: TestHelper) =>
    let o: Optics = try
      Optics("CounterTest")?
    else
      h.fail("Unable to allocate optics")
      return
    end

    let counter: OpticsLens = try
      OpticsLens.counter(o, "bob_the_counter")?
    else
      h.fail("Unable to allocate lens")
      return
    end

    h.assert_eq[Bool](true, counter.record(U64(10)))
    h.assert_eq[Bool](true, counter.record(U64(20)))
    h.assert_eq[Bool](true, counter.record(U64(30)))


class iso _DistTest is UnitTest
  fun name(): String => "DistTest"

  fun apply(h: TestHelper) =>
    let o: Optics = try
      Optics("DistTest")?
    else
      h.fail("Unable to allocate optics")
      return
    end

    let dist: OpticsLens = try
      OpticsLens.dist(o, "bob_the_dist")?
    else
      h.fail("Unable to allocate lens")
      return
    end

    h.assert_eq[Bool](true, dist.record(U64(10)))
    h.assert_eq[Bool](true, dist.record(U64(20)))
    h.assert_eq[Bool](true, dist.record(U64(30)))


class iso _GaugeTest is UnitTest
  fun name(): String => "GaugeTest"

  fun apply(h: TestHelper) =>
    let o: Optics = try
      Optics("GaugeTest")?
    else
      h.fail("Unable to allocate optics")
      return
    end

    let gauge: OpticsLens = try
      OpticsLens.gauge(o, "bob_the_gauge")?
    else
      h.fail("Unable to allocate lens")
      return
    end

    h.assert_eq[Bool](true, gauge.record(U64(10)))
    h.assert_eq[Bool](true, gauge.record(U64(20)))
    h.assert_eq[Bool](true, gauge.record(U64(30)))


class iso _HistoTest is UnitTest
  fun name(): String => "HistoTest"

  fun apply(h: TestHelper) =>
    let o: Optics = try
      Optics("HistoTest")?
    else
      h.fail("Unable to allocate optics")
      return
    end

    let buckets: Array[F64] = [50.0; 90.0; 99.0; 99.9; 99.99]
    let histo: OpticsLens = try
      OpticsLens.histo(o, "bob_the_histo", buckets)?
    else
      h.fail("Unable to allocate lens")
      return
    end

    h.assert_eq[Bool](true, histo.record(U64(10)))
    h.assert_eq[Bool](true, histo.record(U64(20)))
    h.assert_eq[Bool](true, histo.record(U64(30)))


class iso _QuantileTest is UnitTest
  fun name(): String => "QuantileTest"

  fun apply(h: TestHelper) =>
    let o: Optics = try
      Optics("QuantileTest")?
    else
      h.fail("Unable to allocate optics")
      return
    end

    let quantile: OpticsLens = try
      OpticsLens.quantile(o, "bob_the_quantile", U64(50), U64(10), U64(1))?
    else
      h.fail("Unable to allocate lens")
      return
    end

    h.assert_eq[Bool](true, quantile.record(U64(10)))
    h.assert_eq[Bool](true, quantile.record(U64(20)))
    h.assert_eq[Bool](true, quantile.record(U64(30)))
    h.complete(true)
