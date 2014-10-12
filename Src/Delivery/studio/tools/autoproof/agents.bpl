// ----------------------------------------------------------------------
// Agent theory

const unique ROUTINE: Type;
axiom (ROUTINE <: ANY);

const unique PROCEDURE: Type;
axiom (PROCEDURE <: ROUTINE);

const unique FUNCTION: Type;
axiom (FUNCTION <: ROUTINE);

// Precondition functions for different number of arguments

function routine.precondition_0 (heap: HeapType, agent: ref) returns (bool);
function routine.precondition_1<T1> (heap: HeapType, agent: ref, arg1: T1) returns (bool);
function routine.precondition_2<T1, T2> (heap: HeapType, agent: ref, arg1: T1, arg2: T2) returns (bool);

// Postcondition functions for different number of arguments

function routine.postcondition_0 (heap: HeapType, old_heap: HeapType, agent: ref) returns (bool);
function routine.postcondition_1<T1> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: T1) returns (bool);
function routine.postcondition_2<T1, T2> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: T1, arg2: T2) returns (bool);

// Postcondition functions for different number of arguments and return values

function function.postcondition_0<R> (heap: HeapType, old_heap: HeapType, agent: ref, result: R) returns (bool);
function function.postcondition_1<T1, R> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: T1, result: R) returns (bool);
function function.postcondition_2<T1, T2, R> (heap: HeapType, old_heap: HeapType, agent: ref, arg1: T1, arg2: T2, result: R) returns (bool);

// Frame condition function

function routine.modify_0 (heap: HeapType, agent: ref) returns (Frame);
function routine.modify_1<T1> (heap: HeapType, agent: ref, arg1: T1) returns (Frame);
function routine.modify_2<T1, T2> (heap: HeapType, agent: ref, arg1: T1, arg2: T2) returns (Frame);

// Call functions for different number of arguments

procedure routine.call_0 (Current: ref);
  requires attached(Heap, Current, ROUTINE); // info:type property for argument Current
  requires routine.precondition_0(Heap, Current); // type:pre tag:routine_precondition R1
  modifies Heap;
  ensures routine.postcondition_0(Heap, old(Heap), Current);
  free ensures global(Heap);
  requires Frame#Subset(routine.modify_0(Heap, Current), writable); // type:pre tag:frame_writable
  free ensures same_outside(old(Heap), Heap, routine.modify_0(old(Heap), Current));
  free ensures HeapSucc(old(Heap), Heap);

procedure routine.call_1<T1> (Current: ref, arg1: T1);
  requires attached(Heap, Current, ROUTINE); // info:type property for argument Current
  requires routine.precondition_1(Heap, Current, arg1); // type:pre tag:routine_precondition R1
  modifies Heap;
  ensures routine.postcondition_1(Heap, old(Heap), Current, arg1);
  free ensures global(Heap);
  requires Frame#Subset(routine.modify_1(Heap, Current, arg1), writable); // type:pre tag:frame_writable
  free ensures same_outside(old(Heap), Heap, routine.modify_1(old(Heap), Current, arg1));
  free ensures HeapSucc(old(Heap), Heap);

procedure routine.call_2<T1, T2> (Current: ref, arg1: T1, arg2: T2);
  requires attached(Heap, Current, ROUTINE); // info:type property for argument Current
  requires routine.precondition_2(Heap, Current, arg1, arg2); // pre ROUTINE:call tag:precondition
  modifies Heap;
  ensures routine.postcondition_2(Heap, old(Heap), Current, arg1, arg2);
  free ensures global(Heap);
  requires Frame#Subset(routine.modify_2(Heap, Current, arg1, arg2), writable); // type:pre tag:frame_writable
  free ensures same_outside(old(Heap), Heap, routine.modify_2(old(Heap), Current, arg1, arg2));
  free ensures HeapSucc(old(Heap), Heap);

procedure function.item_0<R> (Current: ref) returns (Result: R);
  requires attached(Heap, Current, FUNCTION); // info:type property for argument Current
  requires routine.precondition_0(Heap, Current);
  modifies Heap;
  ensures function.postcondition_0(Heap, old(Heap), Current, Result);
  requires Frame#Subset(routine.modify_0(Heap, Current), writable); // type:pre tag:frame_writable
  free ensures same_outside(old(Heap), Heap, routine.modify_0(old(Heap), Current));
  free ensures HeapSucc(old(Heap), Heap);

procedure function.item_1<T1, R> (Current: ref, arg1: T1) returns (Result: R);
  requires attached(Heap, Current, FUNCTION); // info:type property for argument Current
  requires routine.precondition_1(Heap, Current, arg1);
  modifies Heap;
  ensures function.postcondition_1(Heap, old(Heap), Current, arg1, Result);
  free ensures global(Heap);
  requires Frame#Subset(routine.modify_1(Heap, Current, arg1), writable); // type:pre tag:frame_writable
  free ensures same_outside(old(Heap), Heap, routine.modify_1(old(Heap), Current, arg1));
  free ensures HeapSucc(old(Heap), Heap);

procedure function.item_2<T1, T2, R> (Current: ref, arg1: T1, arg2: T2) returns (Result: R);
  requires attached(Heap, Current, FUNCTION); // info:type property for argument Current
  requires routine.precondition_2(Heap, Current, arg1, arg2);
  modifies Heap;
  ensures function.postcondition_2(Heap, old(Heap), Current, arg1, arg2, Result);
  free ensures global(Heap);
  requires Frame#Subset(routine.modify_2(Heap, Current, arg1, arg2), writable); // type:pre tag:frame_writable
  free ensures same_outside(old(Heap), Heap, routine.modify_2(old(Heap), Current, arg1, arg2));
  free ensures HeapSucc(old(Heap), Heap);


