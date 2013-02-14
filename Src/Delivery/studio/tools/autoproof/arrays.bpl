// ----------------------------------------------------------------------
// Arrays

// Types for array objects
const unique ARRAY#int#: Type;
const unique ARRAY#bool#: Type;
const unique ARRAY#ref#: Type;

// Fields for default attributes
const unique ARRAY.count: Field int;

// Special attribute for array content
const unique area: Field<beta> [int]beta;

// Basic functions and procedures
function fun.ARRAY.count(h: HeapType, a: ref) returns (int) {
	h[a, ARRAY.count]
}
function fun.ARRAY.is_index(h: HeapType, a: ref, i: int) returns (bool) {
	(1 <= i && i <= h[a, ARRAY.count])
}
function fun.ARRAY.item<alpha>(h: HeapType, a: ref, i: int) returns (alpha) {
	h[a, area][i]
}
procedure ARRAY.item<alpha>(a: ref, i: int) returns (result: alpha);
	requires fun.ARRAY.is_index(Heap, a, i); // pre tag:index_in_bounds
	ensures result == fun.ARRAY.item(Heap, a, i);

procedure ARRAY.put<alpha>(a: ref, item: alpha, pos: int);
	requires fun.ARRAY.is_index(Heap, a, pos); // pre tag:index_in_bounds
	ensures fun.ARRAY.item(Heap, a, pos) == item;
	ensures Heap[a, area][pos] == item;
	modifies Heap;
	ensures (forall<beta> o: ref, f: Field beta :: (o != a || f != area) ==> (Heap[o, f] == old(Heap)[o, f]));
	ensures (forall i: int :: (fun.ARRAY.is_index(Heap, a, i) && i != pos) ==> fun.ARRAY.item(Heap, a, i) == old(fun.ARRAY.item(Heap, a, i)));

procedure ARRAY.make(
			c: ref where (c != Void && Heap[c, allocated]),
			l: int where is_integer_32(l),
			u: int where is_integer_32(u)
		);
	requires l == 1; // pre tag:lower_equals_1
	requires u >= 0; // pre
	ensures Heap[c, ARRAY.count] == u;
	ensures ARRAY.inv(Heap, c);
	modifies Heap;
	ensures (forall<beta> o: ref, f: Field beta :: ((o != c) || (f == allocated)) ==> (Heap[o, f] == old(Heap)[o, f]));

procedure ARRAY.make_filled<alpha>(
			c: ref where (c != Void && Heap[c, allocated]),
			d: alpha,
			l: int where is_integer_32(l),
			u: int where is_integer_32(u)
		);
	requires l == 1; // pre tag:lower_equals_1
	requires u >= 0; // pre
	ensures Heap[c, ARRAY.count] == u;
	ensures ARRAY.inv(Heap, c);
	modifies Heap;
	ensures (forall<beta> o: ref, f: Field beta :: ((o != c) || (f == allocated)) ==> (Heap[o, f] == old(Heap)[o, f]));

function fun.ARRAY.has<alpha>(h: HeapType, c: ref, val: alpha) returns (bool) {
	(exists i: int :: (fun.ARRAY.is_index(h, c, i) && (fun.ARRAY.item(h, c, i) == val)))
}

procedure ARRAY.subarray(a: ref, l: int, u: int) returns (result: ref);
	requires fun.ARRAY.is_index(Heap, a, l);
	requires (l-1) <= u && u <= fun.ARRAY.count(Heap, a);
	// requires (forall i_46: int :: (((1) <= (i_46)) && ((i_46) <= ((fun.ARRAY.count(Heap, a)) - (1)))) ==> ((fun.ARRAY.item(Heap, a, i_46)) <= (fun.ARRAY.item(Heap, a, (i_46) + (1)))));
	// ensures !old(Heap)[result, allocated];
	// ensures Heap[result, ARRAY.count] == u-l+1;
	// ensures attached(Heap, result, type_of(a));
	// modifies Heap;
	// ensures result != a;
	// ensures (forall i: int :: {fun.ARRAY.has(Heap, a, i)} {fun.ARRAY.has(Heap, result, i)}fun.ARRAY.has(Heap, a, i) == fun.ARRAY.has(Heap, result, i));
	// ensures (forall i_46: int :: (((1) <= (i_46)) && ((i_46) <= ((fun.ARRAY.count(Heap, result)) - (1)))) ==> ((fun.ARRAY.item(Heap, result, i_46)) <= (fun.ARRAY.item(Heap, result, (i_46) + (1)))));
	// ensures (forall i: int :: (1 <= i && i <= (u-l+1)) ==> (fun.ARRAY.item(Heap, result, i) == fun.ARRAY.item(Heap, a, l+i-1)));
  // ensures (forall<beta> o: ref, f: Field beta :: (old(Heap[o, allocated])) ==> (Heap[o, f] == old(Heap[o, f])));

// Array invariants
function ARRAY.inv(h: HeapType, a: ref) returns (bool) {
	(a != Void) ==> (h[a, ARRAY.count] >= 0)
}
function ARRAY#ref#.inv(h: HeapType, a: ref, ct: Type) returns (bool) {
	ARRAY.inv(h, a) &&
	(forall i: int :: fun.ARRAY.is_index(h, a, i) ==> (detachable(h, fun.ARRAY.item(h, a, i), ct)))
}
function ARRAY#int#.inv(h: HeapType, a: ref) returns (bool) {
	ARRAY.inv(h, a) &&
	(forall i: int :: fun.ARRAY.is_index(h, a, i) ==> is_integer_32(fun.ARRAY.item(h, a, i)))
}
function ARRAY#bool#.inv(h: HeapType, a: ref) returns (bool) {
	ARRAY.inv(h, a)
}

// procedure ARRAY#int#.make(
			// c: ref where attached(Heap, c, ARRAY#int#),
			// l: int where is_integer_32(l),
			// u: int where is_integer_32(u)
		// );
	// requires l <= u + 1; // pre line:1
	// ensures Heap[c, ARRAY.lower] == l;
	// ensures Heap[c, ARRAY.upper] == u;
	// ensures ARRAY.$inv(Heap, c);
	// ensures (forall i: int :: ARRAY.$is_index(Heap, c, i) ==> ARRAY.$item(Heap, c, i) == 0);
	// modifies Heap;
	// ensures (forall<beta> o: ref, f: Field beta :: (o != c || (f != ARRAY.lower && f != ARRAY.upper && f != ARRAY.count && f != $area)) ==> (Heap[o, f] == old(Heap)[o, f]));

// procedure ARRAY#int#.make_filled(
			// c: ref where attached(Heap, c, ARRAY#int#),
			// l: int where is_integer_32(l),
			// u: int where is_integer_32(u),
			// v: int where is_integer_32(v)
		// );
	// requires l <= u + 1;
	// ensures Heap[c, ARRAY.lower] == l;
	// ensures Heap[c, ARRAY.upper] == u;
	// ensures ARRAY.$inv(Heap, c);
	// ensures (forall i: int :: ARRAY.$is_index(Heap, c, i) ==> ARRAY.$item(Heap, c, i) == v);
	// modifies Heap;
	// ensures (forall<beta> o: ref, f: Field beta :: (o != c) ==> (Heap[o, f] == old(Heap)[o, f]));

// procedure ARRAY#int#.put(
			// c: ref where attached(Heap, c, ARRAY#int#),
			// item: int where is_integer_32(item),
			// pos: int where is_integer_32(pos)
		// );
	// requires ARRAY.$is_index(Heap, c, pos); // pre line:1
	// ensures ARRAY.$item(Heap, c, pos) == item;
	// ensures ARRAY.$inv(Heap, c);
	// modifies Heap;
	// ensures (forall<beta> o: ref, f: Field beta :: (o != c || f != $area) ==> (Heap[o, f] == old(Heap)[o, f]));
	// ensures (forall i: int :: (ARRAY.$is_index(Heap, c, i) && i != pos) ==> ARRAY.$item(Heap, c, i) == old(ARRAY.$item(Heap, c, i)));

// procedure ARRAY#int#.item(
			// c: ref where attached(Heap, c, ARRAY#int#),
			// pos: int where is_integer_32(pos)
		// ) returns (result: int);
	// requires ARRAY.$is_index(Heap, c, pos); // pre line:1
	// ensures result == ARRAY.$item(Heap, c, pos);

// procedure ARRAY#int#.count(
			// c: ref where attached(Heap, c, ARRAY#int#)
		// ) returns (result: int);
	// ensures result == Heap[c, ARRAY.count];

// function fun.ARRAY#int#.count(heap: HeapType, c: ref) returns (int) {
	// heap[c, ARRAY.count]
// }

// procedure ARRAY#int#.has(
			// c: ref where attached(Heap, c, ARRAY#int#),
			// val: int where is_integer_32(val)
		// ) returns (result: bool);
	// ensures result == (exists i: int :: (ARRAY.$is_index(Heap, c, i) && (ARRAY.$item(Heap, c, i) == val)));

// axiom (forall heap: HeapType, c: ref :: (fun.ARRAY#int#.count(heap, c) == 0) ==> (!(exists i: int :: ARRAY.$is_index(heap, c, i))));

// function fun.ARRAY#int#.has(heap: HeapType, c: ref, val: int) returns (bool) {
	// (exists i: int :: (ARRAY.$is_index(heap, c, i) && (ARRAY.$item(heap, c, i) == val)))
// }

// function fun.ARRAY#int#.has_not(heap: HeapType, c: ref, val: int) returns (bool) {
	// (forall i: int :: (ARRAY.$is_index(heap, c, i) ==> !(ARRAY.$item(heap, c, i) == val)))
// }


// procedure ARRAY#int#.subarray(
			// c: ref where attached(Heap, c, ARRAY^INTEGER_32^),
			// l: int where is_integer_32(l),
			// u: int where is_integer_32(u)
		// ) returns (result: ref);
	// requires 1 <= l && l <= fun.ARRAY#int#.count(Heap, c) + 1;
	// requires 0 <= u && u <= fun.ARRAY#int#.count(Heap, c);
// //	requires (l <= u) || (l == u + 1);
	// ensures (forall o: ref :: old(Heap)[o, allocated] ==> o != result);
	// ensures attached(Heap, result, ARRAY^INTEGER_32^);
	// ensures ARRAY.$inv(Heap, result);
	// ensures Heap[result, ARRAY.lower] == 1;
	// ensures Heap[result, ARRAY.count] == (u - l + 1);
	// ensures 0 <= fun.ARRAY#int#.count(Heap, result) && fun.ARRAY#int#.count(Heap, result) <= fun.ARRAY#int#.count(Heap, c);
	// ensures (forall i: int :: ARRAY.$is_index(Heap, result, i) ==> ARRAY.$item(Heap, result, i) == ARRAY.$item(Heap, c, i + l - 1));
	// ensures (forall i: int :: ARRAY.$is_index(Heap, result, i) ==> ARRAY.$item(Heap, result, i) == ARRAY.$item(Heap, c, i + l - 1));
	// modifies Heap;
	// ensures (forall<beta> o: ref, f: Field beta :: (o != result) ==> (Heap[o, f] == old(Heap)[o, f]));


// procedure ARRAY#ref#.make(
			// c: ref where attached(Heap, c, ARRAY#ref#),
			// l: int where is_integer_32(l),
			// u: int where is_integer_32(u)
		// );
	// requires l < u;
	// ensures Heap[c, ARRAY.lower] == l;
	// ensures Heap[c, ARRAY.upper] == u;
	// ensures ARRAY.$inv(Heap, c);
	// ensures (forall i: int :: ARRAY.$is_index(Heap, c, i) ==> ARRAY.$item(Heap, c, i) == Void);
	// modifies Heap;
	// ensures (forall<beta> o: ref, f: Field beta :: (o != c) ==> (Heap[o, f] == old(Heap)[o, f]));
