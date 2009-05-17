note
	description: "Summary description for {AUT_PRECONDITION_EVALUATION_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PRECONDITION_EVALUATION_REQUEST

inherit
	AUT_REQUEST
		rename
			make as old_make
		end

create
	make

feature{NONE} -- Initialization

	make (a_system: like system; a_feature: like feature_; a_variables: DS_LIST [ITP_VARIABLE]) is
			-- Initialize Current.
		do
			old_make (a_system)
			variables := a_variables
			feature_ := a_feature
		end

feature -- Access

	feature_: AUT_FEATURE_OF_TYPE
			-- Feature whose precondition is to be evaluated

	variables: DS_LIST [ITP_VARIABLE]
			-- Variables used for precondition evaluation
			-- The first item in the list is the target object for the
			-- call to `feature_', the rest items are (possibly) arguments.

feature -- Processing

	process (a_processor: AUT_REQUEST_PROCESSOR)
			-- Process current request.
		do
			a_processor.process_precodition_evaluation_request (Current)
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
