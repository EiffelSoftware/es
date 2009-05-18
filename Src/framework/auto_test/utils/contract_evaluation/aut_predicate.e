note
	description: "Summary description for {AUT_PREDICATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_PREDICATE

inherit
	ANY
		redefine
			is_equal
		end

	HASHABLE
		undefine
			is_equal
		end

feature -- Access

	context_class: CLASS_C
			-- Class where current predicate comes

	types: DS_LINKED_LIST [TYPE_A]
			-- Type of all arguments of Current predicate
			-- The order of the types are important

	narity: INTEGER
			-- Number of arguments of Current predicate
		do
			Result := types.count
		ensure
			good_result: Result = types.count
		end

	text: STRING is
			-- Text of Current predicate
			-- The arguments in of the predicates are replaced by "$1$", "$2$"
			-- in the text. For example: "$1$.valid_cursor ($2$)"
		deferred
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := text.hash_code
		ensure then
			good_result: Result = text.hash_code
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
			Result := same_type (other) and then (context_class = other.context_class)
			if Result then
					-- Check type equivalence of corresponding arguments.
				Result := types.count = other.types.count
				if Result then
					from
						types.start
						other.types.start
					until
						types.after or else not Result
					loop
						Result := types.item_for_iteration.is_equivalent (other.types.item_for_iteration)
						types.forth
						other.types.forth
					end

						-- Check text equivalence.
					if Result then
						Result := text ~ other.text
					end
				end
			end
		end

feature -- Status report

	is_linear_solvable: BOOLEAN is
			-- Is current predicate linearly solvable?
		deferred
		end

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
