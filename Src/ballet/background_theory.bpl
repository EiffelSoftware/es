// Background theory starts here

// ----------------------------------------------------------------------
// STATE

// Some things are heaps
function IsHeap(heap:[ref,<x>name]x) returns (bool);

// Given a heap, some things are allocated
const unique $allocated: <bool>name;
function IsAllocated(heap: [ref, <x>name]x, o: any) returns (bool);
axiom (forall heap: [ref, <x>name]x, o: ref ::
            { IsAllocated(heap, o) } // Trigger
        IsAllocated(heap,o) <==> heap[o, $allocated]);

function IsAllocatedAndNotVoid(heap: [ref, <x>name]x, o: ref) returns (bool);
axiom (forall heap: [ref, <x>name]x, o: ref ::
            { IsAllocatedAndNotVoid(heap, o) } // Trigger
        IsHeap(heap) ==> (IsAllocatedAndNotVoid(heap, o) <==> o != null && heap[o, $allocated]));

function IsAllocatedIfNotVoid(heap: [ref, <x>name]x, o: ref) returns (bool);
axiom (forall heap: [ref, <x>name]x, o: ref ::
            { IsAllocatedIfNotVoid(heap, o) } // Trigger
        IsHeap(heap) ==> (IsAllocatedIfNotVoid(heap, o) <==> (o != null ==> heap[o, $allocated])));


// Every reference stored in the heap is allocated
// TODO: is this necessary?
axiom (forall heap: [ref, <x>name]x, o: ref, f: <ref>name ::
            { IsAllocated(heap, heap[o, f]) } // Trigger
        IsHeap(heap) ==> IsAllocated(heap, heap[o, f]));


// TODO: are these functions still needed?
//function new([ref,<x>name]x) returns (ref);
//function X([ref,<x>name]x) returns ([ref,<x>name]x);

//axiom (forall h:[ref,<x>name]x :: 
//	{IsAllocated(X(h),new(h))} 
//	IsAllocated(X(h),new(h)));

//axiom (forall h:[ref,<x>name]x :: 
//	!IsAllocated(h,new(h)));

//axiom (forall h:[ref,<x>name]x, o:ref, f:name :: 
//	{X(h)[o,f]}
//	IsAllocated(h,o) ==> (X(h)[o,f] == h[o,f]));

// Void are always allocated
axiom (forall heap: [ref, <x>name]x :: 
            { IsAllocated(heap, null) } // Trigger
        IsHeap(heap) ==> IsAllocated(heap, null));

// The global heap (which is always a heap).
var Heap: [ref, <x>name]x where IsHeap(Heap);


// ----------------------------------------------------------------------
// Function call checks


// Only objects which are not null and are allocated are valid to call.
// Assert this function before every regular feature call.
function ValidCallTarget(heap: [ref, <x>name]x, o: ref) returns (bool);
axiom (forall heap: [ref, <x>name]x, o: ref ::
            { ValidCallTarget(heap, o) } // Trigger
        IsHeap(heap) ==> (ValidCallTarget(heap, o) <==> o != null && heap[o, $allocated]));

// Only objects which are not null and are not yet allocated are valid for
// creation. Assert this function before every call to a creation feature.
function ValidCreateTarget(heap: [ref, <x>name]x, o: ref) returns (bool);
axiom (forall heap: [ref, <x>name]x, o: ref  ::
            { ValidCreateTarget(heap, o) } // Trigger
        IsHeap(heap) ==> (ValidCreateTarget(heap, o) <==> o != null && !heap[o, $allocated]));

// Created objects need to be allocated on the heap. Assert this function
// after every call to a creation feature.
function ValidCreation(heap: [ref, <x>name]x, o: ref) returns (bool);
axiom (forall heap: [ref, <x>name]x, o: ref  ::
            { ValidCreation(heap, o) } // Trigger
        IsHeap(heap) ==> (ValidCreation(heap, o) <==> o != null && heap[o, $allocated]));


// ----------------------------------------------------------------------
// set theory
// ADT set

type set;

// Constructors
const set.make_empty: set;
function set.extended (set,any) returns (set);

// Content
function set.is_member (set,any) returns (bool);
axiom (forall s:set,x:any :: {set.is_member(set.extended(s,x),x)}
  set.is_member(set.extended(s,x),x));
axiom (forall s:set,x:any,y:any :: 
  x != y ==> set.is_member(set.extended(s,y),x) == set.is_member(s,x));
axiom (forall x:any :: !set.is_member (set.make_empty,x));

// Pruning
function set.pruned (set,any) returns (set);
axiom (forall x:any :: {set.pruned(set.make_empty,x)}
  set.pruned(set.make_empty,x) == set.make_empty);
axiom (forall s:set,x:any :: {set.pruned(set.extended(s,x),x)}
  set.pruned(set.extended(s,x),x) == set.pruned(s,x));
axiom (forall s:set,x:any,y:set :: {set.pruned(set.extended(s,x),y)}
  (x != y) ==> set.pruned(set.extended(s,x),y) == set.extended(set.pruned(s,y),x));

// Emptiness
function set.is_empty (set) returns (bool);
axiom (forall s:set,x:any :: !set.is_empty(set.extended(s,x)));
axiom (set.is_empty (set.make_empty));

// Cardinality
function set.cardinality (set) returns (int);
axiom (set.cardinality(set.make_empty) == 0);
axiom (forall s:set,x:any :: { set.cardinality(set.extended(s,x)) }
  !set.is_member(s,x) ==> 
    set.cardinality(set.extended(s,x)) == set.cardinality(s) + 1);
axiom (forall s:set,x:any :: { set.cardinality(set.extended(s,x)) }
  set.is_member(s,x) ==> 
    set.cardinality(set.extended(s,x)) == set.cardinality(s));

// Any element
function set.any_element (set) returns (any);
axiom (forall s:set,x:any :: set.any_element(set.extended(s,x)) == x);	

// Subset
function set.is_subset_of (set, set) returns (bool);
axiom (forall s:set :: set.is_subset_of (s, set.make_empty));
axiom (forall s1:set, s2:set, x:any :: 
  set.is_subset_of (s1, set.extended(s2, x)) == (set.is_subset_of (s1, s2) &&
    set.is_member (s1, x)));
	
// Equality
function set.equals (set, set) returns (bool);
axiom (forall s1:set, s2:set :: (s1 == s2) == (set.is_subset_of (s1, s2) &&
  set.is_subset_of (s2, s1)));
axiom (forall s1:set, s2:set :: (s1 == s2) == (set.equals (s1, s2)));

// Union
function set.united (set,set) returns (set);
axiom (forall s:set :: {set.united (s,set.make_empty)}
  set.united (s,set.make_empty) == s);
axiom (forall s1:set,s2:set,x:any :: {set.united(s1,set.extended(s2,x))}
  set.united(s1,set.extended(s2,x)) == set.extended(set.united(s1,s2),x));

// Intersected
function set.intersected (set,set) returns (set);
axiom (forall s:set :: {set.intersected(s,set.make_empty)}
  set.intersected(s,set.make_empty) == set.make_empty);
axiom (forall s1:set,s2:set,x:any :: {set.intersected(s1, set.extended(s2, x))}
  set.is_member(s1,x) ==> (set.intersected(s1,set.extended(s2,x))  == 
    set.extended (set.intersected(s1,s2),x)));
axiom (forall s1:set,s2:set,x:any :: {set.intersected(s1, set.extended(s2, x))}
  !set.is_member(s1,x) ==> (set.intersected(s1,set.extended(s2,x))  == 
    set.intersected(s1,s2)));
  
// Disjoint
function set.is_disjoint_from (set,set) returns (bool);
axiom (forall s:set :: {set.is_disjoint_from (s,set.make_empty)}
  set.is_disjoint_from (s,set.make_empty));
axiom (forall s1:set,s2:set,x:any :: set.is_disjoint_from (s1,set.extended(s2,x)) ==
  (!set.is_member(s1,x) && set.is_disjoint_from (s1, s2)));
axiom (forall s1:set, s2:set :: set.is_disjoint_from (s1, s2) == set.is_disjoint_from (s2, s1));

// Superset
function set.is_superset_of (set, set) returns (bool);
axiom (forall s1:set, s2:set :: {set.is_superset_of (s1, s2)}
	set.is_superset_of (s1, s2) == set.is_subset_of (s2, s1));
	
// proper Subset
function set.is_proper_superset (set, set) returns (bool);
axiom (forall s1:set, s2:set :: {set.is_proper_superset (s1, s2)}
  set.is_proper_superset (s1, s2) == (set.is_subset_of (s2, s1) && (s1 != s2)));

// proper Superset
function set.is_proper_subset (set,set) returns (bool);
axiom (forall s1:set,s2:set :: {set.is_proper_subset (s1, s2)}
  set.is_proper_subset (s1,s2) == (set.is_subset_of (s1, s2) && (s1 != s2)));

// Substracted
function set.subtracted (set,set) returns (set);
axiom (forall s:set :: {set.subtracted(s,set.make_empty)}
  set.subtracted(s,set.make_empty) == s);
axiom (forall s1:set,s2:set,x:any :: {set.subtracted(s1,set.extended(s2,x))}
  set.subtracted(s1,set.extended(s2,x)) == set.pruned(set.subtracted(s1,s2),x));

// Difference
function set.difference (set,set) returns (set);
axiom (forall s1:set,s2:set :: {set.difference(s1,s2)}
  set.difference(s1,s2) == set.subtracted(set.united(s1,s2),set.intersected(s1,s2)));

// ----------------------------------------------------------------------
// ANY functions

function fun.ANY.conforms_to([ref,<x>name]x,any,any) returns (bool);
axiom (forall h:[ref,<x>name]x,a:ref,b:ref :: { fun.ANY.conforms_to(h,a,b) }
	fun.ANY.conforms_to(h,a,b) == true);

// ----------------------------------------------------------------------
// INTEGER_32 functions

// abs
function int.abs(int) returns (int);
axiom (forall c:int :: { int.abs(c) } (c >= 0) ==> (int.abs(c) == c));
axiom (forall c:int :: { int.abs(c) } (c <= 0) ==> (int.abs(c) == -c));

// out
function fun.INTEGER_32.out([ref,<x>name]x,int) returns (ref);
axiom (forall h:[ref,<x>name]x,c:int :: { fun.INTEGER_32.out(h,c) }
	(fun.INTEGER_32.out(h,c) != null));

// ----------------------------------------------------------------------
// BOOLEAN functions

// out
function fun.BOOLEAN.out([ref,<x>name]x,int) returns (ref);
axiom (forall h:[ref,<x>name]x,c:int :: { fun.BOOLEAN.out(h,c) }
	(fun.BOOLEAN.out(h,c) != null));

// ----------------------------------------------------------------------
// STRING functions

// String Constants
function any_string (int) returns (ref);

// ----------------------------------------------------------------------
// MML_DEFAULT_SET functions

// make_from_element


// ----------------------------------------------------------------------
// FRAME functions



// ----------------------------------------------------------------------
// Agent functions

// Agent creation

procedure agent.create(
        Current: ref where Current != null && !Heap[Current,$allocated]    // The agent object
    );
    modifies Heap;
    // Frame condition: agent creation has no side effects
    ensures (forall $o: ref, $f: name :: 
                { Heap[$o, $f] } // Trigger
            ($o != null && old(Heap)[$o, $allocated] && $o != Current) ==> (old(Heap)[$o, $f] == Heap[$o, $f]));
    // Object allocated
    free ensures Heap[Current, $allocated];

// Precondition functions for different number of arguments

function agent.precondition_0 (heap: [ref,<x>name]x, agent: ref) returns (bool);
function agent.precondition_1 (heap: [ref,<x>name]x, agent: ref, arg1: ref) returns (bool);
function agent.precondition_2 (heap: [ref,<x>name]x, agent: ref, arg1: ref, arg2: ref) returns (bool);
function agent.precondition_3 (heap: [ref,<x>name]x, agent: ref, arg1: ref, arg2: ref, arg3: ref) returns (bool);
function agent.precondition_4 (heap: [ref,<x>name]x, agent: ref, arg1: ref, arg2: ref, arg3: ref, arg4: ref) returns (bool);
function agent.precondition_5 (heap: [ref,<x>name]x, agent: ref, arg1: ref, arg2: ref, arg3: ref, arg4: ref, arg5: ref) returns (bool);

// Postcondition functions for different number of arguments

function agent.postcondition_0 (heap: [ref,<x>name]x, old_heap: [ref,<x>name]x, agent: ref) returns (bool);
function agent.postcondition_1 (heap: [ref,<x>name]x, old_heap: [ref,<x>name]x, agent: ref, arg1: ref) returns (bool);
function agent.postcondition_2 (heap: [ref,<x>name]x, old_heap: [ref,<x>name]x, agent: ref, arg1: ref, arg2: ref) returns (bool);
function agent.postcondition_3 (heap: [ref,<x>name]x, old_heap: [ref,<x>name]x, agent: ref, arg1: ref, arg2: ref, arg3: ref) returns (bool);
function agent.postcondition_4 (heap: [ref,<x>name]x, old_heap: [ref,<x>name]x, agent: ref, arg1: ref, arg2: ref, arg3: ref, arg4: ref) returns (bool);
function agent.postcondition_5 (heap: [ref,<x>name]x, old_heap: [ref,<x>name]x, agent: ref, arg1: ref, arg2: ref, arg3: ref, arg4: ref, arg5: ref) returns (bool);

// Call functions for different number of arguments

procedure agent.call_0 (
        Current: ref where Current != null && Heap[Current,$allocated]     // The agent object
    );
    requires agent.precondition_0(Heap, Current);
    modifies Heap;
    ensures agent.postcondition_0(Heap, old(Heap), Current);

procedure agent.call_1 (
        Current: ref where Current != null && Heap[Current,$allocated],     // The agent object
        arg1: ref                                                           // First argument
    );
    requires agent.precondition_1(Heap, Current, arg1);
    modifies Heap;
    ensures agent.postcondition_1(Heap, old(Heap), Current, arg1);

procedure agent.call_2 (
        Current: ref where Current != null && Heap[Current,$allocated],     // The agent object
        arg1: ref,                                                          // First argument
        arg2: ref                                                           // Second argument
    );
    requires agent.precondition_2(Heap, Current, arg1, arg2);
    modifies Heap;
    ensures agent.postcondition_2(Heap, old(Heap), Current, arg1, arg2);

procedure agent.call_3 (
        Current: ref where Current != null && Heap[Current,$allocated],     // The agent object
        arg1: ref,                                                          // First argument
        arg2: ref,                                                          // Second argument
        arg3: ref                                                           // Third argument
    );
    requires agent.precondition_3(Heap, Current, arg1, arg2, arg3);
    modifies Heap;
    ensures agent.postcondition_3(Heap, old(Heap), Current, arg1, arg2, arg3);

procedure agent.call_4 (
        Current: ref where Current != null && Heap[Current,$allocated],     // The agent object
        arg1: ref,                                                          // First argument
        arg2: ref,                                                          // Second argument
        arg3: ref,                                                          // Third argument
        arg4: ref                                                           // Fourth argument
    );
    requires agent.precondition_4(Heap, Current, arg1, arg2, arg3, arg4);
    modifies Heap;
    ensures agent.postcondition_4(Heap, old(Heap), Current, arg1, arg2, arg3, arg4);

procedure agent.call_5 (
        Current: ref where Current != null && Heap[Current,$allocated],     // The agent object
        arg1: ref,                                                          // First argument
        arg2: ref,                                                          // Second argument
        arg3: ref,                                                          // Third argument
        arg4: ref,                                                          // Fourth argument
        arg5: ref                                                           // Fifth argument
    );
    requires agent.precondition_5(Heap, Current, arg1, arg2, arg3, arg4, arg5);
    modifies Heap;
    ensures agent.postcondition_5(Heap, old(Heap), Current, arg1, arg2, arg3, arg4, arg5);

// Background theory ends here
