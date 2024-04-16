import kunit/kunit
import example/tests/parse

fun kunit/run(tests:() -> <kunit> list<()>)
  tests().foreach(fn(test) test())

fun main()
  with defaultKUnitHandler
  tests.run