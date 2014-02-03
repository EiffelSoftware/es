note
	description: "THE Code Analyzer."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CODE_ANALYZER

inherit
	SHARED_EIFFEL_PROJECT

	CA_SHARED_NAMES

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create settings.make
			create rules.make
				-- Adding the rules.
			rules.extend (create {CA_SELF_ASSIGNMENT_RULE}.make)
			rules.extend (create {CA_UNUSED_ARGUMENT_RULE}.make)
			rules.extend (create {CA_NPATH_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_EMPTY_IF_RULE}.make)
			rules.extend (create {CA_FEATURE_NEVER_CALLED_RULE}.make)
			rules.extend (create {CA_CQ_SEPARATION_RULE}.make)
			rules.extend (create {CA_UNNEEDED_OT_LOCAL_RULE}.make)
			rules.extend (create {CA_UNNEEDED_OBJECT_TEST_RULE}.make) -- Needs type info.
			rules.extend (create {CA_NESTED_COMPLEXITY_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_MANY_ARGUMENTS_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_CREATION_PROC_EXPORTED_RULE}.make)
			rules.extend (create {CA_VARIABLE_NOT_READ_RULE}.make)
			rules.extend (create {CA_SEMICOLON_ARGUMENTS_RULE}.make)
			rules.extend (create {CA_VERY_LONG_ROUTINE_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_VERY_BIG_CLASS_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_FEATURE_SECTION_COMMENT_RULE}.make)
			rules.extend (create {CA_FEATURE_NOT_COMMENTED_RULE}.make)
			rules.extend (create {CA_BOOLEAN_RESULT_RULE}.make)
			rules.extend (create {CA_BOOLEAN_COMPARISON_RULE}.make)
			rules.extend (create {CA_VERY_SHORT_IDENTIFIER_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_VERY_LONG_IDENTIFIER_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_MISSING_IS_EQUAL_RULE}.make)
			rules.extend (create {CA_SIMPLIFIABLE_BOOLEAN_RULE}.make)
			rules.extend (create {CA_SELF_COMPARISON_RULE}.make)
			rules.extend (create {CA_TODO_RULE}.make)
			rules.extend (create {CA_WRONG_LOOP_ITERATION_RULE}.make)
			rules.extend (create {CA_INSPECT_INSTRUCTIONS_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_ATTRIBUTE_TO_LOCAL_RULE}.make)
			rules.extend (create {CA_EMPTY_EFFECTIVE_ROUTINE_RULE}.make)
			rules.extend (create {CA_IF_ELSE_NOT_EQUAL_RULE}.make)
			rules.extend (create {CA_SHORT_CIRCUIT_IF_RULE}.make)
			rules.extend (create {CA_ITERABLE_LOOP_RULE}.make) -- Needs type info.
			rules.extend (create {CA_COUNT_EQUALS_ZERO_RULE}.make) -- Needs type info.
			rules.extend (create {CA_DEEPLY_NESTED_IF_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_UNNEEDED_HELPER_VARIABLE_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_UNNEEDED_PARENTHESES_RULE}.make)

			settings.initialize_rule_settings (rules)

			create classes_to_analyze.make
			create rule_violations.make (100)
			create completed_actions
			create output_actions

			create ignoredby.make (25)
			create library_class.make (25)
			create nonlibrary_class.make (25)
		end

feature -- Analysis interface

	add_completed_action (a_action: PROCEDURE [ANY, TUPLE [BOOLEAN]])
			-- Adds `a_action' to the list of procedures that will be
			-- called when analysis has completed.
		do
			completed_actions.extend (a_action)
		end

	add_output_action (a_action: PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]])
		do
			output_actions.extend (a_action)
		end

	analyze
			-- Analyze all the classes that have been added.
		require
			not is_running
		local
			l_rules_checker: CA_ALL_RULES_CHECKER
			l_task: CA_RULE_CHECKING_TASK
			l_rules_to_check: LINKED_LIST [CA_RULE]
		do
			is_running := True

			create l_rules_checker.make
			create l_rules_to_check.make
			across rules as l_rules loop
				l_rules.item.clear_violations
				if is_rule_checkable (l_rules.item) then
					l_rules_to_check.extend (l_rules.item)
						-- Here we only prepare standard rules. The rule checking task will iterate again
						-- through the rules and run the analysis on the enabled rules.
					if attached {CA_STANDARD_RULE} l_rules.item as l_std_rule then
						l_std_rule.prepare_checking (l_rules_checker)
					end
				end
			end

			create l_task.make (l_rules_checker, l_rules_to_check, classes_to_analyze, agent analysis_completed)
			l_task.set_output_actions (output_actions)
			rota.run_task (l_task)
		end

	is_rule_checkable (a_rule: CA_RULE): BOOLEAN
		do
			Result := a_rule.is_enabled.value
						and then (system_wide_check or else (not a_rule.is_system_wide))
						and then is_severity_enabled (a_rule.severity)
		end

	clear_classes_to_analyze
			-- Remove all classes that have been added to the list of classes
			-- to analyze.
		do
			classes_to_analyze.wipe_out
		end

	add_whole_system
			-- Add all the classes that are part of the current system. Classes of references libraries
			-- will not be added.
		local
			l_groups: LIST [CONF_GROUP]
			l_cluster: CLUSTER_I
		do
			from
				l_groups := eiffel_universe.groups
				l_groups.start
			until
				l_groups.after
			loop
				l_cluster ?= l_groups.item_for_iteration
					-- Only load top-level clusters, as the others will be loaded recursively afterwards.
				if l_cluster /= Void and then l_cluster.parent_cluster = Void then
					add_cluster (l_cluster)
				end
				l_groups.forth
			end

			system_wide_check := True
		end

	add_cluster (a_cluster: CLUSTER_I)
			-- Add all classes of cluster `a_cluster'.
		local
			l_conf_class: CONF_CLASS
			l_class_i: CLASS_I
		do
			system_wide_check := False

			from
				a_cluster.classes.start
			until
				a_cluster.classes.after
			loop
				l_conf_class := a_cluster.classes.item_for_iteration
				l_class_i := eiffel_universe.class_named (l_conf_class.name, a_cluster)
				add_class (l_class_i)
				a_cluster.classes.forth
			end
			if a_cluster.sub_clusters /= Void then
				from
					a_cluster.sub_clusters.start
				until
					a_cluster.sub_clusters.after
				loop
					add_cluster (a_cluster.sub_clusters.item_for_iteration)
					a_cluster.sub_clusters.forth
				end
			end
		end

	add_group (a_group: CONF_GROUP)
			-- Add all classes of the configuration group `a_group'.
		require
			a_group_not_void: a_group /= Void
		local
			l_conf_class: CONF_CLASS
			l_class_i: CLASS_I
		do
			from
				a_group.classes.start
			until
				a_group.classes.after
			loop
				l_conf_class := a_group.classes.item_for_iteration
				l_class_i := eiffel_universe.class_named (l_conf_class.name, a_group)
				add_class (l_class_i)
				a_group.classes.forth
			end
		end

	add_classes (a_classes: ITERABLE [CLASS_I])
			-- Add the classes `a_classes'.
		do
			system_wide_check := False

			across a_classes as l_classes loop
				add_class (l_classes.item)
			end
		end

	add_class (a_class: CLASS_I)
			-- Adds class `a_class'.
		local
			l_class_c: CLASS_C
		do
			system_wide_check := False

			if a_class.is_compiled then
				l_class_c := a_class.compiled_class
				check l_class_c /= Void end
				classes_to_analyze.extend (l_class_c)

				extract_indexes (l_class_c)
			else
				output_actions.call ([ca_messages.class_skipped (a_class.name)])
			end
		end

feature -- Properties

	is_running: BOOLEAN
			-- Is code analysis running?

	rules: LINKED_LIST [CA_RULE]
			-- List of rules that will be used for analysis.

	rule_violations: detachable HASH_TABLE [SORTED_TWO_WAY_LIST [CA_RULE_VIOLATION], CLASS_C]
			-- All found violations from the last analysis.

	preferences: PREFERENCES
			-- Code Analysis preferences.
		do Result := settings.preferences end

	class_list: ITERABLE [CLASS_C]
			-- List of classes that have been added.
		do Result := classes_to_analyze end

feature {NONE} -- Implementation

	csv_file_name: STRING = "last_analysis_result.csv"

	csv_header: STRING = "Severity;Class;Location;Title;Description;Rule ID;Severity Score"

	analysis_completed
			-- Will be called when the analysis task has finished.
		local
			l_csv_writer: CA_CSV_WRITER
		do
			create l_csv_writer.make (csv_file_name, csv_header)

			across rules as l_rules loop
				across l_rules.item.violations as l_v loop
						-- Check the ignore list.
					if is_violation_valid (l_v.item) then
							-- Make sure a list for this class exists in the hash table:
						rule_violations.put (create {SORTED_TWO_WAY_LIST [CA_RULE_VIOLATION]}.make, l_v.item.affected_class)
							-- Add the violation.
						rule_violations.at (l_v.item.affected_class).extend (l_v.item)
							-- Log it.
						l_csv_writer.add_line (l_v.item.csv_line)
					end
				end
			end

			l_csv_writer.close_file

			clear_classes_to_analyze

			is_running := False
			completed_actions.call ([True])
			completed_actions.wipe_out
		end

	is_violation_valid (a_viol: CA_RULE_VIOLATION): BOOLEAN
			-- Is the violation `a_viol' valid under the current settings
			-- such as the rule ignore list of a class, or the library or
			-- non-library status of a class?
		local
			l_affected_class: CLASS_C
			l_rule: CA_RULE
		do
			l_affected_class := a_viol.affected_class
			l_rule := a_viol.rule

			Result := True

			if ignoredby.has (l_affected_class)
							and then (ignoredby.at (l_affected_class)).has (l_rule.id) then
				Result := False
			end

			if (not l_rule.checks_library_classes) and then library_class.at (l_affected_class) then
				Result := False
			end

			if (not l_rule.checks_nonlibrary_classes) and then nonlibrary_class.at (l_affected_class) then
				Result := False
			end
		end

	settings: CA_SETTINGS
			-- The settings manager for Code Analysis.

	classes_to_analyze: LINKED_SET [CLASS_C]
			-- List of classes that shall be analyzed.

	system_wide_check: BOOLEAN
			-- Shall the whole system be analyzed?

	completed_actions: ACTION_SEQUENCE [TUPLE [BOOLEAN]]
			-- List of procedures to call when analysis has completed.

	frozen rota: detachable ROTA_S
			-- Accesses the rota service.
		local
			l_service_consumer: SERVICE_CONSUMER [ROTA_S]
		do
			create l_service_consumer
			if l_service_consumer.is_service_available and then l_service_consumer.service.is_interface_usable then
				Result := l_service_consumer.service
			end
		end

	is_severity_enabled (a_severity: CA_RULE_SEVERITY): BOOLEAN
		do
			Result := (attached {CA_HINT} a_severity and settings.are_hints_enabled.value)
				or else (attached {CA_SUGGESTION} a_severity and settings.are_suggestions_enabled.value)
				or else (attached {CA_WARNING} a_severity and settings.are_warnings_enabled.value)
				or else (attached {CA_ERROR} a_severity and settings.are_errors_enabled.value)
		end

	output_actions: ACTION_SEQUENCE [TUPLE [READABLE_STRING_GENERAL]]
			-- Will be called whenever there is a message to output.

feature {NONE} -- Class-wide Options (From Indexing Clauses)

	extract_indexes (a_class: CLASS_C)
			-- Extracts options from the indexing clause of class `a_class'.
		local
			l_ast: CLASS_AS
			l_ignoredby: LINKED_LIST [STRING_32]
		do
			create l_ignoredby.make
			l_ignoredby.compare_objects -- We want to compare the actual strings.
				-- Reset the class flags.
			library_class.force (False, a_class)
			nonlibrary_class.force (False, a_class)
			l_ast := a_class.ast

			if attached l_ast.internal_top_indexes as l_top then
				search_indexing_tags (l_top, a_class, l_ignoredby)
			end
			if attached l_ast.internal_bottom_indexes as l_bottom then
				search_indexing_tags (l_bottom, a_class, l_ignoredby)
			end

			ignoredby.force (l_ignoredby, a_class)
		end

	search_indexing_tags (a_clause: INDEXING_CLAUSE_AS; a_class: CLASS_C; a_ignoredby: LINKED_LIST [STRING_32])
			-- Searches `a_clause' for settings relevant to code analysis.
		local
			l_item: STRING_32
		do
			across a_clause as ic loop
				if ic.item.tag.name_32.is_equal ("ca_ignoredby") then
						-- Class wants to ignore certain rules.
					across ic.item.index_list as l_list loop
						l_item := l_list.item.string_value_32
						l_item.prune_all ('%"')
						a_ignoredby.extend (l_item)
					end
				elseif ic.item.tag.name_32.is_equal ("ca_library") then
						-- Class has information on whether it is a library class.
					if not ic.item.index_list.is_empty then
						l_item := ic.item.index_list.first.string_value_32
						l_item.to_lower
						l_item.prune_all ('%"')
						if l_item.is_equal ("true") then
							library_class.force (True, a_class)
						elseif l_item.is_equal ("false") then
							nonlibrary_class.force (True, a_class)
						end
					end
				end
			end
		end

	ignoredby: HASH_TABLE [LINKED_LIST [STRING_32], CLASS_C]
			-- Maps classes to lists of rules (rule IDs) the class wants to be ignored by.

	library_class, nonlibrary_class: HASH_TABLE [BOOLEAN, CLASS_C]
			-- Stores classes that are marked as library or non-library classes.

invariant
	--	law_of_non_contradiction: one class must not be both a library_class and a nonlibrary_class

end
