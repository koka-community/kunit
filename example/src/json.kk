import std/num/float64
import std/core/undiv

/* See https://www.json.org/json-en.html */
type member
  Member(name:string, element:element)

type value
  Object(members:list<member>)
  Array(elements:list<element>)
  String(value:string)
  Int(value:int)
  Float(value:float64)
  Bool(value:bool)
  Null

type element
  Element(value: value)

type json
  Json(element:element)

fun member/(==)(left: member, right: member) : pure bool
  match (left, right) 
    (Member(lname, lelement), Member(rname, relement)) -> 
      string/(==)(lname,rname) && element/(==)(lelement, relement)

fun members/(==)(left:list<member>, right:list<member>) : pure bool
  match (left, right)
    (Cons(l,ls), Cons(r,rs)) ->
      member/(==)(l,r) && members/(==)(ls,rs)
    ([],[]) -> True
    _ -> False

fun element/(==)(left: element, right: element): pure bool
  match (left, right) 
    (Element(lvalue), Element(rvalue)) ->
      match (lvalue, rvalue)
        (Object(lmembers),Object(rmembers)) -> members/(==)(lmembers, rmembers)
        (Array(lelements),Array(relements)) -> elements/(==)(lelements, relements)
        (String(lvalue),String(rvalue)) -> lvalue == rvalue
        (Int(lvalue),Int(rvalue)) -> lvalue == rvalue
        (Float(lvalue),Float(rvalue)) -> float64/(==)(lvalue, rvalue)
        (Bool(lvalue),Bool(rvalue)) -> lvalue == rvalue
        (Null,Null) -> True
        _ -> False

fun elements/(==)(left:list<element>, right:list<element>): pure bool
  match (left, right)
    (Cons(l,ls), Cons(r,rs)) ->
      element/(==)(l,r) && elements/(==)(ls,rs)
    ([],[]) -> True
    _ -> False

pub fun json/(==)(left: json, right: json)
  match (left, right)
    (Json(lelement),Json(relement)) -> element/(==)(lelement, relement)

fun elements/show(elements:list<element>)
  elements.map(element/show).joinsep/join(", ")

fun member/show(member:member)
  match member
    Member(name, element) -> "Member(name=\""++name++"\", element="++element/show(element)++")"

fun members/show(members:list<member>)
  members.map(member/show).joinsep/join(", ")

fun value/show(value:value)
  match value
    Object(members) -> "Object(["++members/show(members)++"])"
    Array(elements) -> "Array(["++elements/show(elements)++"])"
    String(value) -> "String(\""++value++"\")"
    Int(value) -> "Number("++int/show(value)++")"
    Float(value) -> "Number("++float64/show(value)++")"
    Bool(value) -> "Bool("++bool/show(value)++")"
    Null -> "Null"

fun element/show(element:element)
  match element
    Element(value) -> "Element("++value/show(value)++")"

pub fun json/show(json:json)
  match json
    Json(element) -> "Json("++element/show(element)++")"

pub fun result/show(result:error<json>) : pure string
  match result
    Ok(json) -> json/show(json)
    Error(x) -> exn/show(x)

pub fun eq(left:error<json>, right:error<json>) : pure bool
  match (left,right)
    (Ok(l),Ok(r)) -> l == r
    (Error(l), Error(r)) -> l.message == r.message
    _ -> False

fun parse(input:string) : total error<json>

  with handler<exn>
    final ctl throw-exn(exn)
      Error(exn)

  match input
    "" -> Ok(Json(Element(Null)))
    "\"\"" -> Ok(Json(Element(String("\"\""))))
    _ -> throw("Not implemented")

  