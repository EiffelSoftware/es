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

