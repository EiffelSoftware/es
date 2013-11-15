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
axiom(forall<T> a: Set T, o: T :: { Set#Difference(a, Set#Singleton(o)) }
  Set#Equal(Set#UnionOne(Set#Difference(a, Set#Singleton(o)), o), a));

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
function IsGhostField<alpha>(field: Field alpha): bool; // Is this field a ghost field?

type HeapType = <alpha>[ref, Field alpha]alpha; // Type of a heap (with generic field subtype and generic content type)
const unique allocated: Field bool; // Ghost field for allocation status of objects

// Function which defines basic properties of a heap
function IsHeap(heap: HeapType): bool {
	true
}

// The global heap (which is always a heap)
var Heap: HeapType where IsHeap(Heap);

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
function is_frozen(t: Type) returns (bool);

// Typing axioms
axiom (forall t: Type :: t <: ANY); // All types inherit from ANY.
axiom (forall t: Type :: NONE <: t); // NONE inherits from all types.
axiom (forall h: HeapType :: h[Void, allocated]); // Void is always allocated.
axiom (forall h: HeapType, f: Field ref, o: ref :: h[o, allocated] ==> h[h[o, f], allocated]); // All reference fields are allocated.
axiom (forall r: ref :: (r == Void) <==> (type_of(r) == NONE)); // Void is only reference of type NONE.
axiom (forall a, b: ref :: (type_of(a) != type_of(b)) ==> (a != b)); // Objects that have different dynamic type cannot be aliased.
axiom (forall t: Type :: is_frozen(t) ==> (forall t2: Type :: t2 <: t ==> t2 == NONE)); // Only NONE inherits from frozen types.
axiom (forall t: Type, r: ref :: (r != Void && type_of(r) <: t && is_frozen(t)) ==> (type_of(r) == t)); // Non-void references of a frozen type are exact.

function ANY.self_inv(heap: HeapType, current: ref) returns (bool) {
  true
}

function NONE.self_inv(heap: HeapType, current: ref) returns (bool) {
  false
}

// ----------------------------------------------------------------------
// Ownership

var Writes: Set ref; // Set of all currently writable objects

const unique closed: Field bool; // Ghost field for open/closed status of an object.
const unique owner: Field ref; // Ghost field for owner of an object.
const unique owns: Field (Set ref); // Ghost field for owns set of an object.
const unique observers: Field (Set ref); // Ghost field for observers set of an object.
const unique subjects: Field (Set ref); // Ghost field for subjects set of an object.

// Is o free? (owner is open)
function {:inline} is_free(h: HeapType, o: ref): bool {
	h[o, owner] == Void
}

// Is o wrapped in h? (closed and free)
function {:inline} is_wrapped(h: HeapType, o: ref): bool {
	h[o, closed] && is_free(h, o)
}

// Is o open in h? (not closed and free)
function {:inline} is_open(h: HeapType, o: ref): bool {
	!h[o, closed]
}

// Is o closed in h?
function {:inline} is_closed(h: HeapType, o: ref): bool {
	h[o, closed]
}

// Only allocated references can be in ghost sets
axiom (forall h: HeapType, o: ref, r: ref, f: Field (Set ref) :: h[o, f][r] ==> h[r, allocated]);
//axiom (forall h: HeapType, o: ref, r: ref :: h[o, observers][r] ==> h[r, allocated]);
//axiom (forall h: HeapType, o: ref, r: ref :: h[o, owns][r] ==> h[r, allocated]);
//axiom (forall h: HeapType, o: ref, r: ref :: h[o, subjects][r] ==> h[r, allocated]);

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

axiom (forall h: HeapType, o, o': ref :: { in_domain(h, o, o') } h[o, closed] && h[o, owns][o'] ==> in_domain(h, o, o'));

// Objects outside of ownership domains of mods did not change, unless they were newly allocated
function writes(h: HeapType, h': HeapType, mods: Set ref): bool { 
	(forall <T> o: ref, f: Field T :: { h[o, f] } { h'[o, f] }
		((forall o': ref :: { mods[o'] } { in_domain(h, o', o) } mods[o'] ==> !in_domain(h, o', o)) &&
		 h[o, allocated])
			==>
		h'[o, f] == h[o, f])
	&&
	no_garbage(h, h')
}

// The allocation status of objects does not change
function no_garbage(old_heap: HeapType, new_heap: HeapType): bool {
	(forall o: ref :: { new_heap[o, allocated] } { old_heap[o, allocated] }
		old_heap[o, allocated] ==> new_heap[o, allocated])
}

// Objects that:
// 1. were in the writes set and have not been captured by the routine
// 2. have been released by the routine
// 3. newly allocated and not captured
// are still writable 
function writes_changed(h: HeapType, h': HeapType, wr: Set ref, wr': Set ref): bool
{
	(forall o: ref ::
		(wr[o] && is_free(h', o)) ||
		(!is_free(h, o) && is_free(h', o)) ||
		(!h[o, allocated] && h'[o, allocated] && is_free(h', o))
			==> 
		wr'[o])
}

// Is invariant of object o satisifed?
function user_inv(h: HeapType, o: ref): bool;

// Is object o closed or the invariant satisfied?
function inv(h: HeapType, o: ref): bool {
	h[o, closed] ==> user_inv(h, o)
}

// Invariant of None is false
// axiom (forall h: HeapType, o: ref :: type_of(o) == NONE ==> !user_inv(h, o));

// Global heap invariants
function {:inline true} global_heap(h: HeapType): bool
{
	is_open(h, Void) && // G1
	(forall o: ref :: h[o, allocated] && is_free(h, o) ==> (h[o, owner] == Void)) && // G2
	(forall o: ref :: h[o, allocated] && is_open(h, o) ==> is_free(h, o)) && // G3
	(forall o: ref, o': ref :: h[o, allocated] && h[o', allocated] && h[o, closed] && h[o, owns][o'] ==> (h[o', closed] && h[o', owner] == o)) && // G4
	(forall o: ref :: h[o, allocated] && h[o, closed] ==> inv(h, o)) // G5
}

// Global invariants
function {:inline true} global(h: HeapType, wr: Set ref): bool
{
  global_heap(h) &&
  (forall o: ref :: wr[o] ==> h[o, allocated] && is_free(h, o))
}

// Allocate fresh object
procedure allocate(t: Type) returns (result: ref);
	modifies Heap, Writes;
	ensures !old(Heap[result, allocated]); // AL1
	ensures Heap[result, allocated]; // AL2
	ensures result != Void;
	ensures type_of(result) == t;
	ensures is_open(Heap, result); // AL3
	ensures is_free(Heap, result); // AL4
	ensures Set#Equal(Heap[result, owns], Set#Empty());
	ensures Set#Equal(Heap[result, observers], Set#Empty());
	ensures Set#Equal(Heap[result, subjects], Set#Empty());
	ensures Writes == old(Set#UnionOne(Writes, result));
	ensures (forall <T> o: ref, f: Field T :: o != result ==> Heap[o, f] == old(Heap[o, f]));

// Update Heap position Current.field with value.
procedure update_heap<T>(Current: ref, field: Field T, value: T);
	requires field != closed && field != owner; // update tag:closed_or_owner_not_allowed UP4
	requires is_open(Heap, Current); // update tag:target_open UP1
	requires (forall o: ref :: Heap[Current, observers][o] ==> (is_open(Heap, o) || (user_inv(Heap, o) ==> user_inv(Heap[Current, field := value], o)))); // update tag:observers_open_or_preserved UP2
	requires Writes[Current]; // update tag:target_writable UP3
	modifies Heap;
//	ensures Heap[Current, field] == value;
	ensures Heap == old(Heap[Current, field := value]);
	ensures global_heap(Heap);
//	ensures (forall<U> o: ref, f: Field U :: !(o == Current && f == field) ==> Heap[o, f] == old(Heap[o, f]));

// Unwrap o
procedure unwrap(o: ref);
	requires is_wrapped(Heap, o); // pre tag:wrapped UW1
	requires Writes[o]; // pre tag:writable UW2
	modifies Heap, Writes;
	ensures is_open(Heap, o); // UWE1
	ensures (forall o': ref :: old(Heap[o, owns][o']) ==> is_wrapped(Heap, o')); // UWE2
	ensures Set#Equal(Writes, old(Set#Union(Writes, Heap[o, owns]))); // UWE3
	ensures (forall <T> o': ref, f: Field T :: !(o' == o && f == closed) && !(old(Heap[o, owns][o']) && f == owner) ==> Heap[o', f] == old(Heap[o', f]));
	ensures user_inv(Heap, o);

procedure unwrap_all (Current: ref, s: Set ref);
	requires (forall o: ref :: s[o] ==> is_wrapped(Heap, o)); // pre tag:wrapped UW1
	requires (forall o: ref :: s[o] ==> Writes[o]); // pre tag:writable UW2
	modifies Heap, Writes;
	ensures (forall o: ref :: s[o] ==> is_open(Heap, o)); // UWE1
	ensures (forall o: ref :: s[o] ==> (forall o': ref :: old(Heap[o, owns][o']) ==> is_wrapped(Heap, o'))); // UWE2
	ensures (forall o: ref :: s[o] ==> Set#Subset(old(Heap[o, owns]), Writes)) && Set#Subset(old(Writes), Writes); // ensures Set#Equal(Writes, old(Set#Union(Writes, Heap[o, owns]))); // UWE3
	ensures (forall <T> o: ref, f: Field T :: !(s[o] && f == closed) && !((exists o': ref :: s[o'] && old(Heap[o', owns][o])) && f == owner) ==> Heap[o, f] == old(Heap[o, f]));
	ensures (forall o: ref :: s[o] ==> user_inv(Heap, o));

// Wrap o
procedure wrap(o: ref);
	requires is_open(Heap, o); // pre tag:open W1
	requires user_inv(Heap, o); // pre tag:invariant_holds W2
	requires (forall o': ref :: Heap[o, owns][o'] ==> is_wrapped(Heap, o')); // pre tag:owned_objects_wrapped W3
//	requires (forall o': ref :: Heap[o, owns][o'] ==> Writes[o']); // pre tag:owned_objects_writable W3
	requires Writes[o]; // pre tag:writable W4
	modifies Heap, Writes;
	ensures Set#Equal(Writes, old(Set#Difference(Writes, Heap[o, owns]))); // WE1
	ensures (forall o': ref :: old(Heap[o, owns][o']) ==> Heap[o', owner] == o); // WE2
	ensures is_wrapped(Heap, o); // WE3
	ensures (forall <T> o': ref, f: Field T :: !(o' == o && f == closed) && !(old(Heap[o, owns][o']) && f == owner) ==> Heap[o', f] == old(Heap[o', f]));

procedure wrap_all(Current: ref, s: Set ref);
	requires (forall o: ref :: s[o] ==> is_open(Heap, o)); // pre tag:open W1
	requires (forall o: ref :: s[o] ==> user_inv(Heap, o)); // pre tag:invariant_holds W2
	requires (forall o: ref :: s[o] ==> (forall o': ref :: Heap[o, owns][o'] ==> is_wrapped(Heap, o'))); // pre tag:owned_objects_wrapped W3
	requires (forall o: ref :: s[o] ==> (forall o': ref :: Heap[o, owns][o'] ==> Writes[o'])); // pre tag:owned_objects_writable W3
	requires (forall o: ref :: s[o] ==> Writes[o]); // pre tag:writable W4
	modifies Heap, Writes;
	ensures (forall o: ref :: s[o] ==> (forall o': ref :: old(Heap[o, owns][o']) ==> !Writes[o'])); // WE1
	ensures (forall o: ref :: old(Writes[o]) && !(exists o': ref :: s[o'] && old(Heap[o', owns][o])) ==> Writes[o]); // WE1
	ensures (forall o: ref :: s[o] ==> (forall o': ref :: old(Heap[o, owns][o']) ==> Heap[o', owner] == o)); // WE2
	ensures (forall o: ref :: s[o] ==> is_wrapped(Heap, o)); // WE3
	ensures (forall <T> o: ref, f: Field T :: !(s[o] && f == closed) && !((exists o': ref :: s[o'] && old(Heap[o', owns][o])) && f == owner) ==> Heap[o, f] == old(Heap[o, f]));

// ----------------------------------------------------------------------
// Attached/Detachable functions

// Property that reference `o' is attached to an object of type `t' on heap `heap'.
function attached_exact(heap: HeapType, o: ref, t: Type) returns (bool) {
	(o != Void) && (heap[o, allocated]) && (type_of(o) == t)
}

// Property that reference `o' is attached and conforms to type `t' on heap `heap'.
function attached(heap: HeapType, o: ref, t: Type) returns (bool) {
	(o != Void) && (heap[o, allocated]) && (type_of(o) == t)

// ******************* reenable when ownership and inheritance are combined *******************
//	(o != Void) && (heap[o, allocated]) && (type_of(o) <: t)

}

// Property that reference `o' is either Void or attached and conforms to `t' on heap `heap'.
function detachable(heap: HeapType, o: ref, t: Type) returns (bool) {
	(o == Void) || (attached(heap, o, t))
}

// Property that field `f' is of attached type `t'.
function attached_attribute(heap: HeapType, o: ref, f: Field ref, t: Type) returns (bool) {
	(o != Void) && (heap[o, allocated]) ==> attached(heap, heap[o, f], t)
}

// Property that field `f' is of detachable type `t'.
function detachable_attribute(heap: HeapType, o: ref, f: Field ref, t: Type) returns (bool) {
	(o != Void) && (heap[o, allocated]) ==> detachable(heap, heap[o, f], t)
}

// ----------------------------------------------------------------------
// Basic types

// Integer boxing

const unique INTEGER: Type;

function boxed_int(i: int) returns (ref);
function unboxed_int(r: ref) returns (int);

axiom (forall i: int :: unboxed_int(boxed_int(i)) == i);
axiom (forall i1, i2: int :: (i1 == i2) ==> (boxed_int(i1) == boxed_int(i2)));
axiom (forall i: int :: boxed_int(i) != Void && type_of(boxed_int(i)) == INTEGER);
axiom (forall heap: HeapType, i: int :: heap[boxed_int(i), allocated]);


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
axiom (boxed_true != Void && type_of(boxed_true) == BOOLEAN);
axiom (boxed_false != Void && type_of(boxed_false) == BOOLEAN);
axiom (forall heap: HeapType :: heap[boxed_true, allocated]);
axiom (forall heap: HeapType :: heap[boxed_false, allocated]);

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

// Numeric conversions

function int_to_integer_8(i: int) returns (int);
axiom (forall i: int :: { int_to_integer_8(i) } is_integer_8(i) ==> int_to_integer_8(i) == i);
axiom (forall i: int :: { int_to_integer_8(i) } is_integer_8(int_to_integer_8(i)));

function int_to_integer_16(i: int) returns (int);
axiom (forall i: int :: { int_to_integer_16(i) } is_integer_16(i) ==> int_to_integer_16(i) == i);
axiom (forall i: int :: { int_to_integer_16(i) } is_integer_16(int_to_integer_16(i)));

function int_to_integer_32(i: int) returns (int);
axiom (forall i: int :: { int_to_integer_32(i) } is_integer_32(i) ==> int_to_integer_32(i) == i);
axiom (forall i: int :: { int_to_integer_32(i) } is_integer_32(int_to_integer_32(i)));

function int_to_integer_64(i: int) returns (int);
axiom (forall i: int :: { int_to_integer_64(i) } is_integer_64(i) ==> int_to_integer_64(i) == i);
axiom (forall i: int :: { int_to_integer_64(i) } is_integer_64(int_to_integer_64(i)));

function int_to_natural_8(i: int) returns (int);
axiom (forall i: int :: { int_to_natural_8(i) } is_natural_8(i) ==> int_to_natural_8(i) == i);
axiom (forall i: int :: { int_to_natural_8(i) } is_natural_8(int_to_natural_8(i)));

function int_to_natural_16(i: int) returns (int);
axiom (forall i: int :: { int_to_natural_16(i) } is_natural_16(i) ==> int_to_natural_16(i) == i);
axiom (forall i: int :: { int_to_natural_16(i) } is_natural_16(int_to_natural_16(i)));

function int_to_natural_32(i: int) returns (int);
axiom (forall i: int :: { int_to_natural_32(i) } is_natural_32(i) ==> int_to_natural_32(i) == i);
axiom (forall i: int :: { int_to_natural_32(i) } is_natural_32(int_to_natural_32(i)));

function int_to_natural_64(i: int) returns (int);
axiom (forall i: int :: { int_to_natural_64(i) } is_natural_64(i) ==> int_to_natural_64(i) == i);
axiom (forall i: int :: { int_to_natural_64(i) } is_natural_64(int_to_natural_64(i)));

function real_to_integer_32(r: real) returns (int);
axiom (forall r: real :: { real_to_integer_32(r) } is_integer_32(int(r)) ==> real_to_integer_32(r) == int(r));
axiom (forall r: real :: { real_to_integer_32(r) } (!is_integer_32(int(r)) && r < 0.0) ==> real_to_integer_32(r) == -2147483648);
axiom (forall r: real :: { real_to_integer_32(r) } (!is_integer_32(int(r)) && r > 0.0) ==> real_to_integer_32(r) ==  2147483647);

function real_to_integer_64(r: real) returns (int);
axiom (forall r: real :: { real_to_integer_64(r) } is_integer_64(int(r)) ==> real_to_integer_64(r) == int(r));
axiom (forall r: real :: { real_to_integer_64(r) } (!is_integer_64(int(r)) && r < 0.0) ==> real_to_integer_64(r) == -9223372036854775808);
axiom (forall r: real :: { real_to_integer_64(r) } (!is_integer_64(int(r)) && r > 0.0) ==> real_to_integer_64(r) ==  9223372036854775807);

// Arithmetic functions

function add(a, b: int): int { a + b }
function subtract(a, b: int): int { a - b }
function multiply(a, b: int): int { a * b }
function modulo(a, b: int): int { a mod b }
function divide(a, b: int): int { a div b }

// Expanded types

type unknown;

// Address operator

function address(a: ref) returns (int);
axiom (forall a, b: ref :: (a != b) <==> (address(a) != address(b))); // Different objects have different heap addresses.
axiom (forall a: ref :: is_integer_64(address(a))); // Addresses are 64 bit integers.

