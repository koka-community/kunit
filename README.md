# KUnit
Inspired by XUnit.
## Features
### Test Suites
A file represents a test suite, and is included in the test runner output.
**/tests/fizzbuzz.kk:**
```koka
pub fun tests() [
    test("Given 3 then returns fizz", fn()
        // ...        
    ),
    test("Given 5 then returns buzz", fn()
        // ...
    )
]
```
**output:**
```koka
passed: tests/fizzbuzz "Given 3 then returns fizz"
passed: tests/fizzbuzz "Given 5 then returns buzz"
```

### Test Skipping
**/tests/foobar.kk:**
```koka
pub fun tests() [
    skip("Given foo then returns bar", fn()
        // todo
    )
]
```
**output:**
```koka
skipped: tests/foobar "Given foo then returns bar"
```
### Test Scenarios
**/tests/wordassert.kk:**
```koka
pub fun words/count(input)
  input.split(" ").length

pub fun tests() [
  test("Given some words, returns the expected word count.",
    scenarios(fn() [
      (("some example string", 3)),
      (("another example string", 3)),
      (("yet another example string", 3))
    ], fn((input, expected))
      val actual = words/count(input)
      assert/equal(expected, actual, int/(==))
  ))
]
```
**output:**
```koka
passed: tests/wordassert "Given some words, returns the expected word count.", scenario: (("some example string",3))
passed: tests/wordassert "Given some words, returns the expected word count.", scenario: (("another example string",3))
failed: tests/wordassert "Given some words, returns the expected word count.", scenario: (("yet another example string",3))
  assert/equal failure at tests/wordassert.kk(13)
    expected: 3
    actually: 4
```

## Quick Start
Build the `main.kk` test file and execute the generated file to run tests and see test run output.
```
> koka example/tests/main.kk

load    : ...
parse   : ...
check   : ...
link    : ...
created : .koka/v3.1.1/gcc-debug-4147b9/example_tests_main__main

> .koka/v3.1.1/gcc-debug-4147b9/example_tests_main__main

passed: example/tests/parse "given an empty input string, then the json/parse returns Json(Element(Null))"
passed: example/tests/parse "given the input of an empty double quotes, then the json/parse returns Json(Element(String("")))"
failed: example/tests/parse "given the input of some ascii string, then the json/parse returns Json(Element(String("<expected-ascii-string>")))", scenario: ("some example string")
  assert/equal failure at example/tests/parse.kk(44)
    expected: Json(Element(String("some example string")))
    actually: Not implemented
failed: example/tests/parse "given the input of some ascii string, then the json/parse returns Json(Element(String("<expected-ascii-string>")))", scenario: ("another example string")
  assert/equal failure at example/tests/parse.kk(44)
    expected: Json(Element(String("another example string")))
    actually: Not implemented
failed: example/tests/parse "given the input of some ascii string, then the json/parse returns Json(Element(String("<expected-ascii-string>")))", scenario: ("yet another example string")
  assert/equal failure at example/tests/parse.kk(44)
    expected: Json(Element(String("yet another example string")))
    actually: Not implemented
skipped: example/tests/parse "todo: complete this test"
```
