

//======================================================================
// Background theory starts here

// ----------------------------------------------------------------------
// STATE

// Some things are heaps
function IsHeap(heap:[ref,<x>name]x) returns (bool);

// Given a heap, some things are allocated
const unique $allocated: <bool>name;
function IsAllocated(heap: [ref,<x>name]x, o: any) returns (bool);
//axiom (forall heap: [ref,<x>name]x, o: ref ::
//            { IsAllocated(heap, o) } // Trigger
//        IsAllocated(heap,o) <==> cast(heap[o,$allocated],bool));

// Every reference stored in the heap is allocated
axiom (forall heap: [ref,<x>name]x, o: ref, f: name ::
            { IsAllocated(heap, heap[o,f]) } // Trigger
        IsHeap(heap) ==> IsAllocated(heap, heap[o,f]));

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
axiom (forall heap: [ref,<x>name]x :: 
            { IsAllocated(heap, null) } // Trigger
        IsAllocated(heap, null));

// The global heap is a heap
var Heap: [ref,<x>name]x where IsHeap(Heap);


// ----------------------------------------------------------------------
// Function call checks

// Only objects which are not null and are allocated are valid to call.
// Assert this function before every regular feature call.
function ValidCallTarget(heap: [ref,<x>name]x, o: ref) returns (bool);
axiom (forall heap: [ref,<x>name]x, o: ref ::
            { ValidCallTarget(heap, o) } // Trigger
        IsHeap(heap) ==> (ValidCallTarget(heap, o) <==> o != null && heap[o, $allocated]));

// Only objects which are not null and are not yet allocated are valid for
// creation. Assert this function before every call to a creation feature.
function ValidCreateTarget(heap: [ref,<x>name]x, o: ref) returns (bool);
axiom (forall heap: [ref,<x>name]x, o: ref  ::
            { ValidCreateTarget(heap, o) } // Trigger
        IsHeap(heap) ==> (ValidCreateTarget(heap, o) <==> o != null && !heap[o, $allocated]));

// Created objects need to be allocated on the heap. Assert this function
// after every call to a creation feature.
function ValidCreation(heap: [ref,<x>name]x, o: ref) returns (bool);
axiom (forall heap: [ref,<x>name]x, o: ref  ::
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
// ROUTINE functions

// Agent call
procedure proc.ROUTINE.call (
        Current: ref where Current != null && Heap[Current,$allocated],     // The agent object
        arg: any);
    requires fun.ROUTINE.precondition(Heap, Current, arg);
    modifies Heap;
    ensures fun.ROUTINE.postcondition(Heap, old(Heap), Current, arg);


// Pseudo-attribute `feature' for agents
// Denotes the name of the feature which an agent represents
const unique $feature: <name>name;

// Attribute `target' of class ROUTINE
const unique field.ROUTINE.target: <ref>name;

// Function `target' of class ROUTINE
function fun.ROUTINE.target(heap: [ref, <x>name]x, agent: ref) returns (ref);
axiom (forall heap:[ref, <x>name]x, agent:ref ::
            { fun.ROUTINE.target(heap, agent) } // Trigger
        IsHeap(heap) ==> (fun.ROUTINE.target(heap, agent) == heap[agent, field.ROUTINE.target]));

// Creation feature
procedure create.ROUTINE.create_with_target(
        Current: ref where Current != null && !Heap[Current,$allocated],    // The agent object
        feature: name,                                                      // The name of the associated feature
        target: ref);                                                       // The closed target object
    // Precondition: valid target object
    requires target != null && Heap[target,$allocated];
    modifies Heap;
    // Postcondition: target set
    ensures fun.ROUTINE.target(Heap, Current) == target;
    // Frame condition
    ensures (forall $o: ref, $f: name :: { Heap[$o, $f] } $o != null && old(Heap)[$o, $allocated] && $o != Current ==> old(Heap)[$o, $f] == Heap[$o, $f]);
    // Object allocated
    free ensures Heap[Current, $allocated];
    // Feature association set
    free ensures Heap[Current, $feature] == feature;


// Precondition, closed target, 1 argument
function fun.ROUTINE.precondition(heap: [ref,<x>name]x, agent: ref, arg: any) returns (bool);

// Postcondition, closed target, 1 argument
function fun.ROUTINE.postcondition(heap: [ref,<x>name]x, old_heap: [ref,<x>name]x, agent: ref, arg: any) returns (bool);

// The actual precondition of an agent.
// Add axioms for all features which are used as an agent
function actual_precondition(feature: name, heap: [ref, <x>name]x, agent: ref, arg: ref) returns (bool);

// The actual postcondition of an agent.
// Add axioms for all features which are used as an agent
function actual_postcondition(feature: name, heap: [ref, <x>name]x, old_heap: [ref, <x>name]x, agent: ref, arg: ref) returns (bool);


// Associate general precondition of an agent with the actual precondition
axiom (forall heap: [ref, <x>name]x, agent: ref, arg: ref :: 
            { fun.ROUTINE.precondition(heap, agent, arg) } // Trigger
        IsHeap(heap) ==> (fun.ROUTINE.precondition(heap, agent, arg) <==> actual_precondition(heap[agent,$feature], heap, agent, arg) ));

// Associate general postcondition of an agent with the actual postcondition
axiom (forall heap: [ref, <x>name]x, old_heap: [ref, <x>name]x, agent: ref, arg: ref :: 
            { fun.ROUTINE.postcondition(heap, old_heap, agent, arg) } // Trigger
        IsHeap(heap) ==> (fun.ROUTINE.postcondition(heap, old_heap, agent, arg) <==> actual_postcondition(heap[agent,$feature], heap, old_heap, agent, arg) ));

  
// Background theory ends here
// ======================================================================


// **********************************************************************

// Feature {FORMATTER}.align_left
const unique feature.FORMATTER.align_left: name;
axiom (forall heap: [ref, <x>name]x, agent: ref, arg: ref ::
            { actual_precondition(feature.FORMATTER.align_left, heap, agent, arg) } // Trigger
        actual_precondition(feature.FORMATTER.align_left, heap, agent, arg) <==> arg != null && !fun.PARAGRAPH.is_left_aligned(heap, arg));
axiom (forall heap: [ref, <x>name]x, old_heap: [ref, <x>name]x, agent: ref, arg: ref ::
            { actual_postcondition(feature.FORMATTER.align_left, heap, old_heap, agent, arg) } // Trigger
        actual_postcondition(feature.FORMATTER.align_left, heap, old_heap, agent, arg) <==> fun.PARAGRAPH.is_left_aligned(heap, arg));

// Feature {FORMATTER}.align_right
const unique feature.FORMATTER.align_right: name;
axiom (forall heap: [ref, <x>name]x, agent: ref, arg: ref ::
            { actual_precondition(feature.FORMATTER.align_right, heap, agent, arg) } // Trigger
        actual_precondition(feature.FORMATTER.align_right, heap, agent, arg) <==> arg != null && fun.PARAGRAPH.is_left_aligned(heap, arg));
axiom (forall heap: [ref, <x>name]x, old_heap: [ref, <x>name]x, agent: ref, arg: ref ::
            { actual_postcondition(feature.FORMATTER.align_right, heap, old_heap, agent, arg) } // Trigger
        actual_postcondition(feature.FORMATTER.align_right, heap, old_heap, agent, arg) <==> !fun.PARAGRAPH.is_left_aligned(heap, arg));

// **********************************************************************
