type Set T = [T]bool;

// ----------------------------------------------------------------------
// Reference types

type ref; // Type definition for reference types
const Void: ref; // Constant for Void references

// ----------------------------------------------------------------------
// Heap and allocation

type Field _; // Type of a field (with open subtype)
type HeapType = <beta>[ref, Field beta]beta; // Type of a heap (with generic field subtype and generic content type)

// Function which defines a heap
function IsHeap(heap: HeapType) returns (bool);

// The global heap (which is always a heap)
var Heap: HeapType where IsHeap(Heap);

const unique $allocated: Field bool; // Ghost field for allocation status of objects

// ----------------------------------------------------------------------
// Typing

type Type; // Type definition for Eiffel types
const unique ANY: Type; // Type for ANY
const unique NONE: Type; // Type for NONE

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

// Type function for objects.
function type_of(o: ref) returns (Type);

// Typing axioms
axiom (forall t: Type :: t <: ANY); // All types inherit from ANY.
axiom (forall t: Type :: NONE <: t); // NONE inherits from all types.
axiom (forall h: HeapType :: h[Void, $allocated]); // Void is always allocated.
axiom (forall h: HeapType, f: Field ref, o: ref :: h[o, $allocated] ==> h[h[o, f], $allocated]); // All reference fields are allocated.
axiom (forall r: ref :: (r == Void) <==> (type_of(r) == NONE)); // Void is only reference of type NONE.
axiom (forall a, b: ref :: (type_of(a) != type_of(b)) ==> (a != b)); // Objects that have different dynamic type cannot be aliased.

// ----------------------------------------------------------------------
// Ownership

const unique $closed: Field bool; // Ghost field for open/closed status of an object.
const unique $owner: Field ref; // Ghost field for owner of an object.
const unique $owns: Field (Set ref); // Ghost field for owns set of an object.
const unique $dependents: Field (Set ref); // Ghost field for dependents set of an object.
const unique $depends: Field (Set ref); // Ghost field for depends set of an object.

// Is o free? (owner is open)
function is_free(h: HeapType, o: ref): bool {
	h[o, $owner] == Void
}

// Is o wrapped in h? (closed and free)
function is_wrapped(h: HeapType, o: ref): bool {
	h[o, $closed] && is_free(h, o)
}

// Is o open in h? (not closed and free)
function is_open(h: HeapType, o: ref): bool {
	!h[o, $closed]
}





// ----------------------------------------------------------------------
// Features and argument types

// Type for feature constants.
type Feature;

// Argument type of argument `i' of feature `f' of type `t'.
function argument_type(t: Type, f: Feature, i: int) returns (Type);

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
function is_integer_16(i: int) returns (bool) {
	(-32768 <= i) && (i <= 32767)
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
function is_natural_16(i: int) returns (bool) {
	(0 <= i) && (i <= 65535)
}
function is_natural_32(i: int) returns (bool) {
	(0 <= i) && (i <= 4294967295)
}
function is_natural_64(i: int) returns (bool) {
	(0 <= i) && (i <= 18446744073709551615)
}

// Conversion from real to bounded integers

function real_to_integer_32(r: real) returns (int);
axiom (forall r: real :: { real_to_integer_32(r) } is_integer_32(int(r)) ==> real_to_integer_32(r) == int(r));
axiom (forall r: real :: { real_to_integer_32(r) } (!is_integer_32(int(r)) && r < 0.0) ==> real_to_integer_32(r) == -2147483648);
axiom (forall r: real :: { real_to_integer_32(r) } (!is_integer_32(int(r)) && r > 0.0) ==> real_to_integer_32(r) ==  2147483647);

function real_to_integer_64(r: real) returns (int);
axiom (forall r: real :: { real_to_integer_64(r) } is_integer_64(int(r)) ==> real_to_integer_64(r) == int(r));
axiom (forall r: real :: { real_to_integer_64(r) } (!is_integer_64(int(r)) && r < 0.0) ==> real_to_integer_64(r) == -9223372036854775808);
axiom (forall r: real :: { real_to_integer_64(r) } (!is_integer_64(int(r)) && r > 0.0) ==> real_to_integer_64(r) ==  9223372036854775807);

procedure REAL_32.truncated_to_integer_32(arg: real) returns (result: int);
	ensures result == real_to_integer_32(arg);

procedure REAL_32.truncated_to_integer_64(arg: real) returns (result: int);
	ensures result == real_to_integer_64(arg);

procedure REAL_64.truncated_to_integer_32(arg: real) returns (result: int);
	ensures result == real_to_integer_32(arg);

procedure REAL_64.truncated_to_integer_64(arg: real) returns (result: int);
	ensures result == real_to_integer_64(arg);

// Conversion from integers to reals

procedure INTEGER_32.to_double(arg: int) returns (result: real);
	ensures result == real(arg);

procedure INTEGER_64.to_double(arg: int) returns (result: real);
	ensures result == real(arg);

// Strings

const unique STRING_8: Type;

procedure create_manifest_string(size: int) returns (result: ref);
	requires size >= 0;
	ensures result != Void;
	ensures attached(Heap, result, STRING_8);

// Expanded types

type unknown;
