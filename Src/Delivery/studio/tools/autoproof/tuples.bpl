// ----------------------------------------------------------------------
// Tuples

// Types for tuple objects
const unique TUPLE: Type;

// Field for count of tuple elements
const unique TUPLE.count: Field int;
axiom (forall h: HeapType, a:ref :: h[a, TUPLE.count] >= 0);

// Special attribute for tuple content
const unique $TUPLE.area: Field<beta> [int]beta;

// Function to check if an integer is in the range of valid array indeces
function $TUPLE.is_index(h: HeapType, a: ref, i: int) returns (bool) {
	(1 <= i && i <= h[a, TUPLE.count])
}

// Function to obtain the array item at the i-th position
function $TUPLE.item<beta>(h: HeapType, a: ref, i: int) returns (beta) {
	h[a, $TUPLE.area][i]
}
// Axiom to provide necessary triggers
axiom (forall h: HeapType, a: ref, i: int ::
			{ $TUPLE.item(h, a, i) }
			{ h[a, $TUPLE.area][i] }
		$TUPLE.item(h, a, i) == h[a, $TUPLE.area][i]
	);

// Creator for tuples
procedure $TUPLE.make(
			c: ref where attached(Heap, c, TUPLE),
			count: int where is_integer_32(count)
		);
	requires count >= 0;
	ensures Heap[c, TUPLE.count] == count;
	modifies Heap;
	ensures (forall<beta> o: ref, f: Field beta :: (o != c || f == allocated) ==> (Heap[o, f] == old(Heap)[o, f]));

// Procedure for putting elements in tuples
procedure $TUPLE.put<alpha>(
			c: ref where attached(Heap, c, TUPLE),
			value: alpha,
			index: int where is_integer_32(index)
		);
	requires 1 <= index && index <= Heap[c, TUPLE.count];
	ensures $TUPLE.item(Heap, c, index) == value;
	modifies Heap;
	ensures (forall<beta> o: ref, f: Field beta :: (o != c || f != $TUPLE.area) ==> (Heap[o, f] == old(Heap)[o, f]));
	ensures (forall<beta> i: int :: i != index ==> Heap[c, $TUPLE.area][i] == old(Heap)[c, $TUPLE.area][i]);

// Functions for creating tuples in contract expressions

function TUPLE.create0() returns (ref);
axiom (forall h: HeapType :: h[TUPLE.create0(), TUPLE.count] == 0);

function TUPLE.create1<alpha>(value1: alpha) returns (ref);
axiom (forall<alpha> h: HeapType, v1: alpha :: h[TUPLE.create1(v1), TUPLE.count] == 1);
axiom (forall<alpha> h: HeapType, v1: alpha :: $TUPLE.item(h, TUPLE.create1(v1), 1) == v1);

function TUPLE.create2<alpha, beta>(value1: alpha, value2: beta) returns (ref);
axiom (forall<alpha, beta> h: HeapType, v1: alpha, v2: beta :: h[TUPLE.create2(v1, v2), TUPLE.count] == 2);
axiom (forall<alpha, beta> h: HeapType, v1: alpha, v2: beta :: $TUPLE.item(h, TUPLE.create2(v1, v2), 1) == v1);
axiom (forall<alpha, beta> h: HeapType, v1: alpha, v2: beta :: $TUPLE.item(h, TUPLE.create2(v1, v2), 2) == v2);

function TUPLE.create3<alpha, beta, gamma>(value1: alpha, value2: beta, value3: gamma) returns (ref);
axiom (forall<alpha, beta, gamma> h: HeapType, v1: alpha, v2: beta, v3: gamma :: h[TUPLE.create3(v1, v2, v3), TUPLE.count] == 3);
axiom (forall<alpha, beta, gamma> h: HeapType, v1: alpha, v2: beta, v3: gamma :: $TUPLE.item(h, TUPLE.create3(v1, v2, v3), 1) == v1);
axiom (forall<alpha, beta, gamma> h: HeapType, v1: alpha, v2: beta, v3: gamma :: $TUPLE.item(h, TUPLE.create3(v1, v2, v3), 2) == v2);
axiom (forall<alpha, beta, gamma> h: HeapType, v1: alpha, v2: beta, v3: gamma :: $TUPLE.item(h, TUPLE.create3(v1, v2, v3), 3) == v3);
