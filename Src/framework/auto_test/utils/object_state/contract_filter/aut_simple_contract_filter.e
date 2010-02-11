note
	description: "Summary description for {AUT_TAUTOLOGY_CONTRACT_FILTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_SIMPLE_CONTRACT_FILTER

inherit
	AUT_CONTRACT_FILTER

	AUT_OBJECT_STATE_REQUEST_UTILITY

	AST_ITERATOR
		redefine
			process_bin_ne_as,
			process_access_feat_as,
			process_current_as,
			process_binary_as,
			process_integer_as,
			process_void_as
		end

feature -- Status report

	is_assertion_satisfied (a_assertion: AUT_ASSERTION; a_context_class: CLASS_C): BOOLEAN is
			-- Is `a_assertion' valid in `a_context_class'?
			-- An assertion is valid if is suitable to generate proof obligation from it.
		do
			written_class := a_assertion.written_class
			context_class := a_context_class
			initialize
			a_assertion.tag.process (Current)
			Result := is_last_contract_satisfied
			if Result and then on_simple_assertion_found_agent /= Void then
				on_simple_assertion_found_agent.call ([a_assertion, query_name, is_negation])
			end
		end

feature -- Access

	query_name: STRING
			-- Name of the boolean query mentioned in the last analyzed contract

	is_negation: BOOLEAN
			-- Is last analyzed contract in the form of "not ..."?

	is_last_contract_satisfied: BOOLEAN
			-- Is last analyzed contract satisfied?

	on_simple_assertion_found_agent: PROCEDURE [ANY, TUPLE [a_assertion: AUT_ASSERTION; a_query_name: STRING; a_negation: BOOLEAN]]
			-- Agent to be performed if an assertion satisfying the criterion defined in Current is found.
			-- `a_query_name' is the name of the query mentioned in the assertion,
			-- `a_negation' is true indicates that the assertion is in the form of "not query_name", otherwise,
			-- the assertion is in the form of `query_name'

feature -- Setting

	set_on_simple_assertion_found_agent (a_agent: like on_simple_assertion_found_agent) is
			-- Set `on_simple_assertion_found_agent' with `a_agent'.
		do
			on_simple_assertion_found_agent := a_agent
		ensure
			on_simple_assertion_found_agent_set: on_simple_assertion_found_agent = a_agent
		end

feature{NONE} -- Implementation

	written_class: CLASS_C
			-- Class with current analyzed contract is written

	context_class: CLASS_C
			-- Context context from which current analyzed contract is viewed.

	id_count: INTEGER
			-- Number of id access analyzed so far

	not_count: INTEGER;
			-- Number of negations analyzed so far

	initialize is
			-- Initialize before analysis.
		do
			id_count := 0
			not_count := 0
			is_negation := False
			is_last_contract_satisfied := True
		end

feature{NONE} -- Process

	process_bin_ne_as (l_as: BIN_NE_AS)
		do
			not_count := not_count + 1
			if not_count < 2 then
				is_negation := True
				process_binary_as (l_as)
			else
				is_last_contract_satisfied := False
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_feature: FEATURE_I
		do
			if is_last_contract_satisfied then
				id_count := id_count + 1
				if id_count < 2 then
					l_feature := final_feature (l_as.access_name.as_lower, written_class, context_class)
					if
						l_feature /= Void and then
						l_feature.argument_count = 0 and then
						l_feature.type.is_boolean
					then
						query_name := l_feature.feature_name.as_lower
						safe_process (l_as.internal_parameters)
					else
						is_last_contract_satisfied := False
					end
				else
					is_last_contract_satisfied := False
				end
			end
		end

	process_current_as (l_as: CURRENT_AS)
		do
			is_last_contract_satisfied := False
		end

	process_binary_as (l_as: BINARY_AS)
		do
			is_last_contract_satisfied := False
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			is_last_contract_satisfied := False
		end

	process_void_as (l_as: VOID_AS)
		do
			is_last_contract_satisfied := False
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
