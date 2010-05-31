note
	description: "Shared data structure for object state retrieval"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_SHARED_OBJECT_STATE_RETRIEVAL_CONTEXT

inherit
	AUT_PREDICATE_UTILITY
		undefine
			system
		end

feature -- Access

	feature_text_table: DS_HASH_TABLE [TUPLE [pre_state_text: STRING; post_state_text: STRING], AUT_FEATURE_OF_TYPE]
			-- Table of feature text used to retrieve states of operands of a feature
			-- Key is the feature, value is a tuple. `pre_state_text' is the feature text to execute before the test case execution.
			-- `post_state_text' is the feature text to execute after the test case execution.
		once
			create Result.make (256)
			Result.set_key_equality_tester (feature_of_type_equality_tester)
		end

;note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
