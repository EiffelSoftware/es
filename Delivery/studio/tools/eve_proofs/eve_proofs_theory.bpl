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

// Type field (a ghost field)
const unique $type: Field Type;

// Function to define type of references
//function IsOfType(o: ref, t: Type) returns (bool);

// Basic types
const unique ANY: Type;

// Void is of any type
//axiom (forall t: Type ::
//			{ IsOfType(Void, t) }
//		IsOfType(Void, t));

function StaticType(o: ref) returns (Type);
function DynamicType(o: ref) returns (Type);
		
// TODO: what functions do we need for typing?
//function DeclaredType(field: name) returns (class: name);


// TODO: name section, write comments
function IsAttachedType(heap: HeapType, o: ref, t: Type) returns (bool);
function IsDetachedType(heap: HeapType, o: ref, t: Type) returns (bool);
function IsNatural(i: int) returns (bool);

axiom (forall heap: HeapType, $o: ref, $t: Type ::
			{ IsAttachedType(heap, $o, $t) } // Trigger
		IsAttachedType(heap, $o, $t) ==> ($o != Void && IsAllocated(heap, $o) && heap[$o, $type] <: $t));
axiom (forall heap: HeapType, $o: ref, $t: Type ::
			{ IsDetachedType(heap, $o, $t) } // Trigger
		IsDetachedType(heap, $o, $t) ==> ($o != Void ==> (IsAllocated(heap, $o) && heap[$o, $type] <: $t)));
axiom (forall $i: int ::
			{ IsNatural($i) } // Trigger
		IsNatural($i) ==> $i >= 0);

function DeclaredType(heap: HeapType, $f: Field ref, $t: Type) returns (bool);


// ----------------------------------------------------------------------
// Real types (not yet used)

// Type definition for reference types
type real;

// ----------------------------------------------------------------------
// Unhandled types (expanded types other than integers)

// Type definition for unhandled types
type unknown;

// Constant for initalizing unhandled types
const Unknown: unknown;

// ----------------------------------------------------------------------
// Integer division

function div(a: int, b: int) returns (int);

axiom (forall a, b: int :: div(a, b) * b == a);

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

function agent.modifies_0<alpha> (heap: HeapType, old_heap: HeapType, agent: ref, $o: ref, $f: Field alpha) returns (bool);
function agent.modifies_1<alpha, arg1Type> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: arg1Type, $o: ref, $f: Field alpha) returns (bool);
function agent.modifies_2<alpha, arg1Type, arg2Type> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: arg1Type, arg2: arg2Type, $o: ref, $f: Field alpha) returns (bool);
function agent.modifies_3<alpha, arg1Type, arg2Type, arg3Type> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: arg1Type, arg2: arg2Type, arg3: arg3Type, $o: ref, $f: Field alpha) returns (bool);

// Agents are not changing the reference to themselves...
axiom (forall<alpha> heap: HeapType, old_heap: HeapType, $a: ref, $o: ref, $f: Field alpha ::
			{ agent.modifies_0(heap, old_heap, $a, $o, $f) }
		old_heap[$o, $f] == $a ==> (agent.modifies_0(heap, old_heap, $a, $o, $f) ==> false));
axiom (forall<alpha, arg1Type> heap: HeapType, old_heap: HeapType, $a: ref, arg1: arg1Type, $o: ref, $f: Field alpha ::
			{ agent.modifies_1(heap, old_heap, $a, arg1, $o, $f) }
		old_heap[$o, $f] == $a ==> (agent.modifies_1(heap, old_heap, $a, arg1, $o, $f) ==> false));
axiom (forall<alpha, arg1Type, arg2Type> heap: HeapType, old_heap: HeapType, $a: ref, arg1: arg1Type, arg2: arg2Type, $o: ref, $f: Field alpha ::
			{ agent.modifies_2(heap, old_heap, $a, arg1, arg2, $o, $f) }
		old_heap[$o, $f] == $a ==> (agent.modifies_2(heap, old_heap, $a, arg1, arg2, $o, $f) ==> false));
axiom (forall<alpha, arg1Type, arg2Type, arg3Type> heap: HeapType, old_heap: HeapType, $a: ref, arg1: arg1Type, arg2: arg2Type, arg3: arg3Type, $o: ref, $f: Field alpha ::
			{ agent.modifies_3(heap, old_heap, $a, arg1, arg2, arg3, $o, $f) }
		old_heap[$o, $f] == $a ==> (agent.modifies_3(heap, old_heap, $a, arg1, arg2, arg3, $o, $f) ==> false));


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
    ensures (forall<alpha> $o: ref, $f: Field alpha :: { Heap[$o, $f] } ($o != Void && old(Heap)[$o, $allocated] && !agent.modifies_0(Heap, old(Heap), Current, $o, $f)) ==> (old(Heap)[$o, $f] == Heap[$o, $f])); // frame ROUTINE:call
    ensures routine.postcondition_0(Heap, old(Heap), Current);

procedure routine.call_1<arg1Type> (
        Current: ref where Current != Void && Heap[Current,$allocated],     // The agent object
        arg1: arg1Type                                                           // First argument
    );
    requires routine.precondition_1(Heap, Current, arg1); // pre ROUTINE:call tag:precondition
    modifies Heap;
    ensures (forall<alpha> $o: ref, $f: Field alpha :: { Heap[$o, $f] } ($o != Void && old(Heap)[$o, $allocated] && !agent.modifies_1(Heap, old(Heap), Current, arg1, $o, $f)) ==> (old(Heap)[$o, $f] == Heap[$o, $f])); // frame ROUTINE:call
    ensures routine.postcondition_1(Heap, old(Heap), Current, arg1);

procedure routine.call_2<arg1Type, arg2Type> (
        Current: ref where Current != Void && Heap[Current,$allocated],     // The agent object
        arg1: arg1Type,                                                          // First argument
        arg2: arg2Type// Second argument
    );
    requires routine.precondition_2(Heap, Current, arg1, arg2); // pre ROUTINE:call tag:precondition
    modifies Heap;
    ensures (forall<alpha> $o: ref, $f: Field alpha :: { Heap[$o, $f] } ($o != Void && old(Heap)[$o, $allocated] && !agent.modifies_2(Heap, old(Heap), Current, arg1, arg2, $o, $f)) ==> (old(Heap)[$o, $f] == Heap[$o, $f])); // frame ROUTINE:call
    ensures routine.postcondition_2(Heap, old(Heap), Current, arg1, arg2);

procedure routine.call_3<arg1Type, arg2Type, arg3Type> (
        Current: ref where Current != Void && Heap[Current,$allocated],     // The agent object
        arg1: arg1Type,                                                          // First argument
        arg2: arg2Type,                                                          // Second argument
        arg3: arg3Type                                                           // Third argument
    );
    requires routine.precondition_3(Heap, Current, arg1, arg2, arg3); // pre ROUTINE:call tag:precondition
    modifies Heap;
    ensures (forall<alpha> $o: ref, $f: Field alpha :: { Heap[$o, $f] } ($o != Void && old(Heap)[$o, $allocated] && !agent.modifies_3(Heap, old(Heap), Current, arg1, arg2, arg3, $o, $f)) ==> (old(Heap)[$o, $f] == Heap[$o, $f])); // frame ROUTINE:call
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
                ($o != Void && IsAllocated(old_heap, $o) && !agent.modifies_0(heap, old_heap, agent, $o, $f)) ==> (old_heap[$o, $f] == heap[$o, $f])));

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

