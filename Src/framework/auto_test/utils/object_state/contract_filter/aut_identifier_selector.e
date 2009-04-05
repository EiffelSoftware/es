note
	description: "Summary description for {AUT_IDENTIFIER_SELECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_IDENTIFIER_SELECTOR

inherit
	AUT_CONTRACT_FILTER

	AST_ITERATOR
			redefine
				process_access_feat_as
			end

	AUT_OBJECT_STATE_REQUEST_UTILITY

feature -- Status report

	is_assertion_satisfied (a_assertion: AUT_ASSERTION; a_context_class: CLASS_C): BOOLEAN is
			-- Is `a_assertion' valid from `a_context_class'?
			-- An assertion is valid if is suitable to generate proof obligation from it.
		do
			assertion := a_assertion
			current_written_class := a_assertion.written_class
			context_class := a_context_class
			a_assertion.tag.process (Current)
		end

feature -- Access

	on_found_agent: PROCEDURE [ANY, TUPLE [a_assertion: AUT_ASSERTION; a_id: STRING]]
			-- Action to be performed when `a_id' is found in `a_assertion'

feature -- Setting

	set_on_found_agent (a_agent: like on_found_agent) is
			-- Set `on_found_agent' with `a_agent'.
		do
			on_found_agent := a_agent
		ensure
			on_found_agent_set: on_found_agent = a_agent
		end

feature{NONE} -- Process

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_feature: FEATURE_I
		do
			l_feature := final_feature (l_as.access_name.as_lower, current_written_class, context_class)
			if on_found_agent /= Void then
				on_found_agent.call ([assertion, l_feature.feature_name.as_lower])
			end
			safe_process (l_as.internal_parameters)
		end

feature{NONE} -- Implementation

	assertion: AUT_ASSERTION
			-- Currently analyzed assertion

	context_class: CLASS_C
			-- Class where currently analyzed assertion is viewed

	current_written_class: CLASS_C;
			-- Class where currently analyzed assertion is written

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
