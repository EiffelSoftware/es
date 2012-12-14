// ----------------------------------------------------------------------
// Sets

type Set T = [T]bool;

function Set#Empty<T>(): Set T;
axiom (forall<T> o: T :: { Set#Empty()[o] } !Set#Empty()[o]);

function Set#Singleton<T>(T): Set T;
axiom (forall<T> r: T :: { Set#Singleton(r) } Set#Singleton(r)[r]);
axiom (forall<T> r: T, o: T :: { Set#Singleton(r)[o] } Set#Singleton(r)[o] <==> r == o);

function Set#UnionOne<T>(Set T, T): Set T;
axiom (forall<T> a: Set T, x: T, o: T :: { Set#UnionOne(a,x)[o] }
  Set#UnionOne(a,x)[o] <==> o == x || a[o]);
axiom (forall<T> a: Set T, x: T :: { Set#UnionOne(a, x) }
  Set#UnionOne(a, x)[x]);
axiom (forall<T> a: Set T, x: T, y: T :: { Set#UnionOne(a, x), a[y] }
  a[y] ==> Set#UnionOne(a, x)[y]);

function Set#Union<T>(Set T, Set T): Set T;
axiom (forall<T> a: Set T, b: Set T, o: T :: { Set#Union(a,b)[o] }
  Set#Union(a,b)[o] <==> a[o] || b[o]);
axiom (forall<T> a, b: Set T, y: T :: { Set#Union(a, b), a[y] }
  a[y] ==> Set#Union(a, b)[y]);
axiom (forall<T> a, b: Set T, y: T :: { Set#Union(a, b), b[y] }
  b[y] ==> Set#Union(a, b)[y]);
axiom (forall<T> a, b: Set T :: { Set#Union(a, b) }
  Set#Disjoint(a, b) ==>
    Set#Difference(Set#Union(a, b), a) == b &&
    Set#Difference(Set#Union(a, b), b) == a);

function Set#Intersection<T>(Set T, Set T): Set T;
axiom (forall<T> a: Set T, b: Set T, o: T :: { Set#Intersection(a,b)[o] }
  Set#Intersection(a,b)[o] <==> a[o] && b[o]);

axiom (forall<T> a, b: Set T :: { Set#Union(Set#Union(a, b), b) }
  Set#Union(Set#Union(a, b), b) == Set#Union(a, b));
axiom (forall<T> a, b: Set T :: { Set#Union(a, Set#Union(a, b)) }
  Set#Union(a, Set#Union(a, b)) == Set#Union(a, b));
axiom (forall<T> a, b: Set T :: { Set#Intersection(Set#Intersection(a, b), b) }
  Set#Intersection(Set#Intersection(a, b), b) == Set#Intersection(a, b));
axiom (forall<T> a, b: Set T :: { Set#Intersection(a, Set#Intersection(a, b)) }
  Set#Intersection(a, Set#Intersection(a, b)) == Set#Intersection(a, b));

function Set#Difference<T>(Set T, Set T): Set T;
axiom (forall<T> a: Set T, b: Set T, o: T :: { Set#Difference(a,b)[o] }
  Set#Difference(a,b)[o] <==> a[o] && !b[o]);
axiom (forall<T> a, b: Set T, y: T :: { Set#Difference(a, b), b[y] }
  b[y] ==> !Set#Difference(a, b)[y] );

function Set#Subset<T>(Set T, Set T): bool;
axiom(forall<T> a: Set T, b: Set T :: { Set#Subset(a,b) }
  Set#Subset(a,b) <==> (forall o: T :: {a[o]} {b[o]} a[o] ==> b[o]));

function Set#Equal<T>(Set T, Set T): bool;
axiom(forall<T> a: Set T, b: Set T :: { Set#Equal(a,b) }
  Set#Equal(a,b) <==> (forall o: T :: {a[o]} {b[o]} a[o] <==> b[o]));
axiom(forall<T> a: Set T, b: Set T :: { Set#Equal(a,b) }  // extensionality axiom for sets
  Set#Equal(a,b) ==> a == b);

function Set#Disjoint<T>(Set T, Set T): bool;
axiom (forall<T> a: Set T, b: Set T :: { Set#Disjoint(a,b) }
  Set#Disjoint(a,b) <==> (forall o: T :: {a[o]} {b[o]} !a[o] || !b[o]));

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

const unique allocated: Field bool; // Ghost field for allocation status of objects

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
axiom (forall h: HeapType :: h[Void, allocated]); // Void is always allocated.
axiom (forall h: HeapType, f: Field ref, o: ref :: h[o, allocated] ==> h[h[o, f], allocated]); // All reference fields are allocated.
axiom (forall r: ref :: (r == Void) <==> (type_of(r) == NONE)); // Void is only reference of type NONE.
axiom (forall a, b: ref :: (type_of(a) != type_of(b)) ==> (a != b)); // Objects that have different dynamic type cannot be aliased.

// ----------------------------------------------------------------------
// Ownership

var Writes: Set ref; // Set of all currently writable objects

const unique closed: Field bool; // Ghost field for open/closed status of an object.
const unique owner: Field ref; // Ghost field for owner of an object.
const unique owns: Field (Set ref); // Ghost field for owns set of an object.
const unique dependents: Field (Set ref); // Ghost field for dependents set of an object.
const unique depends: Field (Set ref); // Ghost field for depends set of an object.

// Is o free? (owner is open)
function is_free(h: HeapType, o: ref): bool {
	h[o, owner] == Void
}

// Is o wrapped in h? (closed and free)
function is_wrapped(h: HeapType, o: ref): bool {
	h[o, closed] && is_free(h, o)
}

// Is o open in h? (not closed and free)
function is_open(h: HeapType, o: ref): bool {
	!h[o, closed]
}

// Is o' in the ownership domain of o? Yes if they are equal, or both closed and o' is transitively owned by o
function in_domain(h: HeapType, o: ref, o': ref): bool
{
	o == o' ||
	(
		h[o, closed] &&
		h[o', closed] &&
		in_domain(h, o, h[o', owner])
	)
}

axiom (forall h: HeapType, o, o': ref :: h[o, closed] && h[o, owns][o'] ==> in_domain(h, o, o'));

// Objects outside of ownership domains of mods did not change
function writes_(h: HeapType, h': HeapType, mods: Set ref): bool { 
	(forall <T> o: ref, f: Field T :: (forall o': ref :: mods[o'] ==> !in_domain(h, o', o)) ==> h'[o, f] == h[o, f])
}

// Update Heap position Current.field with value.
procedure update_heap<T>(Current: ref, field: Field T, value: T);
	requires is_open(Heap, Current); // UP1
	requires (forall o: ref :: Heap[Current, dependents][o] ==> is_open(Heap, o)); // UP2
	requires Writes[Current]; // UP3
	modifies Heap;
	ensures Heap[Current, field] == value;
	ensures (forall<U> o: ref, f: Field U :: !(o == Current && f == field) ==> Heap[o, f] == old(Heap[o, f]));

// Unwrap o
procedure unwrap(o: ref);
//  free requires inv(Heap, o);
  requires is_wrapped(Heap, o); // UW1
  requires Writes[o]; // UW2
  modifies Heap, Writes;
  ensures is_open(Heap, o);
//  ensures user_inv(Heap, o);
  ensures (forall o': ref :: old(Heap[o, owns][o']) ==> is_wrapped(Heap, o'));
  ensures (forall <T> o': ref, f: Field T :: !(o' == o && f == closed) && !(old(Heap[o, owns][o']) && f == owner) ==> Heap[o', f] == old(Heap[o', f]));
  ensures Set#Equal(Writes, old(Set#Union(Writes, Heap[o, owns])));


// Wrap o
procedure wrap(o: ref);
  requires is_open(Heap, o); // W1
//  requires user_inv(Heap, o); // W2
  requires (forall o': ref :: Heap[o, owns][o'] ==> is_wrapped(Heap, o') && Writes[o']); // W3
  requires Writes[o]; // W4
  modifies Heap, Writes;
  ensures is_wrapped(Heap, o);
  ensures (forall o': ref :: old(Heap[o, owns][o']) ==> Heap[o', owner] == o);
  ensures (forall <T> o': ref, f: Field T :: !(o' == o && f == closed) && !(old(Heap[o, owns][o']) && f == owner) ==> Heap[o', f] == old(Heap[o', f]));
  ensures Set#Equal(Writes, old(Set#Difference(Writes, Heap[o, owns])));



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
	(o != Void) && (heap[o, allocated]) && (type_of(o) == t)
}

// Property that reference `o' is attached and conforms to type `t' on heap `heap'.
function attached_conform(heap: HeapType, o: ref, t: Type) returns (bool) {
	(o != Void) && (heap[o, allocated]) && (type_of(o) <: t)
}

// Property that reference `o' is either Void or attached and conforms to `t' on heap `heap'.
function detachable(heap: HeapType, o: ref, t: Type) returns (bool) {
	(o == Void) || (attached_conform(heap, o, t))
}

// Property that field `f' is of attached type `t'.
function attached_attribute(heap: HeapType, o: ref, f: Field ref, t: Type) returns (bool) {
	true
//	((o != Void) && (heap[o, allocated]) && (heap[o, $initialized])) ==> (attached(heap, heap[o, f], t))
}

// Property that field `f' is of detachable type `t'.
function detachable_attribute(heap: HeapType, o: ref, f: Field ref, t: Type) returns (bool) {
	true
//	((o != Void) && (heap[o, allocated]) && (heap[o, $initialized])) ==> (detachable(heap, heap[o, f], t))
}



procedure allocate(t: Type) returns (result: ref);
	modifies Heap, Writes;
	ensures !old(Heap[result, allocated]);
	ensures Heap[result, allocated];
	ensures result != Void;
	ensures type_of(result) == t;
	ensures is_open(Heap, result);
	ensures Heap[result, owner] == Void;
	ensures Set#Equal(Heap[result, dependents], Set#Empty());
	ensures Writes == old(Set#UnionOne(Writes, result));
	ensures (forall <T> o: ref, f: Field T :: o != result ==> Heap[o, f] == old(Heap[o, f]));







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
function is_natural(i: int) returns (bool) {
	(0 <= i)
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
