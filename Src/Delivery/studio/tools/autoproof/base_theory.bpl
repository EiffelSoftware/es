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
function IsHeap(heap: HeapType): bool;

// The global heap (which is always a heap)
var Heap: HeapType where IsHeap(Heap);

// Function that defines properties of two (transitively) successive heaps
function HeapSucc(HeapType, HeapType): bool;
// axiom (forall<alpha> h: HeapType, r: ref, f: Field alpha, x: alpha :: { update(h, r, f, x) }
  // IsHeap(update(h, r, f, x)) ==>
  // HeapSucc(h, update(h, r, f, x)));
axiom (forall<alpha> h: HeapType, r: ref, f: Field alpha, x: alpha :: { h[r, f := x] }
  IsHeap(h[r, f := x]) ==>
  HeapSucc(h, h[r, f := x]));  
axiom (forall a,b,c: HeapType :: { HeapSucc(a,b), HeapSucc(b,c) }
  HeapSucc(a,b) && HeapSucc(b,c) ==> HeapSucc(a,c));
// axiom (forall h: HeapType, k: HeapType :: { HeapSucc(h,k) }
  // HeapSucc(h,k) ==> (forall o: ref :: { read(k, o, allocated) } read(h, o, allocated) ==> read(k, o, allocated)));
axiom (forall h: HeapType, k: HeapType :: { HeapSucc(h,k) }
  HeapSucc(h,k) ==> (forall o: ref :: { k[o, allocated] } h[o, allocated] ==> k[o, allocated]));  


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
axiom (forall t: Type :: is_frozen(t) ==> (forall t2: Type :: t2 <: t ==> t2 == t || t2 == NONE)); // Only NONE inherits from frozen types.
axiom (forall t: Type, r: ref :: (r != Void && type_of(r) <: t && is_frozen(t)) ==> (type_of(r) == t)); // Non-void references of a frozen type are exact.

function ANY.self_inv(heap: HeapType, current: ref) returns (bool) {
  true
}

function NONE.self_inv(heap: HeapType, current: ref) returns (bool) {
  false
}

// ----------------------------------------------------------------------
// Ghosts

const unique closed: Field bool; // Ghost field for open/closed status of an object.
const unique owner: Field ref; // Ghost field for owner of an object.
const unique owns: Field (Set ref); // Ghost field for owns set of an object.
const unique observers: Field (Set ref); // Ghost field for observers set of an object.
const unique subjects: Field (Set ref); // Ghost field for subjects set of an object.

// Analogue of `detachable_attribute' ans `set_detachable_attribute' for built-in attributes:
axiom (forall heap: HeapType, o: ref :: { heap[o, owner] } o != Void && heap[o, allocated] ==> heap[heap[o, owner], allocated]);
axiom (forall heap: HeapType, o, o': ref :: { heap[o, owns][o'] } o != Void && heap[o, allocated] && heap[o, owns][o'] ==> heap[o', allocated]);
axiom (forall heap: HeapType, o, o': ref :: { heap[o, subjects][o'] } o != Void && heap[o, allocated] && heap[o, subjects][o'] ==> heap[o', allocated]);
axiom (forall heap: HeapType, o, o': ref :: { heap[o, observers][o'] } o != Void && heap[o, allocated] && heap[o, observers][o'] ==> heap[o', allocated]);

// Is o open in h? (not closed and free)
function {:inline} is_open(h: HeapType, o: ref): bool {
	!h[o, closed]
}

// Is o closed in h?
function {:inline} is_closed(h: HeapType, o: ref): bool {
	h[o, closed]
}

// Is o free? (owner is open)
function {:inline} is_free(h: HeapType, o: ref): bool {
  h[o, owner] == Void
}

// Is o wrapped in h? (closed and free)
function is_wrapped(h: HeapType, o: ref): bool {
	h[o, closed] && is_free(h, o)
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

axiom (forall h: HeapType, o, o': ref :: { in_domain(h, o, o') } h[o, closed] && h[o, owns][o'] ==> in_domain(h, o, o'));
axiom (forall h: HeapType, o, o': ref :: { in_domain(h, o, o') } o != o' && Set#Equal(Set#Empty(), h[o, owns]) ==> !in_domain(h, o, o'));

// ----------------------------------------------------------------------
// Frames

// Set of object-field pairs
type Frame = <alpha>[ref, Field alpha]bool;

function Frame#Subset(Frame, Frame): bool;
axiom(forall a: Frame, b: Frame :: { Frame#Subset(a,b) }
  Frame#Subset(a,b) <==> (forall <alpha> o: ref, f: Field alpha :: {a[o, f]} {b[o, f]} a[o, f] ==> b[o, f]));

// Set of all writable objects
const writable: Frame;

function fully_writable(wr: Frame, o: ref): bool
{ (forall <alpha> f: Field alpha :: wr[o, f]) }

// Writable set 'wr' is closed under ownership domains 
function {:inline true} writable_domains(wr: Frame, h: HeapType): bool
{ 
  (forall <alpha> o, o': ref, f: Field alpha :: {wr[o, closed], wr[o', f]}{fully_writable(wr, o), wr[o', f]} 
    wr[o, closed] && in_domain(h, o, o') && o != o' ==> wr[o', f]) 
}

// Objects outside of ownership domains of mods did not change, unless they were newly allocated
function writes(h: HeapType, h': HeapType, mods: Frame): bool { 
	(forall <T> o: ref, f: Field T :: { h[o, f] } { h'[o, f] }
    h[o, allocated] ==>      
      h'[o, f] == h[o, f] ||
      mods[o, f] ||
      (exists o': ref :: {mods[o', closed]}{in_domain(h, o', o)} o' != o && mods[o', closed] && in_domain(h, o', o))
  )
}

// ----------------------------------------------------------------------
// Invariants

// Is invariant of object o satisifed?
function user_inv(h: HeapType, o: ref): bool;

// Reads axiom
axiom (forall h, h': HeapType, x: ref :: {user_inv(h, x), user_inv(h', x), HeapSucc(h, h')} 
  HeapSucc(h, h') && h[x, allocated] && user_inv(h, x) && 
  (forall <T> o: ref, f: Field T :: h[o, allocated] ==> // every object's field
      h'[o, f] == h[o, f] ||                            // is unchanged
      f == closed || f == owner ||                      // or is outside of the read set of the invariant
      (!in_domain(h, x, o) && !h[x, subjects][o]) ||    
      (!in_domain(h, x, o) && f == subjects) ||         // or is the subjects field of one of the subjects
      (!in_domain(h, x, o) && f == observers && Set#Subset(h[o, observers], h'[o, observers]))  // or is the observers of one of the subjects and it grows
   )
  ==> user_inv(h', x));

// Is object o closed or the invariant satisfied?
function {:inline true} inv(h: HeapType, o: ref): bool {
	h[o, closed] ==> user_inv(h, o)
}

// Invariant of None is false
// axiom (forall h: HeapType, o: ref :: type_of(o) == NONE ==> !user_inv(h, o));

// Global heap invariants
function {:inline true} global(h: HeapType): bool
{
  is_open(h, Void) &&
  (forall o: ref :: h[o, allocated] && is_open(h, o) ==> is_free(h, o)) &&
  (forall o: ref, o': ref :: {h[o, owns][o']} h[o, allocated] && h[o', allocated] && h[o, closed] && h[o, owns][o'] ==> (h[o', closed] && h[o', owner] == o)) && // G2
  (forall o: ref :: {user_inv(h, o), h[o, closed]} h[o, allocated] ==> inv(h, o)) // G1
}

// Global invariant with a more permissive trigger: much slower, so only used in public routines  
function {:inline true} global_public(h: HeapType): bool
{
  (forall o: ref :: {is_wrapped(h, o)} h[o, allocated] ==> inv(h, o)) // G1
}

// All subjects know current for an observer
function {: inline } admissibility2 (heap: HeapType, current: ref): bool
{ 
  (forall s: ref :: heap[current, subjects][s] ==> heap[s, observers][current]) 
}

// Invariant cannot be invalidated by changing subjects of my subjects (except of myself)
function {: inline } admissibility4 (heap: HeapType, current: ref): bool
{
  (forall heap': HeapType, s: ref :: 
    heap[current, subjects][s] && s != current && (forall <alpha> o: ref, f: Field alpha :: (o == s && f == subjects) || heap'[o, f] == heap[o, f]) ==>
    user_inv(heap', current)
  )
}

// Invariant cannot be invalidated by adding observers to my subjects (except to myself)
function {: inline } admissibility5 (heap: HeapType, current: ref): bool
{
  (forall heap': HeapType, s: ref :: 
    heap[current, subjects][s] && s != current && Set#Subset(heap[s, observers], heap'[s, observers]) && (forall <alpha> o: ref, f: Field alpha :: (o == s && f == observers) || heap'[o, f] == heap[o, f]) ==>
    user_inv(heap', current)
  )
}

// ----------------------------------------------------------------------
// Built-in operations

// Allocate fresh object
procedure allocate(t: Type) returns (result: ref);
  modifies Heap;
  ensures global(Heap);
  ensures !old(Heap[result, allocated]); // AL1
  ensures Heap[result, allocated]; // AL2
  ensures result != Void;
  ensures type_of(result) == t;
  ensures is_open(Heap, result); // AL3
  ensures is_free(Heap, result); // AL4
  ensures Set#Equal(Heap[result, owns], Set#Empty());
  ensures Set#Equal(Heap[result, observers], Set#Empty());
  ensures Set#Equal(Heap[result, subjects], Set#Empty());
  ensures fully_writable(writable, result);
  ensures (forall <T> o: ref, f: Field T :: o != result ==> Heap[o, f] == old(Heap[o, f]));
  free ensures HeapSucc(old(Heap), Heap);

// Update Heap position Current.field with value.
procedure update_heap<T>(Current: ref, field: Field T, value: T);
  requires (Current != Void) && (Heap[Current, allocated]); // type:assign tag:attached_and_allocated
  requires field != closed && field != owner; // type:assign tag:closed_or_owner_not_allowed UP4
  requires is_open(Heap, Current); // type:assign tag:target_open UP1
  requires (forall o: ref :: Heap[Current, observers][o] ==> (is_open(Heap, o) || (user_inv(Heap, o) && HeapSucc(Heap, Heap[Current, field := value]) ==> user_inv(Heap[Current, field := value], o)))); // type:assign tag:observers_open_or_inv_preserved UP2
  requires writable[Current, field]; // type:assign tag:attribute_writable UP3
  modifies Heap;
  ensures global(Heap);
  ensures Heap == old(Heap[Current, field := value]);
  free ensures HeapSucc(old(Heap), Heap);
  
// This is an optimization: we do not have to check the observers (this is faster than using the frame axiom of user_inv directly) 
procedure update_subjects(Current: ref, value: Set ref);
  requires (Current != Void) && (Heap[Current, allocated]); // type:pre tag:attached_and_allocated
  requires is_open(Heap, Current); // type:pre tag:target_open UP1
  requires writable[Current, subjects]; // type:pre tag:attribute_writable UP3
  modifies Heap;
  ensures global(Heap);
  ensures Heap == old(Heap[Current, subjects := value]);
  free ensures HeapSucc(old(Heap), Heap);

// This is an optimization: we can just check that the observer set is growing (this is faster than using the frame axiom of user_inv directly)
procedure update_observers(Current: ref, value: Set ref);
  requires (Current != Void) && (Heap[Current, allocated]); // type:pre tag:attached_and_allocated
  requires is_open(Heap, Current); // type:pre tag:target_open UP1
  requires writable[Current, observers]; // type:pre tag:attribute_writable UP3
  requires Set#Subset(Heap[Current, observers], value) || (forall o: ref :: Heap[Current, observers][o] ==> (is_open(Heap, o) || (user_inv(Heap, o) ==> user_inv(Heap[Current, observers := value], o)))); // type:pre tag:set_grows_or_observers_open_or_inv_preserved UP2
  modifies Heap;
  ensures global(Heap);
  ensures Heap == old(Heap[Current, observers := value]);
  free ensures HeapSucc(old(Heap), Heap);  

// Unwrap o
procedure unwrap(o: ref);
  requires (o != Void) && (Heap[o, allocated]); // type:pre tag:attached
  requires is_wrapped(Heap, o); // type:pre tag:wrapped UW1
  requires writable[o, closed]; // type:pre tag:writable UW2
  modifies Heap;
  ensures global(Heap);  
  ensures is_open(Heap, o); // UWE1
  ensures (forall o': ref :: old(Heap[o, owns][o']) ==> is_wrapped(Heap, o') && user_inv(Heap, o')); // UWE2
  ensures (forall <T> o': ref, f: Field T :: !(o' == o && f == closed) && !(old(Heap[o, owns][o']) && f == owner) ==> Heap[o', f] == old(Heap[o', f]));
  ensures user_inv(Heap, o);
  free ensures HeapSucc(old(Heap), Heap);

procedure unwrap_all (Current: ref, s: Set ref);
  requires (forall o: ref :: s[o] ==> (o != Void) && (Heap[o, allocated])); // type:pre tag:attached
  requires (forall o: ref :: s[o] ==> is_wrapped(Heap, o)); // type:pre tag:wrapped UW1
  requires (forall o: ref :: s[o] ==> writable[o, closed]); // type:pre tag:writable UW2
  modifies Heap;
  ensures global(Heap);
  ensures (forall o: ref :: s[o] ==> is_open(Heap, o)); // UWE1
  ensures (forall o: ref :: s[o] ==> (forall o': ref :: old(Heap[o, owns][o']) ==> is_wrapped(Heap, o') && user_inv(Heap, o'))); // UWE2
  ensures (forall <T> o: ref, f: Field T :: !(s[o] && f == closed) && !((exists o': ref :: s[o'] && old(Heap[o', owns][o])) && f == owner) ==> Heap[o, f] == old(Heap[o, f]));
  ensures (forall o: ref :: s[o] ==> user_inv(Heap, o));
  free ensures HeapSucc(old(Heap), Heap);

// Wrap o
procedure wrap(o: ref);
  requires (o != Void) && (Heap[o, allocated]); // type:pre tag:attached
  requires is_open(Heap, o); // type:pre tag:open W1
  requires user_inv(Heap, o); // type:pre tag:invariant_holds W2
  requires (forall o': ref :: Heap[o, owns][o'] ==> is_wrapped(Heap, o')); // type:pre tag:owned_objects_wrapped W3
  requires writable[o, closed]; // type:pre tag:writable W4
  requires (forall o': ref :: Heap[o, owns][o'] ==> writable[o', owner]); // type:pre tag:owned_objects_writable W3
  modifies Heap;
  ensures global(Heap);  
  ensures (forall o': ref :: old(Heap[o, owns][o']) ==> Heap[o', owner] == o); // WE2
  ensures is_wrapped(Heap, o); // WE3
  ensures (forall <T> o': ref, f: Field T :: !(o' == o && f == closed) && !(old(Heap[o, owns][o']) && f == owner) ==> Heap[o', f] == old(Heap[o', f]));
  free ensures HeapSucc(old(Heap), Heap);

procedure wrap_all(Current: ref, s: Set ref);
  requires (forall o: ref :: s[o] ==> (o != Void) && (Heap[o, allocated])); // type:pre tag:attached
  requires (forall o: ref :: s[o] ==> is_open(Heap, o)); // type:pre tag:open W1
  requires (forall o: ref :: s[o] ==> user_inv(Heap, o)); // type:pre tag:invariant_holds W2
  requires (forall o: ref :: s[o] ==> (forall o': ref :: Heap[o, owns][o'] ==> is_wrapped(Heap, o'))); // type:pre tag:owned_objects_wrapped W3
  requires (forall o: ref :: s[o] ==> (forall o': ref :: Heap[o, owns][o'] ==> writable[o', owner])); // type:pre tag:owned_objects_writable W3
  requires (forall o: ref :: s[o] ==> writable[o, closed]); // type:pre tag:writable W4  
  modifies Heap;
  ensures global(Heap);  
  ensures (forall o: ref :: s[o] ==> (forall o': ref :: old(Heap[o, owns][o']) ==> Heap[o', owner] == o)); // WE2
  ensures (forall o: ref :: s[o] ==> is_wrapped(Heap, o)); // WE3
  ensures (forall <T> o: ref, f: Field T :: !(s[o] && f == closed) && !((exists o': ref :: s[o'] && old(Heap[o', owns][o])) && f == owner) ==> Heap[o, f] == old(Heap[o, f]));
  free ensures HeapSucc(old(Heap), Heap);

// ----------------------------------------------------------------------
// Attached/Detachable functions

// Property that reference `o' is attached to an object of type `t' on heap `heap'.
function attached_exact(heap: HeapType, o: ref, t: Type) returns (bool) {
	(o != Void) && (heap[o, allocated]) && (type_of(o) == t)
}

// Property that reference `o' is attached and conforms to type `t' on heap `heap'.
function attached(heap: HeapType, o: ref, t: Type) returns (bool) {
	(o != Void) && (heap[o, allocated]) && (type_of(o) <: t)
}

// Property that reference `o' is either Void or attached and conforms to `t' on heap `heap'.
function detachable(heap: HeapType, o: ref, t: Type) returns (bool) {
	(o == Void) || (attached(heap, o, t))
}

// Property that field `f' of an object of type `ot' is of attached type `t'.
function attached_attribute(heap: HeapType, o: ref, ot: Type, f: Field ref, t: Type) returns (bool) {
	attached(heap, o, ot) ==> attached(heap, heap[o, f], t)
}

// Property that field `f' of an object of type `ot' is of detachable type `t'.
function detachable_attribute(heap: HeapType, o: ref, ot: Type, f: Field ref, t: Type) returns (bool) {
	attached(heap, o, ot) ==> detachable(heap, heap[o, f], t)
}

// Property that `s' is a set of objects of attached type `t'.
function {: inline } set_attached(heap: HeapType, s: Set ref, t: Type) returns (bool) {
	(forall o: ref :: s[o] ==> attached(heap, o, t))
}

// Property that `s' is a set of objects of attached type `t'.
function {: inline } set_detachable(heap: HeapType, s: Set ref, t: Type) returns (bool) {
	(forall o: ref :: s[o] ==> detachable(heap, o, t))
}

// Property that field `f' is a set of objects of attached type `t'.
function set_attached_attribute(heap: HeapType, o: ref, ot: Type, f: Field (Set ref), t: Type) returns (bool) {
	attached(heap, o, ot) ==> set_attached(heap, heap[o, f], t)
}

// Property that field `f' is a set of objects of detachable type `t'.
function set_detachable_attribute(heap: HeapType, o: ref, ot: Type, f: Field (Set ref), t: Type) returns (bool) {
	attached(heap, o, ot) ==> set_detachable(heap, heap[o, f], t)
}

// Property that `s' is a sequence of objects of attached type `t'.
function {: inline } sequence_attached(heap: HeapType, s: Seq ref, t: Type) returns (bool) {
	(forall o: ref :: Seq#Range(s)[o] ==> attached(heap, o, t))
}

// Property that `s' is a sequence of objects of attached type `t'.
function {: inline } sequence_detachable(heap: HeapType, s: Seq ref, t: Type) returns (bool) {
	(forall o: ref :: Seq#Range(s)[o] ==> detachable(heap, o, t))
}

// Property that field `f' is a sequence of objects of detachable type `t'.
function sequence_attached_attribute(heap: HeapType, o: ref, ot: Type, f: Field (Seq ref), t: Type) returns (bool) {
	attached(heap, o, ot) ==> sequence_attached(heap, heap[o, f], t)
}

// Property that field `f' is a sequence of objects of detachable type `t'.
function sequence_detachable_attribute(heap: HeapType, o: ref, ot: Type, f: Field (Seq ref), t: Type) returns (bool) {
	attached(heap, o, ot) ==> sequence_detachable(heap, heap[o, f], t)
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

// Unsupported

function unsupported<T>() returns (T);

