note
	description: "Predicate used in predicate pool"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_PREDICATE

inherit
	HASHABLE
		undefine
			is_equal
		end

	REFACTORING_HELPER
		undefine
			is_equal
		end

feature{NONE} -- Initialization

	make (a_types: DS_LIST [TYPE_A]; a_text: STRING; a_context_class: like context_class; a_expression: like expression) is
			-- Initialize current.
		require
			a_context_class_valid: a_context_class.class_id = a_expression.context_class.class_id
		do
			create argument_types.make
			a_types.do_all (agent argument_types.force_last)

			text := a_text.twin
			context_class_internal := a_context_class
			expression := a_expression
		end

feature -- Access

	id: INTEGER
			-- 1-based Idendity of current predicate
			-- Used for fast identification
			-- Note: this id is not used in equality comparison

	expression: AUT_EXPRESSION
			-- Assertion associated with current predicates

	context_class: CLASS_C is
			-- Class where current predicate is viewed
		do
			fixme ("To be removed because `context_class' should be accessible through `expression.context_class'.");
			Result := context_class_internal
		ensure
			good_result: Result = context_class_internal
		end

	argument_types: DS_LINKED_LIST [TYPE_A]
			-- Type of all arguments of Current predicate
			-- Arguments are 1-based. The first argument of
			-- this predicate has index 1 and so on.

	narity: INTEGER
			-- Number of arguments of Current predicate
			-- Can be zero for constant predicate, for example,
			-- "{PLATFORM}.is_windows".
		do
			Result := argument_types.count
		ensure
			good_result: Result = argument_types.count
		end

	text: STRING
			-- Text of Current predicate
			-- The arguments in of the predicates are replaced by "{1}", "{2}"
			-- in the text. For example: "{1}.valid_cursor ({2})"
			-- All the feature name are final names (feature renaming is resolved).
			-- And all the calls are changed to qualified.
			-- "{1}" means the first argument of the predicate.

	hash_code: INTEGER
			-- Hash code value
		do
			Result := id
		ensure then
			good_result: Result = id
		end

feature -- Equality

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
				-- Two predicate are considered to be equal iff:
				-- 1. They come from the same class
				-- 2. They have the same number of arguments and each
				--    corresponding argument is of the same type
				-- 3. Text of these two predicates are equal.

				-- Check if both predicates come from the same class.
			if
				context_class.class_id = other.context_class.class_id and then
				argument_types.count = other.argument_types.count and then
				text ~ other.text
			then
					-- Check type equivalence of corresponding arguments.
				from
					Result := True
					argument_types.start
					other.argument_types.start
				until
					argument_types.after or else not Result
				loop
					Result :=
						argument_types.item_for_iteration.same_type (other.argument_types.item_for_iteration) and then
						argument_types.item_for_iteration.is_equivalent (other.argument_types.item_for_iteration)
					argument_types.forth
					other.argument_types.forth
				end
			end
		end

feature -- Status report

	is_linear_solvable: BOOLEAN is
			-- Is current predicate linearly solvable?
		deferred
		end

feature -- Setting

	set_id (a_id: like id)
			-- Set `id' with `a_id'.
		require
			a_id_positive: a_id > 0
		do
			id := a_id
		ensure
			id_set: id = a_id
		end

feature{NONE} -- Implementation

	context_class_internal: like context_class
			-- Storage for `context_class'

invariant
	id_positive: id > 0

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
