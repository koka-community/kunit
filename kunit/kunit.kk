pub effect kassertion
  fun pass() : ()
  fun fail(
    assertion-function-name: string,
    koka-file-line: string,
    expected: string,
    actually: string) : ()
  fun fatal(message:string): ()

pub effect kunit
  fun test(test-name:string, body: () -> <pure,kassertion, kscenario> (), ?kk-module:string) : ()
  fun skip(test-name:string, body: () -> <pure,kassertion, kscenario> (), ?kk-module:string) : ()

pub effect kscenario
  fun scenario(inputs:a, ?show: a -> string) : ()
  
pub fun assert/equal(expected:a, actual:a, ?eq:(a,a) -> pure bool, ?show:a -> pure string, ?kk-file-line:string) : <pure,kassertion> ()
  if eq(expected, actual)
    then pass()
    else fail(
        assertion-function-name = "assert/equal",
        koka-file-line = kk-file-line,
        expected = expected.show,
        actually = actual.show)

pub fun scenarios(inputs: () -> list<a>, body: a -> <pure,kassertion> (), ?show: a -> string) : (() -> <pure, kassertion, kscenario> ())
  fn() inputs().list/foreach(fn(i) 
    scenario(i)
    body(i)
  )

pub fun defaultKUnitHandler(action: () -> kunit ()) : io ()
  var testname := ""
  var modulename := ""
  var inputsShow := ""

  with handler
    fun scenario(inputs, show)
      inputsShow := inputs.show

  with handler
    fun pass()
      println("passed: " ++ modulename ++ " \"" ++ testname ++ "\"" ++ (if inputsShow == "" then  "" else ", scenario: (" ++ inputsShow ++")"))
    fun fail(assertion-function-name, koka-file-line, expected, actually)
      println("failed: " ++ modulename ++ " \"" ++ testname ++ "\", scenario: (" ++ inputsShow ++")\n  " ++ assertion-function-name ++ " failure at " ++ koka-file-line ++ "\n    expected: " ++ expected ++ "\n    actually: " ++ actually)
    fun fatal(message)
      println("fatal: " ++ message)

  with handler
    fun test(test-name, body, module-name)
      modulename := module-name
      testname := test-name
      body()
    fun skip(test-name, body, module-name)
      modulename := module-name
      testname := test-name
      println("skipped: " ++ modulename ++ " \"" ++ testname ++ "\"")

  action()