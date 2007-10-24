

//======================================================================
// Background theory starts here

// ----------------------------------------------------------------------
// STATE

// Some things are heaps
function IsHeap(h:[ref,name]any) returns (bool);

// Given an heap, some things are allocated
const unique $allocated:name;
function IsAllocated(h: [ref,name]any, o: any) returns (bool);
axiom (forall h: [ref,name]any, o: ref ::
        IsAllocated(h,o) <==> cast(h[o,$allocated],bool));

// Every reference stored in the heap is allocated
axiom (forall h:[ref,name]any, o: ref, f: name :: 
	{ IsAllocated(h,h[o,f]) }
	IsHeap(h) ==> IsAllocated(h,h[o,f]));

function new([ref,name]any) returns (ref);
function X([ref,name]any) returns ([ref,name]any);

axiom (forall h:[ref,name]any :: 
	{IsAllocated(X(h),new(h))} 
	IsAllocated(X(h),new(h)));

axiom (forall h:[ref,name]any :: 
	!IsAllocated(h,new(h)));

axiom (forall h:[ref,name]any, o:ref, f:name :: 
	{X(h)[o,f]}
	IsAllocated(h,o) ==> (X(h)[o,f] == h[o,f]));

// Void are always allocated
axiom (forall h: [ref,name]any :: 
	{ IsAllocated(h,null) } 
	IsAllocated(h,null));

// The global heap is a heap
var Heap: [ref,name]any where IsHeap(Heap);

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

function fun.ANY.conforms_to([ref,name]any,any,any) returns (bool);
axiom (forall h:[ref,name]any,a:ref,b:ref :: { fun.ANY.conforms_to(h,a,b) }
	fun.ANY.conforms_to(h,a,b) == true);

// ----------------------------------------------------------------------
// INTEGER_32 functions

// abs
function int.abs(int) returns (int);
axiom (forall c:int :: { int.abs(c) } (c >= 0) ==> (int.abs(c) == c));
axiom (forall c:int :: { int.abs(c) } (c <= 0) ==> (int.abs(c) == -c));

// out
function fun.INTEGER_32.out([ref,name]any,int) returns (ref);
axiom (forall h:[ref,name]any,c:int :: { fun.INTEGER_32.out(h,c) }
	(fun.INTEGER_32.out(h,c) != null));

// ----------------------------------------------------------------------
// BOOLEAN functions

// out
function fun.BOOLEAN.out([ref,name]any,int) returns (ref);
axiom (forall h:[ref,name]any,c:int :: { fun.BOOLEAN.out(h,c) }
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


// Background theory ends here
// ======================================================================
