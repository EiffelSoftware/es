// Basic theory for EVE Proofs
// Date: $Date$
// Revision: $Revision$

// ----------------------------------------------------------------------
// Reference types

// Type definition for reference types
type ref;

// Constant for Void references
const Void: ref;

// ----------------------------------------------------------------------
// Heap and allocation

// Type of a field (with open subtype)
type Field _;

// Type of a heap (with generic field subtype and generic content type)
type HeapType = <beta>[ref, Field beta]beta;

// Function which defines a heap
function IsHeap(heap: HeapType) returns (bool);

// The global heap (which is always a heap)
var Heap: HeapType where IsHeap(Heap);

// Allocation field (a gohst field)
const unique $allocated: Field bool;

// Function to check if an object is allocated
function IsAllocated(heap: HeapType, o: ref) returns (bool);
axiom (forall heap: HeapType, o: ref ::
            { IsAllocated(heap, o) } // Trigger
        IsAllocated(heap, o) <==> heap[o, $allocated]);

// Function to check if an object is allocated and not void
function IsAllocatedAndNotVoid(heap: HeapType, o: ref) returns (bool);
axiom (forall heap: HeapType, o: ref ::
            { IsAllocatedAndNotVoid(heap, o) } // Trigger
        IsHeap(heap) ==> (IsAllocatedAndNotVoid(heap, o) <==> o != Void && IsAllocated(heap, o)));

// Function to check if an object is allocated if it is not void
function IsAllocatedIfNotVoid(heap: HeapType, o: ref) returns (bool);
axiom (forall heap: HeapType, o: ref ::
            { IsAllocatedIfNotVoid(heap, o) } // Trigger
        IsHeap(heap) ==> (IsAllocatedIfNotVoid(heap, o) <==> (o != Void ==> IsAllocated(heap, o))));

// Every reference stored in the heap is allocated
axiom (forall heap: HeapType, o: ref, f: Field ref ::
            { IsAllocated(heap, heap[o, f]) } // Trigger
        IsHeap(heap) ==> IsAllocated(heap, heap[o, f]));

// Void is always allocated
axiom (forall heap: HeapType :: 
            { IsAllocated(heap, Void) } // Trigger
        IsHeap(heap) ==> IsAllocated(heap, Void));

// ----------------------------------------------------------------------
// Typing

// Type definition for Eiffel types
type Type;

// Function to define type of references
function IsOfType(o: ref, t: Type) returns (bool);

// Basic types
const unique type.ANY: Type;

// Void is of any type
axiom (forall t: Type ::
			{ IsOfType(Void, t) }
		IsOfType(Void, t));

// TODO: what functions do we need for typing?
//function DeclaredType(field: name) returns (class: name);

// ----------------------------------------------------------------------
// Real types

// Type definition for reference types
type real;

// ----------------------------------------------------------------------
// Unhandled types (reference types other than integers)

// Type definition for unhandled types
type unknown;

// Constant for initalizing unhandled types
const Mistery: unknown;

// ----------------------------------------------------------------------
// Set theory
/*
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
*/
// ----------------------------------------------------------------------
// Agent theory

// Precondition functions for different number of arguments

function routine.precondition_0 (heap: HeapType, agent: ref) returns (bool);
function routine.precondition_1<arg1Type> (heap: HeapType, agent: ref, arg1: arg1Type) returns (bool);
function routine.precondition_2<arg1Type, arg2Type> (heap: HeapType, agent: ref, arg1: arg1Type, arg2: arg2Type) returns (bool);
function routine.precondition_3<arg1Type, arg2Type, arg3Type> (heap: HeapType, agent: ref, arg1: arg1Type, arg2: arg2Type, arg3: arg3Type) returns (bool);

// Postcondition functions for different number of arguments

function routine.postcondition_0 (heap: HeapType, old_heap: HeapType, agent: ref) returns (bool);
function routine.postcondition_1<arg1Type> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: arg1Type) returns (bool);
function routine.postcondition_2<arg1Type, arg2Type> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: arg1Type, arg2: arg2Type) returns (bool);
function routine.postcondition_3<arg1Type, arg2Type, arg3Type> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: arg1Type, arg2: arg2Type, arg3: arg3Type) returns (bool);

// Postcondition functions for different number of arguments and return values

function function.postcondition_0<resultType> (heap: HeapType, old_heap: HeapType, agent: ref, result: resultType) returns (bool);
function function.postcondition_1<arg1Type, resultType> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: arg1Type, result: resultType) returns (bool);
function function.postcondition_2<arg1Type, arg2Type, resultType> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: arg1Type, arg2: arg2Type, result: resultType) returns (bool);
function function.postcondition_3<arg1Type, arg2Type, arg3Type, resultType> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: arg1Type, arg2: arg2Type, arg3: arg3Type, result: resultType) returns (bool);

// Frame condition function

function agent.modifies<alpha>(agent: ref, $o: ref, $f: Field alpha) returns (bool);

// Agent creation

procedure routine.create(
        Current: ref where Current != Void && !Heap[Current,$allocated]    // The agent object
    );
    modifies Heap;
    // Frame condition
    ensures frame.modifies_current (Heap, old(Heap), Current);
    // Object allocated
    free ensures Heap[Current, $allocated];

// Call functions for different number of arguments

procedure routine.call_0 (
        Current: ref where Current != Void && Heap[Current,$allocated]     // The agent object
    );
    requires routine.precondition_0(Heap, Current); // pre ROUTINE:call tag:precondition
    modifies Heap;
    ensures (forall<alpha> $o: ref, $f: Field alpha :: { Heap[$o, $f] } ($o != Void && old(Heap)[$o, $allocated] && !agent.modifies(Current, $o, $f)) ==> (old(Heap)[$o, $f] == Heap[$o, $f])); // frame ROUTINE:call
    ensures routine.postcondition_0(Heap, old(Heap), Current);

procedure routine.call_1<arg1Type> (
        Current: ref where Current != Void && Heap[Current,$allocated],     // The agent object
        arg1: arg1Type                                                           // First argument
    );
    requires routine.precondition_1(Heap, Current, arg1); // pre ROUTINE:call tag:precondition
    modifies Heap;
    ensures (forall<alpha> $o: ref, $f: Field alpha :: { Heap[$o, $f] } ($o != Void && old(Heap)[$o, $allocated] && !agent.modifies(Current, $o, $f)) ==> (old(Heap)[$o, $f] == Heap[$o, $f])); // frame ROUTINE:call
    ensures routine.postcondition_1(Heap, old(Heap), Current, arg1);

procedure routine.call_2<arg1Type, arg2Type> (
        Current: ref where Current != Void && Heap[Current,$allocated],     // The agent object
        arg1: arg1Type,                                                          // First argument
        arg2: arg2Type// Second argument
    );
    requires routine.precondition_2(Heap, Current, arg1, arg2); // pre ROUTINE:call tag:precondition
    modifies Heap;
    ensures (forall<alpha> $o: ref, $f: Field alpha :: { Heap[$o, $f] } ($o != Void && old(Heap)[$o, $allocated] && !agent.modifies(Current, $o, $f)) ==> (old(Heap)[$o, $f] == Heap[$o, $f])); // frame ROUTINE:call
    ensures routine.postcondition_2(Heap, old(Heap), Current, arg1, arg2);

procedure routine.call_3<arg1Type, arg2Type, arg3Type> (
        Current: ref where Current != Void && Heap[Current,$allocated],     // The agent object
        arg1: arg1Type,                                                          // First argument
        arg2: arg2Type,                                                          // Second argument
        arg3: arg3Type                                                           // Third argument
    );
    requires routine.precondition_3(Heap, Current, arg1, arg2, arg3); // pre ROUTINE:call tag:precondition
    modifies Heap;
    ensures (forall<alpha> $o: ref, $f: Field alpha :: { Heap[$o, $f] } ($o != Void && old(Heap)[$o, $allocated] && !agent.modifies(Current, $o, $f)) ==> (old(Heap)[$o, $f] == Heap[$o, $f])); // frame ROUTINE:call
    ensures routine.postcondition_3(Heap, old(Heap), Current, arg1, arg2, arg3);

// Item functions for different number of arguments

procedure function.item_0<resultType> (
        Current: ref where Current != Void && Heap[Current,$allocated]     // The agent object
    ) returns (Result: resultType);
    requires routine.precondition_0(Heap, Current);
    modifies Heap;
    ensures frame.modifies_agent(Heap, old(Heap), Current); // frame FUNCTION:item
    ensures function.postcondition_0(Heap, old(Heap), Current, Result);

procedure function.item_1<arg1Type, resultType> (
        Current: ref where Current != Void && Heap[Current,$allocated],     // The agent object
        arg1: arg1Type                                                           // First argument
    ) returns (Result: resultType);
    requires routine.precondition_1(Heap, Current, arg1);
    modifies Heap;
    ensures frame.modifies_agent(Heap, old(Heap), Current); // frame FUNCTION:item
    ensures function.postcondition_1(Heap, old(Heap), Current, arg1, Result);

procedure function.item_2<arg1Type, arg2Type, resultType> (
        Current: ref where Current != Void && Heap[Current,$allocated],     // The agent object
        arg1: arg1Type,                                                          // First argument
        arg2: arg2Type                                                           // Second argument
    ) returns (Result: resultType);
    requires routine.precondition_2(Heap, Current, arg1, arg2);
    modifies Heap;
    ensures frame.modifies_agent(Heap, old(Heap), Current); // frame FUNCTION:item
    ensures function.postcondition_2(Heap, old(Heap), Current, arg1, arg2, Result);

procedure function.item_3<arg1Type, arg2Type, arg3Type, resultType> (
        Current: ref where Current != Void && Heap[Current,$allocated],     // The agent object
        arg1: arg1Type,                                                          // First argument
        arg2: arg2Type,                                                          // Second argument
        arg3: arg3Type                                                           // Third argument
    ) returns (Result: resultType);
    requires routine.precondition_3(Heap, Current, arg1, arg2, arg3);
    modifies Heap;
    ensures frame.modifies_agent(Heap, old(Heap), Current); // frame FUNCTION:item
    ensures function.postcondition_3(Heap, old(Heap), Current, arg1, arg2, arg3, Result);

// ----------------------------------------------------------------------
// Frame conditions

// Frame condition for a feature which modifies nothing.
// TODO: simpler to use "Heap == old(Heap)"
/*
function frame.modifies_nothing(heap: HeapType, old_heap: HeapType) returns (bool);
axiom (forall heap: HeapType, old_heap: HeapType :: 
            { frame.modifies_nothing(heap, old_heap) } // Trigger
        frame.modifies_nothing(heap, old_heap) <==> 
            (forall<alpha> $o: ref, $f: Field alpha :: 
                    { heap[$o, $f] } // Trigger
                ($o != Void && IsAllocated(old_heap, $o)) ==> (old_heap[$o, $f] == heap[$o, $f])));
*/
// Frame condition for a feature which modifies only the `Current' object.
function frame.modifies_current(heap: HeapType, old_heap: HeapType, current: ref) returns (bool);
axiom (forall heap: HeapType, old_heap: HeapType, current: ref :: 
            { frame.modifies_current(heap, old_heap, current) } // Trigger
        frame.modifies_current(heap, old_heap, current) <==> 
            (forall<alpha> $o: ref, $f: Field alpha :: 
                    { heap[$o, $f] } // Trigger
                ($o != Void && IsAllocated(old_heap, $o) && $o != current) ==> (old_heap[$o, $f] == heap[$o, $f])));

// Frame condition for a feature which modifies what the `agent' modifies.
function frame.modifies_agent(heap: HeapType, old_heap: HeapType, agent: ref) returns (bool);
axiom (forall heap: HeapType, old_heap: HeapType, agent: ref :: 
            { frame.modifies_agent(heap, old_heap, agent) } // Trigger
        frame.modifies_agent(heap, old_heap, agent) <==> 
            (forall<alpha> $o: ref, $f: Field alpha :: 
                    { heap[$o, $f] } // Trigger
                ($o != Void && IsAllocated(old_heap, $o) && !agent.modifies(agent, $o, $f)) ==> (old_heap[$o, $f] == heap[$o, $f])));

// Frame condition saying that all objects which were allocated before are still allocated after a call.
function frame.no_objects_destroyed(heap: HeapType, old_heap: HeapType) returns (bool);
axiom (forall heap: HeapType, old_heap: HeapType :: 
            { frame.no_objects_destroyed(heap, old_heap) } // Trigger
        frame.no_objects_destroyed(heap, old_heap) <==> 
            (forall $o: ref :: 
                    { IsAllocated(heap, $o) } // Trigger
                (IsAllocated(old_heap, $o) ==> IsAllocated(heap, $o))));


// ----------------------------------------------------------------------
// Default signatures

// Creation routine default_create from class ANY
// --------------------------------------

// Signature
procedure create.ANY.default_create(Current: ref where Current != Void && Heap[Current, $allocated]);
    // User invariants (entry) ommited
    // User invariants (exit)
//    ensures fun.ANY.standard_is_equal(Heap, Current, Current); // inv ANY:372 tag:reflexive_equality
//    ensures fun.ANY.conforms_to(Heap, Current, Current); // inv ANY:373 tag:reflexive_conformance
    // Frame condition
    modifies Heap;
    ensures Heap == old(Heap); // frame ANY:default_create
    // Creation routine condition
    free ensures Heap[Current, $allocated];

