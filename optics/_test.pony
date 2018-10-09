use "ponytest"
use unit_suite = "tests"
//use bench = "bench"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest tag) =>
    unit_suite.Main.make().tests(test)
    //bench.Main.make().tests(test)
