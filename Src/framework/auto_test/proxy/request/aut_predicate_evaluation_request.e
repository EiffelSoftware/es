note
	description: "AutoTest request to evaluate predicates on given objects"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_EVALUATION_REQUEST

inherit
	AUT_REQUEST
		rename
			make as old_make
		end

create
	make

feature{NONE} -- Initialization

	make (a_system: like system; a_predicates: like predicates) is
			-- Initialize.
		require
			a_system_attached: a_system /= Void
			a_predicates_attached: a_predicates /= Void
			a_predicates_valid: not a_predicates.has (Void)
		do
			old_make (a_system)
			predicates := a_predicates
		end

feature -- Access

	predicates: LINKED_LIST [TUPLE [predicate: INTEGER; arguments: SPECIAL [INTEGER]]]
			-- Predicates that are to be evaluated
			-- `predicate' is ID of the preidcate to be evaluated.
			-- `arguments' stores the indexes of objects that are used to evaluate `predicate'.
			-- Note: `arguments' stores all objects that are to be used as arguments for `preciate',
			-- this means that `preciate' can be evaluated multiple times depending on how many objects
			-- are in `arguments'.

feature -- Processing

	process (a_processor: AUT_REQUEST_PROCESSOR)
			-- Process current request.
		do
			a_processor.process_predicate_evaluation_request (Current)
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
