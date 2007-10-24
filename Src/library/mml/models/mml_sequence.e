indexing
	description: "[Mathematical objects containing elements in a specified order]"
	version: "$Id$"
	author: "Tobias Widmer and Bernd Schoeller"
	copyright: "see License.txt"

deferred class
	MML_SEQUENCE[G]

inherit
	MML_RELATION[INTEGER,G]
		rename
			any_item as set_any_item,
			item_where as set_item_where,
			extended as set_extended,
			extended_by_pair as set_extended_by_pair,
			pruned as set_pruned,
			subtracted as set_subtracted,
			contains as set_contains,
			for_all as set_for_all,
			there_exists as set_there_exists,
			as_array as set_as_array
		end

feature -- Access

	any_element : G is
			-- An arbitrary element of `current'.
		require
			not_empty : not is_empty
		deferred
		ensure
			definition_of_any_element : is_member (Result)
		end

	any_item (predicate: FUNCTION [ANY, TUPLE [G], BOOLEAN]) : G is
			-- An arbitrary element of `current' which satisfies `predicate'?
		require
			predicate_not_void : predicate /= Void
			there_exists_item : there_exists (predicate)
		deferred
		ensure
			definition_of_any_item : is_member (Result) and predicate.item ([Result])
		end

feature -- Properties

	is_member (v: G) : BOOLEAN is
			-- Is `other' a member of `current'?
		deferred
		ensure
			definition_of_member : Result = range.contains(v)
			empty_implies_not_member: is_empty implies not Result
		end

	is_defined (index : INTEGER) : BOOLEAN is
			-- Is `index' defined in `current'?
		deferred
		ensure then
			definition_of_defined : Result = (index >= 1 and index <= count)
		end

	is_supersequence_of (other: MML_SEQUENCE[G]) : BOOLEAN is
			-- Is `other' a subsequence of `current'?
		require
			other_not_void : other /= Void
		deferred
		ensure
			-- subsequence_at_index: domain.there_exists (agent is_subsequence_at(other,?))
		end

	is_subsequence_of (other: MML_SEQUENCE[G]) : BOOLEAN is
			-- Is `other' a supersequence of `current'?
		require
			other_not_void : other /= Void
		deferred
		ensure
			definition_of_supersequence: other.is_supersequence_of(Current)
		end

	is_proper_subsequence_of (other: MML_SEQUENCE[G]) : BOOLEAN is
			-- Is `other' a proper supersequence of `current'?
		require
			other_not_void : other /= Void
		deferred
		ensure
			definition_of_supersequence: other.is_supersequence_of(Current)
			other_is_larger: other.count > count
		end

	is_proper_supersequence_of (other: MML_SEQUENCE[G]) : BOOLEAN is
			-- Is `other' a proper subsequence of `current'?
		require
			other_not_void : other /= Void
		deferred
		ensure
			is_subsequence: is_supersequence_of(other)
			other_is_larger: count > other.count
		end

	is_supersequence_of_at (other: MML_SEQUENCE[G];position:INTEGER) : BOOLEAN is
			-- Is `other' a subsequence of `current' at `position' ?
		require
			other_not_void : other /= Void
		deferred
		end

	is_subsequence_of_at (other: MML_SEQUENCE[G];position:INTEGER) : BOOLEAN is
			-- Is `other' a supersequence of `current' at `position' ?
		require
			other_not_void : other /= Void
		deferred
		ensure
			other_is_subsequence_at: other.is_supersequence_of_at(Current,position)
		end

	is_proper_supersequence_at (other: MML_SEQUENCE[G];position:INTEGER) : BOOLEAN is
			-- Is `other' a proper supersequence of `current' at `position' ?
		require
			other_not_void : other /= Void
		deferred
		ensure
			is_supersequence_at: is_subsequence_of_at(other,position)
			other_is_larger: other.count > count
		end

	is_proper_subsequence_at (other: MML_SEQUENCE[G];position:INTEGER) : BOOLEAN is
			-- Is `other' a proper subsequence of `current' at `position' ?
		require
			other_not_void : other /= Void
		deferred
		ensure
			is_subsequence_at: is_supersequence_of_at(other,position)
			other_is_smaller: count > other.count
		end

feature -- Basic Operations

	subtracted (other: MML_SET[G]) : MML_SEQUENCE[G] is
			-- The sequence `current' with all elements of `other' removed.
		require
			other_not_void : other /= Void
		deferred
		end

	extended_at (other: G; position : INTEGER) : MML_SEQUENCE[G] is
			-- The sequence `current' extended with `other' at `position'.
		require
			other_not_void : other /= Void
			defined_position : is_defined (position) or (position = count+1)
		deferred
		end

	pruned (v: G) : MML_SEQUENCE[G] is
			-- The sequence `current' with all occurrences of `v' removed.
		require
			other_not_void : v /= Void
		deferred
		end

	pruned_at (position : INTEGER) : MML_SEQUENCE[G] is
			-- The sequence `current' with the element at `position' pruned.
		require
			defined_position : is_defined (position)
		deferred
		end

	replaced_at (other: G; position: INTEGER): MML_SEQUENCE[G] is
			-- The sequence `current' with the element at `position' replaced by `other'.
		require
			other_not_void : other /= Void
			defined_position : is_defined (position)
		deferred
		end

feature -- Projections

	occurrences (v: G) : INTEGER is
			-- The occurrences of `v' in `current'
		deferred
		end

	index_of_i_th_occurrence_of (v: G; i: INTEGER) : INTEGER is
			-- Index of the `i'-th occurence of `v'
		require
			not_too_small: i >= 1
			has_i_th_occurence: i <= occurrences (v)
		deferred
		end

feature -- Reversal

	reversed : MML_SEQUENCE[G] is
			-- The sequence with all elements of `current', but in reversed order.
		deferred
		end

feature -- Decomposition

	first : G is
			-- The first element of `current'.
		require
			non_empty : not is_empty
		deferred
		ensure
			definition_of_first: equal_value(Result,item(1))
			result_is_member : is_member (Result)
		end

	last : G is
			-- The last element of `current'.
		require
			non_empty : not is_empty
		deferred
		ensure
			definition_of_last : equal_value(Result,item(count))
			result_is_member : is_member (Result)
		end

	tail : MML_SEQUENCE[G] is
			-- The elements of `current' except for the first one.
		deferred
		ensure
			is_subsequence: is_supersequence_of(Result)
		end

	front : MML_SEQUENCE[G] is
			-- The elements of `current' except for the last one.
		deferred
		ensure
			is_subsequence: is_supersequence_of(Result)
		end

	interval (lower : INTEGER; upper : INTEGER) : MML_SEQUENCE[G] is
			-- The interval from `lower' to `upper'.
		deferred
		ensure
			is_subsequence: is_supersequence_of(Result)
		end

feature -- Concatenation

	extended (other : G) : MML_SEQUENCE[G] is
			-- The sequence `current' with `other' appended.
		deferred
		ensure
			definition_of_appended : equal_value(Result.front,Current) and equal_value(Result.last,other)
			valid_count : Result.count = count + 1
		end

	prepended (other : G) : MML_SEQUENCE[G] is
			-- The sequence `current' prepended with `other'.
		deferred
		ensure
			definition_of_prepended : equal_value(Result.tail,Current) and equal_value(Result.first,other)
			valid_count : Result.count = count + 1
		end

	concatenated (other : MML_SEQUENCE[G]) : MML_SEQUENCE[G] is
			-- The concatenation of `current' and `other'.
		require
			other_not_void : other /= Void
		deferred
		ensure
			definition_of_concatenated : equal_value(Result.range,range.united (other.range))
			valid_count : Result.count = count + other.count
		end

feature -- Quantifiers

	there_exists (predicate: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN is
			-- Does there exist an element in the sequence that satisfies `predicate' ?
		require
			predicate_not_void: predicate /= Void
		deferred
		end

	for_all (predicate: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN is
			-- Do all members of the sequence satisfy `predicate' ?
		require
			predicate_not_void: predicate /= Void
		deferred
		end

feature {MML_ANY, MML_CONVERSION, MML_CONVERSION_2} -- Direct Access

	as_array: ARRAY [G] is
			-- All elements of the sequence as an array.
			-- The array must not be changed.
			-- Used for internal operations.
		deferred
		end

invariant
	sequence_is_always_function: is_function

end -- class MML_SEQUENCE
