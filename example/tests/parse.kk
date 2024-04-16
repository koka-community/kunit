import kunit/kunit
import example/src/json
import std/core/debug

pub fun tests() [
  test("given an empty input string, then the json/parse returns Json(Element(Null))", fn()    
    // Arrange
    val input = ""
    val expected = Ok(Json(Element(Null)))

    // Act
    val actual = input.json/parse

    // Assert
    assert/equal(expected, actual)  
  ),

  test("given the input of an empty double quotes, then the json/parse returns Json(Element(String(\"\")))", fn()    
    // Arrange
    val input = "\"\""
    val expected = Ok(Json(Element(String("\"\""))))

    // Act
    val actual = input.json/parse

    // Assert
    assert/equal(expected, actual)  
  ),

  test("given the input of some ascii string, then the json/parse returns Json(Element(String(\"<expected-ascii-string>\")))",
    scenarios(fn() [
      (("some example string")),
      (("another example string")),
      (("yet another example string"))
    ], fn((input))

    // Arrange
    val expected = Ok(Json(Element(String(input))))

    // Act
    val actual = input.json/parse

    // Assert
    assert/equal(expected, actual)  
  )),

  skip("todo: complete this test",
   scenarios(fn() [
      ((2,"2"))
   ], fn((i,s))
    assert/equal(i.show, s, ?eq=string/(==))
   ))
]

  