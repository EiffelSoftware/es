// ----------------------------------------------------------------------
// Reference types

// Type definition for reference types
type ref;

// Constant for Void references
const Void: ref;

// ----------------------------------------------------------------------
// Heap and allocation

// Type of a field (with open subtype)
type Field _;

// Type of a heap (with generic field subtype and generic content type)
type HeapType = <beta>[ref, Field beta]beta;

// Function which defines a heap
function IsHeap(heap: HeapType) returns (bool);

// The global heap (which is always a heap)
var Heap: HeapType where IsHeap(Heap);

// Allocation field (a gohst field)
const unique $allocated: Field bool;

// ----------------------------------------------------------------------
// Typing

// Type definition for Eiffel types
type Type;

// Type for ANY
const unique ANY: Type;

// Type for generics
const unique G1: Type;
const unique G2: Type;
const unique G3: Type;
const unique G4: Type;
const unique G5: Type;
const unique G6: Type;
const unique G7: Type;
const unique G8: Type;
const unique G9: Type;

// All types inherit from ANY
axiom (forall t: Type :: t <: ANY);

// Type function for objects
function type_of(o: ref) returns (Type);

// ----------------------------------------------------------------------
// Helper functions

// Property that reference `o' is attached to an object of type `t' on heap `heap'.
function attached(heap: HeapType, o: ref, t: Type) returns (bool) {
	(o != Void) && (heap[o, $allocated]) && (type_of(o) <: t)
}

// Property that reference `o' is either Void or attached to an object of type `t' on heap `heap'.
function detachable(heap: HeapType, o: ref, t: Type) returns (bool) {
	(o == Void) || (attached(heap, o, t))
}

// Property that field `f' is of attached type `t'.
function attached_attribute(heap: HeapType, o: ref, f: Field ref, t: Type) returns (bool) {
	true
//	((o != Void) && (heap[o, $allocated]) && (heap[o, $initialized])) ==> (attached(heap, heap[o, f], t))
}

// Property that field `f' is of detachable type `t'.
function detachable_attribute(heap: HeapType, o: ref, f: Field ref, t: Type) returns (bool) {
	true
//	((o != Void) && (heap[o, $allocated]) && (heap[o, $initialized])) ==> (detachable(heap, heap[o, f], t))
}


// Integer boxing
const unique INTEGER: Type;

function boxed_int(i: int) returns (ref);
function unboxed_int(r: ref) returns (int);

axiom (forall i: int :: unboxed_int(boxed_int(i)) == i);
axiom (forall i1, i2: int :: (i1 == i2) ==> (boxed_int(i1) == boxed_int(i2)));
axiom (forall heap: HeapType, i: int, r: ref :: (r == boxed_int(i)) ==> attached(heap, r, INTEGER));
axiom (forall heap: HeapType, r: ref :: attached(heap, r, INTEGER) ==> boxed_int(unboxed_int(r)) == r);
axiom (forall heap: HeapType, r1, r2: ref :: (attached(heap, r1, INTEGER) && attached(heap, r2, INTEGER)) ==> (unboxed_int(r1) == unboxed_int(r2) ==> (r1 == r2)));

// Boolean boxing
const unique BOOLEAN: Type;
const unique boxed_true: ref;
const unique boxed_false: ref;

function boxed_bool(b: bool) returns (ref);
function unboxed_bool(r: ref) returns (bool);

axiom (boxed_bool(true) == boxed_true);
axiom (boxed_bool(false) == boxed_false);
axiom (unboxed_bool(boxed_true) == true);
axiom (unboxed_bool(boxed_false) == false);
axiom (boxed_true != boxed_false);
axiom (forall heap: HeapType :: attached(heap, boxed_true, BOOLEAN));
axiom (forall heap: HeapType :: attached(heap, boxed_false, BOOLEAN));
axiom (forall heap: HeapType, r: ref :: attached(heap, r, BOOLEAN) <==> (r == boxed_true || r == boxed_false));

// Bounded integers
function is_integer_8(i: int) returns (bool) {
	(-128 <= i) && (i <= 127)
}
function is_integer_32(i: int) returns (bool) {
	(-2147483648 <= i) && (i <= 2147483647)
}
function is_integer_64(i: int) returns (bool) {
	(-9223372036854775808 <= i) && (i <= 9223372036854775807)
}
function is_natural_8(i: int) returns (bool) {
	(0 <= i) && (i <= 255)
}
function is_natural_32(i: int) returns (bool) {
	(0 <= i) && (i <= 4294967295)
}
function is_natural_64(i: int) returns (bool) {
	(0 <= i) && (i <= 18446744073709551615)
}

// Integer division (from Dafny)

axiom (forall x: int, y: int :: { x % y } { x / y } x % y == x - x / y * y);
axiom (forall x: int, y: int :: { x % y } 0 < y ==> 0 <= x % y && x % y < y);
axiom (forall x: int, y: int :: { x % y } y < 0 ==> 0 <= x % y && x % y < 0 - y);
axiom (forall a: int, b: int, d: int :: { a % d, b % d } 2 <= d && a % d == b % d && a < b ==> a + d <= b);

// Real numbers
type real;

// Expanded types
type unknown;
