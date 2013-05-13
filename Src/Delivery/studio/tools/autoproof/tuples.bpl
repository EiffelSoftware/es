// ----------------------------------------------------------------------
// Tuples

// Types for tuple objects
const unique TUPLE: Type;

// Field for count of tuple elements
const unique TUPLE.count: Field int;
axiom (forall h: HeapType, a:ref :: h[a, TUPLE.count] >= 0);

// Creator for tuples with zero arguments
procedure TUPLE.make0(c: ref where attached(Heap, c, TUPLE));
	ensures Heap[c, TUPLE.count] == 0;
	ensures (forall<beta> o: ref, f: Field beta :: (o != c || f == allocated) ==> (Heap[o, f] == old(Heap)[o, f]));

// Creator for tuples with one argument
procedure TUPLE.make1<a1>(
			c: ref where attached(Heap, c, TUPLE),
			i1: a1);
	ensures Heap[c, area][1] == i1;
	ensures Heap[c, TUPLE.count] == 1;
	ensures (forall<beta> o: ref, f: Field beta :: (o != c || f == allocated) ==> (Heap[o, f] == old(Heap)[o, f]));

// Creator for tuples with two arguments
procedure TUPLE.make2<a1, a2>(
			c: ref where attached(Heap, c, TUPLE),
			i1: a1,
			i2: a2);
	ensures Heap[c, area][1] == i1;
	ensures Heap[c, area][2] == i2;
	ensures Heap[c, TUPLE.count] == 2;
	ensures (forall<beta> o: ref, f: Field beta :: (o != c || f == allocated) ==> (Heap[o, f] == old(Heap)[o, f]));

// Creator for tuples with three arguments
procedure TUPLE.make3<a1, a2, a3>(
			c: ref where attached(Heap, c, TUPLE),
			i1: a1,
			i2: a2,
			i3: a3);
	ensures Heap[c, area][1] == i1;
	ensures Heap[c, area][2] == i2;
	ensures Heap[c, area][3] == i3;
	ensures Heap[c, TUPLE.count] == 3;
	ensures (forall<beta> o: ref, f: Field beta :: (o != c || f == allocated) ==> (Heap[o, f] == old(Heap)[o, f]));

// Procedure to access tuple elements
procedure TUPLE.item<alpha>(
			c: ref where attached(Heap, c, TUPLE),
			i: int)
		returns (result: alpha);
	requires 1 <= i && i <= Heap[c, TUPLE.count];
	ensures result == Heap[c, area][i];

// Function to access tuple elements
function fun.TUPLE.item<alpha>(heap: HeapType, c: ref, i: int) returns (alpha) {
	heap[c, area][i]
}
