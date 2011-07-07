note
	description: "Decides if a snippet is valuable."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_DECIDER

inherit
	EXT_CHECKER

	REFACTORING_HELPER
		export {NONE} all end

create
	make

feature -- Initialization

	make
			-- Default initialization.
		do
			create criteria.make
			criteria.force (agent check_empty_snippet_rule)
			criteria.force (agent check_single_line_snippet_rule)
			criteria.force (agent check_calls_on_target_snippet_rule (?, 2))
		end

feature -- Access

	passed_check: BOOLEAN
			-- The evaluation of the last iteration by this checker.

	criteria: LINKED_SET [FUNCTION [EXT_SNIPPET_DECIDER, TUPLE [a_snippet: EXT_SNIPPET], BOOLEAN]]
			-- List of criteria that are checked for in

	decide_on_snippet (a_snippet: EXT_SNIPPET)
			-- Decision function answering if a snippet should be kept or not.
		do
			passed_check := across criteria as criteria_cursor all criteria_cursor.item.item ([a_snippet]) end
		end

feature {NONE} -- Implementation

	check_empty_snippet_rule (a_snippet: EXT_SNIPPET): BOOLEAN
			-- Returns false in case `a_compound_as' is empty.
		do
			if attached a_snippet.ast as l_compound_as then
				Result := not l_compound_as.is_empty
			end
		end

	check_single_line_snippet_rule (a_snippet: EXT_SNIPPET): BOOLEAN
			-- Returns false for snippets with one instruction that is not of type `{IF_AS}', `{LOOP_AS}' or `{INSPECT_AS}'.
		do
			if attached a_snippet.ast as l_compound_as then
				if l_compound_as.count = 1 then
					if attached l_compound_as.i_th (1) as l_as then
						if attached {IF_AS} l_as or attached {LOOP_AS} l_as or attached {INSPECT_AS} l_as then
							Result := True
						end
					end
				else
					Result := True
				end
			end
		end

	check_calls_on_target_snippet_rule (a_snippet: EXT_SNIPPET; a_min_bound: NATURAL): BOOLEAN
			-- Returns false for snippets with that have less than `a_min_bound' calls on target variables.
		local
			l_call_on_target_counter: COUNTER
			l_identifier_usage_finder: EPA_IDENTIFIER_USAGE_CALLBACK_ITERATOR
		do
			if attached a_snippet.ast as l_compound_as then
				create l_call_on_target_counter
				create l_identifier_usage_finder
				l_identifier_usage_finder.set_is_mode_disjoint (True)
				l_identifier_usage_finder.set_on_access_identifier_with_feature_call (
					agent (l_as: NESTED_AS; a_variable_context: EXT_VARIABLE_CONTEXT; a_counter: COUNTER)
						do
							if a_variable_context.is_target_variable (l_as.target.access_name_8) then
								a_counter.set_value (a_counter.next)
							end
						end (?, a_snippet.variable_context, l_call_on_target_counter)
					)

				l_compound_as.process (l_identifier_usage_finder)
				Result := l_call_on_target_counter.value >= a_min_bound.as_integer_32
			end
		end

end
