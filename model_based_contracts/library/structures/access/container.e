indexing

	description: "[
		Data structures of the most general kind,
		used to hold zero or more items.
		]"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: access;
	access: membership;
	contents: generic;
	model: bag, object_comparison;
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CONTAINER [G]

feature -- Access

	has (v: G): BOOLEAN is
			-- Does structure include `v'?
			-- (Reference or object equality,
			-- based on `object_comparison'.)
		deferred
		ensure
			not_found_in_empty: Result implies not is_empty
		-- ensure: model
--			definition_reference_comparison: not object_comparison implies Result = bag.contains (v) -- ToDo: If uncommented, the program doesn't run
			definition_object_comparison: object_comparison implies Result = bag.there_exists (agent equal_elements (v, ?))
		end

feature -- Status report

	is_empty: BOOLEAN is
			-- Is there no element?
		deferred
		ensure
		-- ensure: model
			definition: Result = bag.is_empty
		end

	empty: BOOLEAN is
			-- Is there no element?
		obsolete
			"ELKS 2000: Use `is_empty' instead"
		do
			Result := is_empty
		end

	object_comparison: BOOLEAN
			-- Must search operations use `equal' rather than `='
			-- for comparing references? (Default: no, use `='.)

	changeable_comparison_criterion: BOOLEAN is
			-- May `object_comparison' be changed?
			-- (Answer: yes by default.)
		do
			Result := True
		end

feature -- Status setting

	compare_objects is
			-- Ensure that future search operations will use `equal'
			-- rather than `=' for comparing references.
		require
			changeable_comparison_criterion: changeable_comparison_criterion
		do
			object_comparison := True
		ensure
			object_comparison: object_comparison
		end

	compare_references is
			-- Ensure that future search operations will use `='
			-- rather than `equal' for comparing references.
		require
			changeable_comparison_criterion: changeable_comparison_criterion
		do
			object_comparison := False
		ensure
			reference_comparison: not object_comparison
		end

feature -- Conversion

	linear_representation: LINEAR [G] is
			-- Representation as a linear structure
		deferred
		ensure
		-- ensure: model
			sequence_corresponds: Result.sequence.to_bag |=| bag
			object_comparion_corresponds: Result.object_comparison = object_comparison
		end

feature -- Model
	bag: MML_BAG [G]
			-- Bag representing container contents ToDo: should be deferred?
		local
			linear: LINEAR [G]
		do
			create {MML_DEFAULT_BAG [G]} Result
			linear := linear_representation.twin
			from
				linear.start
			until
				linear.off
			loop
				Result := Result.extended (linear.item)
				linear.forth
			end
		end

	equal_elements (e1, e2: G): BOOLEAN
			-- Work around
		do
			Result := equal (e1, e2)
		ensure
			Result = equal (e1, e2)
		end

	is_default (e: G): BOOLEAN
			-- Does `e' have a default value of its type?
		do
			Result := e = Void or else e = e.default
		end

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







end -- class CONTAINER



