note
	description: "Command to collect annotations through dynamic means"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANN_DYNAMIC_ANNOTATOR_CMD

inherit
	ANN_COMMAND

	EPA_DEBUGGER_UTILITY

	SHARED_WORKBENCH

	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

	EPA_CFG_UTILITY

create
	make

feature {NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current command.
		do
			config := a_config
		ensure
			config_set: config = a_config
		end

feature -- Access

	annotations: LINKED_LIST [ANN_ANNOTATION]
			-- Collected annotations

feature -- Basic operations

	execute
			-- Execute Current command
		local
			l_bp_mgr: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
			l_expressions: DS_HASH_SET [EPA_EXPRESSION]
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_exp: EPA_AST_EXPRESSION
			l_selector: EPA_FEATURE_SELECTOR
			l_var_finder: ANN_INTERESTING_VARIABLE_FINDER
			l_pre_state_finder: ANN_INTERESTING_PRE_STATE_FINDER
			l_post_state_finder: ANN_POST_STATE_FINDER
		do
			l_class := config.locations.first.context_class
			l_feature := config.locations.first.feature_

--			l_class := first_class_starts_with_name ("APPLICATION")
--			l_feature := feature_from_class ("APPLICATION", "fibonacci")

			create l_post_state_finder.make_with (l_class, l_feature)
			l_post_state_finder.find
			post_state_map := l_post_state_finder.post_state_map

			create l_pre_state_finder.make_with (l_feature.e_feature.ast)
			l_pre_state_finder.find
			interesting_pre_states := l_pre_state_finder.interesting_pre_states

			-- Setup the expressions to evaluate.
			create l_expressions.make_default
			l_expressions.set_equality_tester (expression_equality_tester)

			create l_selector.default_create
			l_selector.add_query_selector
			l_selector.add_argumented_feature_selector (0, 0)
			l_selector.add_selector (l_selector.not_from_any_feature_selector)

			create l_var_finder.make_with (l_feature.e_feature.ast)
			l_var_finder.find

			across l_var_finder.interesting_variables.to_array as l_var loop
				create l_exp.make_with_text (l_class, l_feature, l_var.item, l_class)
				l_selector.select_from_class (l_exp.type.associated_class)

				across l_selector.last_features as l_queries loop
					create l_exp.make_with_text (l_class, l_feature, l_var.item + "." + l_queries.item.feature_name, l_class)
					l_expressions.force_last (l_exp)
				end
			end

			if l_var_finder.interesting_variables.has ("Current") then
				across local_names_of_feature (l_feature).to_array as l_locals loop
					create l_exp.make_with_text (l_class, l_feature, "Current." + l_locals.item, l_class)
					l_expressions.force_last (l_exp)
				end
			end

			if l_var_finder.interesting_variables.has ("Result") then
				create l_exp.make_with_text (l_class, l_feature, "Result", l_class)
				l_expressions.force_last (l_exp)
			end

			-- Remove breakpoints set by previous debugging sessions.
			remove_breakpoint (debugger_manager, config.root_class)

			across interesting_pre_states.to_array as l_pre_states loop
				create l_bp_mgr.make (l_class, l_feature)
				l_bp_mgr.set_breakpoint_with_expression_and_action (l_pre_states.item, l_expressions, agent on_expression_evalauted)
				l_bp_mgr.toggle_breakpoints (True)

				across post_state_map.item (l_pre_states.item).to_array as l_post_states loop
					create l_bp_mgr.make (l_class, l_feature)
					l_bp_mgr.set_breakpoint_with_expression_and_action (l_post_states.item, l_expressions, agent on_expression_evalauted)
					l_bp_mgr.toggle_breakpoints (True)
				end
			end

			-- Start program execution in debugger.
			start_debugger (debugger_manager, "", config.working_directory, {EXEC_MODES}.run, False)

			-- Remove the last debugging session.
			remove_debugger_session
		end

feature {NONE} -- Implementation

	on_expression_evalauted (a_bp: BREAKPOINT; a_state: EPA_STATE)
			-- Action to be performed when expressions are evaluated at breakpoint `a_bp'.
			-- `a_state' is a set of expression evaluations.
		do
			io.put_string ("%N==> " + a_bp.breakable_line_number.out + "%N")
			io.put_string (a_state.debug_output +"%N")
			io.put_string ("==>%N")
		end

feature {NONE} -- Implementation

	interesting_pre_states: DS_HASH_SET [INTEGER]
			-- Contains all interesting pre-states

	post_state_map: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			-- Contains the found post-states.
			-- Keys are pre-states and values are (possibly multiple) post-states

end
