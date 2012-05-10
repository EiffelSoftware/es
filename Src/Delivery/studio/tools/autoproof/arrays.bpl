// ----------------------------------------------------------------------
// Arrays

// Types for array objects
const unique ARRAY#int#: Type;
const unique ARRAY#bool#: Type;
const unique ARRAY#ref#: Type;

// Fields for default attributes
const unique ARRAY.lower: Field int;
const unique ARRAY.upper: Field int;
const unique ARRAY.count: Field int;

// Special attribute for array content
const unique $area: Field<beta> [int]beta;

// Function to check if an integer is in the range of valid array indeces
function ARRAY.$is_index(h: HeapType, a: ref, i: int) returns (bool) {
	(h[a, ARRAY.lower] <= i && i <= h[a, ARRAY.upper])
}

// Function to obtain the array item at the i-th position
function ARRAY.$item<beta>(h: HeapType, a: ref, i: int) returns (beta) {
	h[a, $area][i]
}
// Axiom to provide necessary triggers
axiom (forall h: HeapType, a: ref, i: int ::
			{ ARRAY.$item(h, a, i) }
			{ h[a, $area][i] }
		ARRAY.$item(h, a, i) == h[a, $area][i]
	);

// Invariant for array objects
function ARRAY.$inv(h: HeapType, a: ref) returns (bool) {
	(h[a, ARRAY.lower] == 1) && 
	(h[a, ARRAY.upper] >= 0) && 
	(h[a, ARRAY.count] >= 0) && 
	(h[a, ARRAY.count] == h[a, ARRAY.upper] - h[a, ARRAY.lower] + 1)
}

function ARRAY#ref#.$inv(h: HeapType, a: ref, ct: Type) returns (bool) {
	ARRAY.$inv(h, a) &&
	(forall i: int :: ARRAY.$is_index(h, a, i) ==> (detachable(h, ARRAY.$item(h, a, i), ct)))
}

// Invariant for array objects that store integer values
function ARRAY#int#.$inv(h: HeapType, a: ref) returns (bool) {
	ARRAY.$inv(h, a) &&
	(forall i: int :: ARRAY.$is_index(h, a, i) ==> is_integer_32(ARRAY.$item(h, a, i)))
}

procedure ARRAY#int#.make(
			c: ref where attached(Heap, c, ARRAY#int#),
			l: int where is_integer_32(l),
			u: int where is_integer_32(u)
		);
	requires l <= u + 1;
	ensures Heap[c, ARRAY.lower] == l;
	ensures Heap[c, ARRAY.upper] == u;
	ensures ARRAY.$inv(Heap, c);
	ensures (forall i: int :: ARRAY.$is_index(Heap, c, i) ==> ARRAY.$item(Heap, c, i) == 0);
	modifies Heap;
	ensures (forall<beta> o: ref, f: Field beta :: (o != c) ==> (Heap[o, f] == old(Heap)[o, f]));

procedure ARRAY#int#.make_filled(
			c: ref where attached(Heap, c, ARRAY#int#),
			l: int where is_integer_32(l),
			u: int where is_integer_32(u),
			v: int where is_integer_32(v)
		);
	requires l <= u + 1;
	ensures Heap[c, ARRAY.lower] == l;
	ensures Heap[c, ARRAY.upper] == u;
	ensures ARRAY.$inv(Heap, c);
	ensures (forall i: int :: ARRAY.$is_index(Heap, c, i) ==> ARRAY.$item(Heap, c, i) == v);
	modifies Heap;
	ensures (forall<beta> o: ref, f: Field beta :: (o != c) ==> (Heap[o, f] == old(Heap)[o, f]));

procedure ARRAY#ref#.make(
			c: ref where attached(Heap, c, ARRAY#ref#),
			l: int where is_integer_32(l),
			u: int where is_integer_32(u)
		);
	requires l < u;
	ensures Heap[c, ARRAY.lower] == l;
	ensures Heap[c, ARRAY.upper] == u;
	ensures ARRAY.$inv(Heap, c);
	ensures (forall i: int :: ARRAY.$is_index(Heap, c, i) ==> ARRAY.$item(Heap, c, i) == Void);
	modifies Heap;
	ensures (forall<beta> o: ref, f: Field beta :: (o != c) ==> (Heap[o, f] == old(Heap)[o, f]));
