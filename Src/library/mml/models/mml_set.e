indexing
	description: "Mathematical objects that contain unique elements of the same type in unspecified order"
	version: "$Id$"
	author: "Tobias Widmer and Bernd Schoeller"
	copyright: "see License.txt"

deferred class
	MML_SET[G]

inherit
	MML_ANY

feature -- Access

	any_item : G is
			-- An arbitrary element of `current'.
		require
			not_empty : not is_empty
		deferred
		ensure
			definition_of_any_element : contains (Result)
		end

	item_where (predicate: FUNCTION [ANY, TUPLE [G], BOOLEAN]) : G is
			-- An arbitrary element of `current' which satisfies `predicate'?
		require
			predicate_not_void : predicate /= Void
			there_exists_item : there_exists (predicate)
		deferred
		ensure
			definition_of_any_item : contains (Result) and predicate.item ([Result])
		end

feature -- Conversion

	identity : MML_RELATION[G, G] is
			-- The identity relation of `current'.
		deferred
		ensure
			-- definition_of_identity_relation : Result.for_all (agent {MML_PAIR[G, G]}.is_identity)
			same_domain_range : equal_value(Current,Result.domain) and equal_value(Current,Result.range)
		end

	lifted : MML_POWERSET[G] is
			-- The set `current' as power set.
		deferred
		ensure
			definition_of_powerset : Result.contains (Current)
			valid_cardinality : Result.count.is_equal (1)
		end

	randomly_ordered : MML_SEQUENCE[G] is
			-- The set `current' as random sequence.
		deferred
		ensure
			-- definition_of_random_sequence : Result.for_all (agent is_member (?)) and equal_value(Current,Result.range)
			same_cardinality : Result.count = count
		end

feature -- Status Report

	count : INTEGER is
			-- The cardinality of `current'
		deferred
		ensure
			non_negative_cardinality : Result >= 0
		end

feature -- Properties

	contains (v: G) : BOOLEAN is
			-- Is `v' a member of `current'?
		deferred
		ensure
			empty_implies_not_member : is_empty implies not Result
		end

	is_empty : BOOLEAN is
			-- Is `current' empty?
		deferred
		ensure
			definition_of_empty : Result = (count = 0)
		end

	is_disjoint_from (other: MML_SET[G]) : BOOLEAN is
			-- Is `other' disjoint from `current'?
		require
			other_not_void: other /= Void
		deferred
		ensure
			definition_of_disjoint: Result = intersected (other).is_empty
			empty_implies_disjoint: (is_empty or other.is_empty) implies Result
		end

	is_superset_of (other: MML_SET[G]) : BOOLEAN is
			-- Is `other' a subset of `current'?
		require
			other_not_void : other /= Void
		deferred
		ensure
			-- definition_of_subset : Result = other.for_all (agent contains (?))
			valid_cardinality : Result implies (count >= other.count)
		end

	is_subset_of (other: MML_SET[G]) : BOOLEAN is
			-- Is `other' a superset of `current'?
		require
			other_not_void : other /= Void
		deferred
		ensure
			-- definition_of_superset : Result = other.is_superset_of (Current)
			valid_cardinality : Result implies (other.count >= count)
		end

	is_proper_subset_of (other: MML_SET[G]) : BOOLEAN is
			-- Is `other' a proper superset of `current'?
		require
			other_not_void : other /= Void
		deferred
		ensure
			-- definition_of_proper_superset : Result = (is_subset_of (other) and not equal_value (Current,other))
			-- all_elements_included : Result implies for_all (agent other.contains(?))
			-- there_exists_element : Result implies other.there_exists (agent negated (?, agent contains (?)))
			valid_cardinality : Result implies (other.count > count)
		end

	is_proper_superset_of (other: MML_SET[G]) : BOOLEAN is
			-- Is `other' a proper subset of `current'?
		require
			other_not_void : other /= Void
		deferred
		ensure
			-- definition_of_proper_subset : Result = (is_superset_of (other) and not equal_value (Current,other))
			-- all_elements_included : Result implies other.for_all (agent contains(?))
			-- there_exists_element : Result implies there_exists (agent negated (?, agent other.contains(?)))
			valid_cardinality : Result implies (other.count < count)
		end

feature -- Basic Operations

	cartesian_product (other : MML_SET[ANY]) : MML_SET[MML_PAIR[G, ANY]] is
			-- The cartesian product of `other' and `current'.
			-- TypeCheat
		require
			other_not_void : other /= Void
		deferred
		ensure
			definition_of_cartesian_product : Result.count = (count * other.count)
		end

	intersected (other: MML_SET[G]) : MML_SET[G] is
			-- The intersection of `current' and `other'.
		require
			other_not_void : other /= Void
		deferred
		ensure
			-- definition_of_intersected : Result.for_all (agent anded (?, agent contains (?), agent other.contains (?)))
			existing_subset : is_superset_of (Result)
			other_subset : other.is_superset_of (Result)
			valid_cardinality : Result.count <= count and Result.count <= other.count
		end

	united (other: MML_SET[G]) : MML_SET[G] is
			-- The union of `current' and `other'.
		require
			other_not_void : other /= Void
		deferred
		ensure
			existing_elements : is_subset_of (Result)
			other_elements : other.is_subset_of (Result)
			valid_cardinality : Result.count >= count and Result.count >= other.count
		end

	subtracted (other: MML_SET[G]) : MML_SET[G] is
			-- The difference of `current' and `other'.
		require
			other_not_void : other /= Void
		deferred
		ensure
			disjoint_subtracted_result : Result.intersected (other).is_empty
			valid_cardinality : Result.count <= count
		end

	difference (other: MML_SET[G]) : MML_SET[G] is
			-- The symmetric difference of `current' and `other'.
		require
			other_not_void : other /= Void
		deferred
		ensure
			definition_of_difference : equal_value(Result,(united (other).subtracted (intersected (other))))
		end

	extended (v: G) : MML_SET[G] is
			-- The set `current' extended with `v'.
		deferred
		ensure
			definition_of_extended : Result.contains (v)
			-- other_members_remain : for_all (agent Result.is_member (?))
			has_implies_same : contains (v) implies equal_value (Current,Result)
			cardinality_increased: not contains (v) implies Result.count = count + 1
		end

	pruned (v: G) : MML_SET[G] is
			-- The set `current' with `v' removed.
		deferred
		ensure
			definition_of_pruned : not contains (v) implies equal_value (Current,Result.extended (v))
			no_member_anymore : not Result.contains (v)
			not_has_implies_same : not contains (v) implies equal_value (Current,Result)
			cardinality_decreased: contains (v) implies Result.count = count - 1
		end

feature -- Quantifiers

	there_exists (predicate: FUNCTION [ANY, TUPLE[G], BOOLEAN]): BOOLEAN is
			-- Does there exist an element in the set that satisfies `predicate' ?
		require
			predicate_not_void: predicate /= Void
		deferred
		ensure
			-- there_exists_for_all_relation: Result = (not for_all (agent negated (?,predicate)))
		end

	for_all (predicate: FUNCTION [ANY, TUPLE[G], BOOLEAN]): BOOLEAN is
			-- Do all members of the set satisfy `predicate' ?
		require
			predicate_not_void: predicate /= Void
		deferred
		ensure
			--	there_exists_for_all_relation: Result = (not there_exists (agent negated (?,predicate)))
		end

feature -- Partition

	is_partitioned_by (other : MML_SET[MML_SET[G]]) : BOOLEAN is
			-- Is `other' a partition of `current'?
		require
			other_not_void : other /= Void
		deferred
		ensure
			-- all_supplied_sets_are_subsets : Result implies other.for_all (agent is_subset (?))
		end

feature{MML_ANY,
		MML_CONVERSION,
		MML_CONVERSION_2,
		MML_COMPOSITION} -- Direct Access

	as_array: ARRAY [G] is
			-- All elements of the set as an array.
			-- The array must not be changed.
			-- Used for internal operations.
		deferred
		end

invariant
	definition_of_empty_set : is_empty = (count = 0)

	reflexive_subset_relation : is_superset_of (Current)
	reflexive_superset_relation: is_subset_of (Current)

	definition_of_union : equal_value (Current, united (Current))
	definition_of_intersection : equal_value (Current,intersected (Current))

	non_negative_cardinality : count >= 0

end -- class MML_SET
