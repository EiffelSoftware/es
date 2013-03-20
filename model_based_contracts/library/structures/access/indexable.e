indexing

	description:
		"Tables whose keys are integers in a contiguous interval"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: indexable, access;
	access: index, membership;
	contents: generic;
	model: relation, extendible, prunable, object_comparison;
	date: "$Date$"
	revision: "$Revision$"

deferred class INDEXABLE [G] inherit

	TABLE [G, INTEGER]
		rename
			valid_key as valid_index,
			force as put
		redefine
			valid_index,
			bag,
			linear_representation
		end

feature -- Measurement

	index_set: INTEGER_INTERVAL is
			-- Range of acceptable indexes
		deferred
		ensure
			not_void: Result /= Void
		-- ensure: model
			definition_set: Result.set |=| relation.domain
		end

feature -- Status report

	valid_index (i: INTEGER): BOOLEAN is
			-- Is `i' a valid index?
		deferred
		ensure then
			only_if_in_index_set:
				Result implies
					((i >= index_set.lower) and
					(i <= index_set.upper))
		end

feature -- Conversion

	linear_representation: LINEAR [G] is
			-- Representation as a linear structure
		deferred
		ensure then
		-- ensure: model
			sequence_corresponds_to_relation: Result.sequence |=| relation.as_sequence
		end

feature -- Model
	relation: MML_RELATION [INTEGER, G] is
			-- Mathematical relation, representing content of the container
		local
			i: INTEGER
		do
			create {MML_DEFAULT_RELATION [INTEGER, G]} Result
			from
				i := index_set.lower
			until
				i > index_set.upper
			loop
				Result := Result.extended (create {MML_DEFAULT_PAIR [INTEGER, G]}.make_from(i, item (i)))
				i := i + 1
			end
		end

	bag: MML_BAG [G] is
			-- Mathematical bag, representing content of the container
		local
			i: INTEGER
		do
			create {MML_DEFAULT_BAG [G]} Result
			from
				i := index_set.lower
			until
				i > index_set.upper
			loop
				Result := Result.extended (item (i))
				i := i + 1
			end
		end

invariant

	index_set_not_void: index_set /= Void

-- invariant: model
	domain_is_interval: relation.domain.is_range

indexing
	library:	"EiffelBase: Library of reusable components for Eiffel."
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end



