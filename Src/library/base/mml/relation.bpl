// Finite relation.

// Relation type
type Rel U V = [U, V]bool;

// Domain
function Rel#Domain<U, V>(Rel U V): Set U;
axiom (forall<U, V> r: Rel U V, u: U :: { Rel#Domain(r)[u] }
  Rel#Domain(r)[u] <==> (exists v: V :: r[u, v]));
  
// Range
function Rel#Range<U, V>(Rel U V): Set V;
axiom (forall<U, V> r: Rel U V, v: V :: { Rel#Range(r)[v] }
  Rel#Range(r)[v] <==> (exists u: U :: r[u, v]));  

// Cardinality
function Rel#Card<U, V>(Rel U V): int;
axiom (forall<U, V> r: Rel U V :: { Rel#Card(r) } 0 <= Rel#Card(r));

// Empty relation
function Rel#Empty<U, V>(): Rel U V;
axiom (forall<U, V> u: U, v: V :: { Rel#Empty()[u, v] } !Rel#Empty()[u, v]);
axiom (forall<U, V> r: Rel U V :: { Rel#Card(r) }
  (Rel#Card(r) == 0 <==> r == Rel#Empty()) &&
  (Rel#Card(r) != 0 ==> (exists u: U, v: V :: r[u, v])));
axiom (forall<U, V> r: Rel U V :: { Rel#Domain(r) }
  (Set#IsEmpty(Rel#Domain(r)) <==> r == Rel#Empty()));
axiom (forall<U, V> r: Rel U V :: { Rel#Range(r) }
  (Set#IsEmpty(Rel#Range(r)) <==> r == Rel#Empty()));  
axiom (forall<U, V> f: Field (Rel U V) :: { Default(f) } Default(f) == Rel#Empty() : Rel U V);    

// Singleton relation  
function Rel#Singleton<U, V>(U, V): Rel U V;
axiom (forall<U, V> u: U, v: V :: { Rel#Singleton(u, v) } Rel#Singleton(u, v)[u, v]);
axiom (forall<U, V> u: U, v: V, x: U, y: V :: { Rel#Singleton(u, v)[x, y] } Rel#Singleton(u, v)[x, y] <==> u == x && v == y);
axiom (forall<U, V> u: U, v: V :: { Rel#Card(Rel#Singleton(u, v)) } Rel#Card(Rel#Singleton(u, v)) == 1);
axiom (forall<U, V> u: U, v: V :: { Rel#Domain(Rel#Singleton(u, v)) } 
  Rel#Domain(Rel#Singleton(u, v)) == Set#Singleton(u));
axiom (forall<U, V> u: U, v: V :: { Rel#Range(Rel#Singleton(u, v)) } 
  Rel#Range(Rel#Singleton(u, v)) == Set#Singleton(v));
  
// Is the relation empty?
function {: inline} Rel#IsEmpty<U, V>(r: Rel U V): bool
{ Rel#Equal(Rel#Empty(), r) }

// Image of a domain element
function Rel#ImageOf<U, V>(r: Rel U V, u: U): Set V;
axiom (forall<U, V> r: Rel U V, u: U, v: V :: { Rel#ImageOf(r, u)[v] }
  Rel#ImageOf(r, u)[v] <==> r[u, v]);
axiom (forall<U, V> r: Rel U V, u: U :: { Rel#ImageOf(r, u) }
  Set#Subset(Rel#ImageOf(r, u), Rel#Range(r)));
  
  
// Image of a set
function Rel#Image<U, V>(r: Rel U V, s: Set U): Set V;
axiom (forall<U, V> r: Rel U V, s: Set U, v: V :: { Rel#Image(r, s)[v] }
  Rel#Image(r, s)[v] <==> (exists u: U :: s[u] && r[u, v]));
axiom (forall<U, V> r: Rel U V, s: Set U :: { Rel#Image(r, s) }
  Set#Subset(Rel#Image(r, s), Rel#Range(r)));  
  
// Are two relation equal?  
function Rel#Equal<U, V>(Rel U V, Rel U V): bool;
axiom(forall<U, V> a: Rel U V, b: Rel U V :: { Rel#Equal(a, b) }
  Rel#Equal(a, b) <==> (forall u: U, v: V :: {a[u, v]} {b[u, v]} a[u, v] <==> b[u, v]));
axiom(forall<U, V> a: Rel U V, b: Rel U V :: { Rel#Equal(a, b) }  // extensionality axiom for relation
  Rel#Equal(a, b) ==> a == b);

// Relation extended with one element  
function Rel#Extended<U, V>(Rel U V, U, V): Rel U V;
axiom (forall<U, V> a: Rel U V, u: U, v: V, x: U, y: V :: { Rel#Extended(a, u, v)[x, y] }
  Rel#Extended(a, u, v)[x, y] <==> (u == x && v == y) || a[x, y]);
axiom (forall<U, V> a: Rel U V, u: U, v: V :: { Rel#Extended(a, u, v) }
  Rel#Extended(a, u, v)[u, v]);
axiom (forall<U, V> a: Rel U V, u: U, v: V, x: U, y: V :: { Rel#Extended(a, u, v), a[x, y] }
  a[x, y] ==> Rel#Extended(a, u, v)[x, y]);
axiom (forall<U, V> a: Rel U V, u: U, v: V :: { Rel#Card(Rel#Extended(a, u, v)) }
  a[u, v] ==> Rel#Card(Rel#Extended(a, u, v)) == Rel#Card(a));  
axiom (forall<U, V> a: Rel U V, u: U, v: V :: { Rel#Card(Rel#Extended(a, u, v)) }
  !a[u, v] ==> Rel#Card(Rel#Extended(a, u, v)) == Rel#Card(a) + 1);
axiom (forall<U, V> a: Rel U V, u: U, v: V :: { Rel#Domain(Rel#Extended(a, u, v)) }
  Rel#Domain(Rel#Extended(a, u, v)) == Set#Extended(Rel#Domain(a), u));  
axiom (forall<U, V> a: Rel U V, u: U, v: V :: { Rel#Range(Rel#Extended(a, u, v)) }
  Rel#Range(Rel#Extended(a, u, v)) == Set#Extended(Rel#Range(a), v));  
  
  
// Set with one element removed
function Rel#Removed<U, V>(Rel U V, U, V): Rel U V;
axiom (forall<U, V> a: Rel U V, u: U, v: V, x: U, y: V :: { Rel#Removed(a, u, v)[x, y] }
  Rel#Removed(a, u, v)[x, y] <==> (u != x || v != y) && a[x, y]);
axiom (forall<U, V> a: Rel U V, u: U, v: V  :: { Rel#Removed(a, u, v) }
  !Rel#Removed(a, u, v)[u, v]);
// axiom (forall<U, V> a: Rel U V, u: U, v: V, x: U, y: V :: { Rel#Removed(a, u, v), a[x, y] }
  // Rel#Removed(a, u, v)[x, y] ==> a[x, y]);
axiom (forall<U, V> a: Rel U V, u: U, v: V  :: { Rel#Card(Rel#Removed(a, u, v)) }
  a[u, v] ==> Rel#Card(Rel#Removed(a, u, v)) == Rel#Card(a) - 1);  
axiom (forall<U, V> a: Rel U V, u: U, v: V  :: { Rel#Card(Rel#Removed(a, u, v)) }
  !a[u, v] ==> Rel#Card(Rel#Removed(a, u, v)) == Rel#Card(a));
  
// Restriction on a subdomain
function Rel#Restricted<U, V>(Rel U V, Set U): Rel U V;  
axiom (forall<U, V> a: Rel U V, s: Set U, x: U, y: V :: { Rel#Restricted(a, s)[x, y] }
  Rel#Restricted(a, s)[x, y] <==> a[x, y] && s[x]);
axiom (forall<U, V> a: Rel U V, s: Set U :: { Rel#Domain(Rel#Restricted(a, s)) }
  Rel#Domain(Rel#Restricted(a, s)) == Set#Intersection(Rel#Domain(a), s));

// Inverse  
function Rel#Inverse<U, V>(Rel U V): Rel V U;
axiom (forall<U, V> a: Rel U V, x: U, y: V :: { Rel#Inverse(a)[y, x] }
  Rel#Inverse(a)[y, x] <==> a[x, y]);
axiom (forall<U, V> a: Rel U V :: { Rel#Card(Rel#Inverse(a)) }
  Rel#Card(Rel#Inverse(a)) == Rel#Card(a));  
axiom (forall<U, V> a: Rel U V :: { Rel#Domain(Rel#Inverse(a)) }
  Rel#Domain(Rel#Inverse(a)) == Rel#Range(a));  
axiom (forall<U, V> a: Rel U V :: { Rel#Range(Rel#Inverse(a)) }
  Rel#Range(Rel#Inverse(a)) == Rel#Domain(a));  
  
// Union of two relations
function Rel#Union<U, V>(Rel U V, Rel U V): Rel U V;
axiom (forall<U, V> a: Rel U V, b: Rel U V, u: U, v: V :: { Rel#Union(a, b)[u, v] }
  Rel#Union(a, b)[u, v] <==> a[u, v] || b[u, v]);
axiom (forall<U, V> a, b: Rel U V, u: U, v: V :: { Rel#Union(a, b), a[u, v] }
  a[u, v] ==> Rel#Union(a, b)[u, v]);
axiom (forall<U, V> a, b: Rel U V, u: U, v: V :: { Rel#Union(a, b), b[u, v] }
  b[u, v] ==> Rel#Union(a, b)[u, v]);
// axiom (forall<U, V> a, b: Rel U V :: { Rel#Union(a, b) }
  // Rel#Disjoint(a, b) ==>
    // Rel#Difference(Rel#Union(a, b), a) == b &&
    // Rel#Difference(Rel#Union(a, b), b) == a);

// Intersection of two sets    
function Rel#Intersection<U, V>(Rel U V, Rel U V): Rel U V;
axiom (forall<U, V> a: Rel U V, b: Rel U V, u: U, v: V :: { Rel#Intersection(a, b)[u, v] }
  Rel#Intersection(a,b)[u, v] <==> a[u, v] && b[u, v]);
  
axiom (forall<U, V> a, b: Rel U V :: { Rel#Union(Rel#Union(a, b), b) }
  Rel#Union(Rel#Union(a, b), b) == Rel#Union(a, b));
axiom (forall<U, V> a, b: Rel U V :: { Rel#Union(a, Rel#Union(a, b)) }
  Rel#Union(a, Rel#Union(a, b)) == Rel#Union(a, b));
axiom (forall<U, V> a, b: Rel U V :: { Rel#Intersection(Rel#Intersection(a, b), b) }
  Rel#Intersection(Rel#Intersection(a, b), b) == Rel#Intersection(a, b));
axiom (forall<U, V> a, b: Rel U V :: { Rel#Intersection(a, Rel#Intersection(a, b)) }
  Rel#Intersection(a, Rel#Intersection(a, b)) == Rel#Intersection(a, b));
axiom (forall<U, V> a, b: Rel U V :: { Rel#Card(Rel#Union(a, b)) }{ Rel#Card(Rel#Intersection(a, b)) }
  Rel#Card(Rel#Union(a, b)) + Rel#Card(Rel#Intersection(a, b)) == Rel#Card(a) + Rel#Card(b));

// Relation a with all elements from b removed
function Rel#Difference<U, V>(Rel U V, Rel U V): Rel U V;
axiom (forall<U, V> a: Rel U V, b: Rel U V, u: U, v: V :: { Rel#Difference(a, b)[u, v] }
  Rel#Difference(a, b)[u, v] <==> a[u, v] && !b[u, v]);
axiom (forall<U, V> a, b: Rel U V, u: U, v: V :: { Rel#Difference(a, b), b[u, v] }
  b[u, v] ==> !Rel#Difference(a, b)[u, v]);
axiom (forall<U, V> a, b: Rel U V ::
  { Rel#Card(Rel#Difference(a, b)) }
  Rel#Card(Rel#Difference(a, b)) + Rel#Card(Rel#Difference(b, a)) 
  + Rel#Card(Rel#Intersection(a, b))
    == Rel#Card(Rel#Union(a, b)) &&
  Rel#Card(Rel#Difference(a, b)) == Rel#Card(a) - Rel#Card(Rel#Intersection(a, b)));
axiom (forall<U, V> a: Rel U V :: { Rel#Difference(a,Rel#Empty()) }
  Rel#Equal(Rel#Difference(a,Rel#Empty()), a));

// Symmetric difference of two relations  
function Rel#SymDifference<U, V>(a: Rel U V, b: Rel U V): Rel U V
{ Rel#Union(Rel#Difference(a, b), Rel#Difference(b, a)) }

// Type properties

function {: inline } Rel#DomainType<T>(heap: HeapType, r: Rel ref T, t: Type): bool 
{ (forall o: ref :: { Rel#Domain(r)[o] } Rel#Domain(r)[o] ==> detachable(heap, o, t)) }  

function {: inline } Rel#RangeType<T>(heap: HeapType, r: Rel T ref, t: Type): bool 
{ (forall o: ref :: { Rel#Range(r)[o] } Rel#Range(r)[o] ==> detachable(heap, o, t)) }  
