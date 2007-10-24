indexing
	description: "Mathematical objects that contain elements of the same type in unspecified order"
	version: "$Id$"
	author: "Bernd Schoeller and Tobias Widmer"
	copyright: "see License.txt"

deferred class
	MML_BAG[G]

inherit
	MML_RELATION[G, INTEGER]
		rename
			any_item as set_any_item,
			item_where as set_item_where,
			randomly_ordered as set_randomly_ordered,
			difference as set_difference,
			extended as set_extended,
			intersected as set_intersected,
			pruned as set_pruned,
			subtracted as set_subtracted,
			united as set_united,
			is_disjoint_from as set_is_disjoint,
			contains as set_is_member,
			for_all as set_for_all,
			there_exists as set_there_exists,
			count as set_cardinality
		redefine
			set_intersected,
			set_pruned,
			set_subtracted,
			domain_anti_restricted,
			domain_anti_restricted_by,
			domain_restricted_by,
			domain_restricted,
			range_anti_restricted,
			range_anti_restricted_by,
			range_restricted_by,
			range_restricted
		end

feature -- Access

	any_item: G is
			-- An arbitrary element of the bag `current'.
		require
			not_empty: not is_empty
		deferred
		ensure
			is_contained: contains (Result)
		end

	item_where (predicate: FUNCTION[ANY,TUPLE[G],BOOLEAN]): G is
			-- Any arbitrary element of the bag `current' that satisfies `predicate'.
		require
			predicate_not_void: predicate /= Void
			there_exists_item: there_exists (predicate)
		deferred
		ensure
			definition_of_any_item: contains(Result) and predicate.item([Result])
		end

	occurrences (v: G): INTEGER is
			-- The number of times that `v' occures in the bag.
		deferred
		ensure
			is_member_then_item: contains(v) implies Result = item(v)
			is_not_member_then_zero: not contains(v) implies Result = 0
		end

feature -- Conversion

	randomly_ordered : MML_SEQUENCE[G] is
			-- The bag `current' as random sequence.
		deferred
		ensure
			definition_of_random_sequence : equal_value(domain,Result.range)
			same_cardinality : Result.count = count
		end

feature -- Measurement

	count : INTEGER is
			-- The cardinality of `current'
		deferred
		ensure
			non_negative_cardinality : Result >= 0
		end

feature -- Properties

	is_superbag_of (other: MML_BAG[G]) : BOOLEAN is
			-- Is `other' a subbag of `current'?
		require
			other_not_void : other /= Void
		deferred
		end

	is_subbag_of (other: MML_BAG[G]) : BOOLEAN is
			-- Is `other' a superbag of `current'?
		require
			other_not_void : other /= Void
		deferred
		end

	is_proper_subbag_of (other: MML_BAG[G]) : BOOLEAN is
			-- Is `other' a proper superbag of `current'?
		require
			other_not_void : other /= Void
		deferred
		end

	is_proper_superbag_of (other: MML_BAG[G]) : BOOLEAN is
			-- Is `other' a proper subbag of `current'?
		require
			other_not_void : other /= Void
		deferred
		end

	contains (v: G) : BOOLEAN is
			-- Is `v' contained at least once in the bag ?
		deferred
		ensure
			definition_of_is_member: Result = domain.contains(v)
		end

	is_disjoint_from (other: MML_BAG[G]) : BOOLEAN is
			-- Is the current bag disjoint from the bag `other' ?
		deferred
		ensure
			definition_of_is_disjoint: Result = domain.is_disjoint_from(other.domain)
		end

feature -- Quantifiers

	for_all (predicate: FUNCTION [ANY,TUPLE[G],BOOLEAN]): BOOLEAN is
			-- Do all members of the bag satisfy `predicate' ?
		require
			predicate_not_void: predicate /= Void
		deferred
		ensure
			definition_of_for_all: Result = domain.for_all(predicate)
		end

	there_exists (predicate: FUNCTION [ANY,TUPLE[G],BOOLEAN]): BOOLEAN is
			-- Does there exist an element in the bag that satisfies `predicate' ?
		require
			predicate_not_void: predicate /= Void
		deferred
		ensure
			definition_of_for_all: Result = domain.there_exists(predicate)
		end

feature -- Basic Operations

	set_intersected (other: MML_SET[MML_PAIR[G, INTEGER]]) : MML_BAG[G] is
			-- The intersection of `current' and `other'.
		deferred
		end

	set_subtracted (other: MML_SET [MML_PAIR [G,INTEGER]]): MML_BAG [G] is
			-- The difference of `current' and `other'.
		deferred
		end

	set_pruned (v: MML_PAIR[G,INTEGER]): MML_BAG [G] is
			-- The relation `current' with the pair `v' removed.
		deferred
		end

	intersected (other: MML_BAG [G]): MML_BAG [G] is
			-- The intersection of the bags `current' and `other'.
		require
			other_not_void: other /= Void
		deferred
		end

	united (other: MML_BAG [G]): MML_BAG [G] is
			-- The union of the bags `current' and `other'.
		require
			other_not_void: other /= Void
		deferred
		ensure
			cardinality_added: Result.count = count + other.count
		end

	subtracted (other: MML_BAG [G]): MML_BAG [G] is
			-- The difference of the bags `current' and `other'.
		require
			other_not_void: other /= Void
		deferred
		ensure
			valid_cardinality: Result.count <= count
		end

	difference (other: MML_BAG [G]): MML_BAG [G] is
			-- The symmetric difference of the bags `current' and `other'.
		require
			other_not_void: other /= Void
		deferred
		end

	extended (v: G): MML_BAG [G] is
			-- The bag `current' extended with `v'.
		deferred
		ensure
			definition_of_extended: Result.occurrences (v) = occurrences(v) +1
			cardinality_increased: Result.count = count + 1
		end

	extended_n (v: G; n:INTEGER): MML_BAG [G] is
			-- The bag `current' extended with `n' occurrences of `v'.
		require
			n_positive: n >= 0
		deferred
		ensure
			definition_of_extended: Result.occurrences (v) = occurrences(v) + n
			cardinality_increased: Result.count = count + n
		end

	pruned (v: G): MML_BAG [G] is
			-- The bag `current' with one instance of `v' removed.
		deferred
		ensure
			definition_of_pruned: contains(v) implies equal_value (Current, Result.extended (v))
			cardinality_decreased: contains(v) implies Result.count = count - 1
		end

feature -- Projections

	domain_restricted_by (v: G): MML_BAG[G] is
			-- A relation with pairs of `current' having its first element equivalent to `v'.
		deferred
		end

	domain_restricted (restriction: MML_SET[G]): MML_BAG [G] is
			-- A relation with pairs of `current' having its first element in `restriction'.
		deferred
		end

	range_restricted_by (v: INTEGER) : MML_BAG [G] is
			-- A relation with pairs of `current' having its second element equivalent to `v'.
		deferred
		end

	range_restricted (restriction : MML_SET[INTEGER]) : MML_BAG [G] is
			-- A relation with pairs of `current' having its second element in `restriction'.
		deferred
		end

	domain_anti_restricted_by (v: G): MML_BAG [G]  is
			-- A relation with pairs of `current' having its first element not equivalent to `v'.
		deferred
		end

	domain_anti_restricted (restriction : MML_SET[G]) : MML_BAG [G] is
			-- A relation with pairs of `current' having its first element not in `restriction'.
		deferred
		end

	range_anti_restricted_by (v: INTEGER) :MML_BAG [G] is
			-- A relation with pairs of `current' having its second element not equivalent `v'.
		deferred
		end

	range_anti_restricted (restriction : MML_SET[INTEGER]) :MML_BAG [G]  is
			-- A relation with pairs of `current' having its second element not in `restriction'.
		deferred
		end

feature -- Predicates for Invariant

	is_greater_than_zero (x: INTEGER): BOOLEAN is
			-- Is `x' greater than 0 ?
		do
			Result := x > 0
		ensure
			definition_of_greater_than_zero: Result = (x > 0)
		end

invariant
	is_always_function: is_function
	-- range_is_positive: range.for_all (agent is_greater_than_zero(?))
end -- class MML_BAG
