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
	(a != Void) ==> (
		(h[a, ARRAY.lower] == 1) && 
		(h[a, ARRAY.upper] >= 0) && 
		(h[a, ARRAY.count] >= 0) && 
		(h[a, ARRAY.count] == h[a, ARRAY.upper] - h[a, ARRAY.lower] + 1)
	)
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
	requires l <= u + 1; // pre line:1
	ensures Heap[c, ARRAY.lower] == l;
	ensures Heap[c, ARRAY.upper] == u;
	ensures ARRAY.$inv(Heap, c);
	ensures (forall i: int :: ARRAY.$is_index(Heap, c, i) ==> ARRAY.$item(Heap, c, i) == 0);
	modifies Heap;
	ensures (forall<beta> o: ref, f: Field beta :: (o != c || (f != ARRAY.lower && f != ARRAY.upper && f != ARRAY.count && f != $area)) ==> (Heap[o, f] == old(Heap)[o, f]));

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

procedure ARRAY#int#.put(
			c: ref where attached(Heap, c, ARRAY#int#),
			item: int where is_integer_32(item),
			pos: int where is_integer_32(pos)
		);
	requires ARRAY.$is_index(Heap, c, pos); // pre line:1
	ensures ARRAY.$item(Heap, c, pos) == item;
	ensures ARRAY.$inv(Heap, c);
	modifies Heap;
	ensures (forall<beta> o: ref, f: Field beta :: (o != c || f != $area) ==> (Heap[o, f] == old(Heap)[o, f]));
	ensures (forall i: int :: (ARRAY.$is_index(Heap, c, i) && i != pos) ==> ARRAY.$item(Heap, c, i) == old(ARRAY.$item(Heap, c, i)));

procedure ARRAY#int#.item(
			c: ref where attached(Heap, c, ARRAY#int#),
			pos: int where is_integer_32(pos)
		) returns (result: int);
	requires ARRAY.$is_index(Heap, c, pos); // pre line:1
	ensures result == ARRAY.$item(Heap, c, pos);

procedure ARRAY#int#.count(
			c: ref where attached(Heap, c, ARRAY#int#)
		) returns (result: int);
	ensures result == Heap[c, ARRAY.count];

function fun.ARRAY#int#.count(heap: HeapType, c: ref) returns (int) {
	heap[c, ARRAY.count]
}

procedure ARRAY#int#.has(
			c: ref where attached(Heap, c, ARRAY#int#),
			val: int where is_integer_32(val)
		) returns (result: bool);
	ensures result == (exists i: int :: (ARRAY.$is_index(Heap, c, i) && (ARRAY.$item(Heap, c, i) == val)));

axiom (forall heap: HeapType, c: ref :: (fun.ARRAY#int#.count(heap, c) == 0) ==> (!(exists i: int :: ARRAY.$is_index(heap, c, i))));

function fun.ARRAY#int#.has(heap: HeapType, c: ref, val: int) returns (bool) {
	(exists i: int :: (ARRAY.$is_index(heap, c, i) && (ARRAY.$item(heap, c, i) == val)))
}

function fun.ARRAY#int#.has_not(heap: HeapType, c: ref, val: int) returns (bool) {
	(forall i: int :: (ARRAY.$is_index(heap, c, i) ==> !(ARRAY.$item(heap, c, i) == val)))
}


procedure ARRAY#int#.subarray(
			c: ref where attached(Heap, c, ARRAY^INTEGER_32^),
			l: int where is_integer_32(l),
			u: int where is_integer_32(u)
		) returns (result: ref);
	requires 1 <= l && l <= fun.ARRAY#int#.count(Heap, c) + 1;
	requires 0 <= u && u <= fun.ARRAY#int#.count(Heap, c);
//	requires (l <= u) || (l == u + 1);
	ensures (forall o: ref :: old(Heap)[o, $allocated] ==> o != result);
	ensures attached(Heap, result, ARRAY^INTEGER_32^);
	ensures ARRAY.$inv(Heap, result);
	ensures Heap[result, ARRAY.lower] == 1;
	ensures Heap[result, ARRAY.count] == (u - l + 1);
	ensures 0 <= fun.ARRAY#int#.count(Heap, result) && fun.ARRAY#int#.count(Heap, result) <= fun.ARRAY#int#.count(Heap, c);
	ensures (forall i: int :: ARRAY.$is_index(Heap, result, i) ==> ARRAY.$item(Heap, result, i) == ARRAY.$item(Heap, c, i + l - 1));
	ensures (forall i: int :: ARRAY.$is_index(Heap, result, i) ==> ARRAY.$item(Heap, result, i) == ARRAY.$item(Heap, c, i + l - 1));
	modifies Heap;
	ensures (forall<beta> o: ref, f: Field beta :: (o != result) ==> (Heap[o, f] == old(Heap)[o, f]));


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
