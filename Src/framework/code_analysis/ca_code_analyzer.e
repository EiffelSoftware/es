note
	description: "Summary description for {CA_CODE_ANALYZER}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CODE_ANALYZER

inherit {NONE}
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
			-- Adding example rules
			rules.extend (create {CA_SELF_ASSIGNMENT_RULE}.make)
			rules.extend (create {CA_UNUSED_ARGUMENT_RULE}.make)
			rules.extend (create {CA_NPATH_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_EMPTY_IF_RULE}.make)
			rules.extend (create {CA_FEATURE_NEVER_CALLED_RULE}.make)
			rules.extend (create {CA_CQ_SEPARATION_RULE}.make)
			rules.extend (create {CA_UNNEEDED_OT_LOCAL_RULE}.make)
			rules.extend (create {CA_UNNEEDED_OBJECT_TEST_RULE}.make)
			rules.extend (create {CA_NESTED_COMPLEXITY_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_MANY_ARGUMENTS_RULE}.make (settings.preference_manager))
			rules.extend (create {CA_CREATION_PROC_EXPORTED_RULE}.make)
			rules.extend (create {CA_VARIABLE_NOT_READ_RULE}.make)
			rules.extend (create {CA_SEMICOLON_ARGUMENTS_RULE}.make)

			settings.initialize_rule_settings (rules)

			create classes_to_analyze.make
			create rule_violations.make (100)
			create completed_actions

			create ignoredby.make (25)
			create library_class.make (25)
			create nonlibrary_class.make (25)
		end

feature -- Analysis interface

	add_completed_action (a_action: PROCEDURE [ANY, TUPLE [BOOLEAN] ])
		do
			completed_actions.extend (a_action)
		end

	analyze
		require
			not is_running
		local
			l_rules_checker: CA_ALL_RULES_CHECKER
			l_task: CA_RULE_CHECKING_TASK
		do
			is_running := True
				-- TODO: caching
			rule_violations.wipe_out

			create l_rules_checker.make
			across rules as l_rules loop
				l_rules.item.clear_violations
				if l_rules.item.is_enabled.value then -- important: only add enabled rules
					if system_wide_check or else (not l_rules.item.is_system_wide) then
							-- do not add system wide rules if we check only parts of the system
						if attached {CA_STANDARD_RULE} l_rules.item as l_std_rule then

							l_std_rule.prepare_checking (l_rules_checker)
								-- TODO: prepare rules of other types?
						end
					end
				end
			end

			create l_task.make (l_rules_checker, rules, classes_to_analyze, agent analysis_completed)
			rota.run_task (l_task)
		end

	clear_classes_to_analyze
		do
			classes_to_analyze.wipe_out
		end

	add_whole_system
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
					-- Only load top-level clusters, as they are loaded recursively afterwards
				if l_cluster /= Void and then l_cluster.parent_cluster = Void then
					add_cluster (l_cluster)
				end
				l_groups.forth
			end

			system_wide_check := True
		end

	add_cluster (a_cluster: CLUSTER_I)
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

	add_classes (a_classes: ITERABLE[CLASS_I])
		do
			system_wide_check := False

			across a_classes as l_classes loop
				add_class (l_classes.item)
			end
		end

	add_class (a_class: CLASS_I)
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
				print ("Class " + a_class.name + " not compiled (skipped).%N")
			end
		end

feature -- Properties

	is_running: BOOLEAN

	analysis_successful: BOOLEAN

	rules: LINKED_LIST[CA_RULE]

	rule_violations: detachable HASH_TABLE[SORTED_TWO_WAY_LIST[CA_RULE_VIOLATION], CLASS_C]

	preferences: PREFERENCES
		do Result := settings.preferences end

feature {NONE} -- Implementation

	analysis_completed
		do
			across classes_to_analyze as l_classes loop
				rule_violations.extend (create {SORTED_TWO_WAY_LIST[CA_RULE_VIOLATION]}.make, l_classes.item)
			end

			across rules as l_rules loop
				across l_rules.item.violations as l_v loop
						-- check the ignore list
					if is_violation_valid (l_v.item) then
						rule_violations.at (l_v.item.affected_class).extend (l_v.item)
					end
				end
			end

			clear_classes_to_analyze

			is_running := False
			completed_actions.call ([True])
			completed_actions.wipe_out
		end

	is_violation_valid (a_viol: CA_RULE_VIOLATION): BOOLEAN
		local
			l_affected_class: CLASS_C
			l_rule: CA_RULE
		do
			l_affected_class := a_viol.affected_class
			l_rule := a_viol.rule

			Result := True

			if (ignoredby.has (l_affected_class))
							and then (ignoredby.at (l_affected_class)).has (l_rule.id) then
				Result := False
			end

			if (not l_rule.checks_library_classes) and then library_class.at (l_affected_class) = True then
				Result := False
			end

			if (not l_rule.checks_nonlibrary_classes) and then nonlibrary_class.at (l_affected_class) = True then
				Result := False
			end
		end

	settings: CA_SETTINGS

	classes_to_analyze: LINKED_SET [CLASS_C]

	system_wide_check: BOOLEAN

	completed_actions: ACTION_SEQUENCE [TUPLE [BOOLEAN]]

	frozen rota: detachable ROTA_S
			-- Access to rota service
		local
			l_service_consumer: SERVICE_CONSUMER [ROTA_S]
		do
			create l_service_consumer
			if l_service_consumer.is_service_available and then l_service_consumer.service.is_interface_usable then
				Result := l_service_consumer.service
			end
		end


feature {NONE} -- Class-wide Options (From Indexing Clauses)

	extract_indexes (a_class: CLASS_C)
		local
			l_ast: CLASS_AS
			l_item: STRING_32
			l_ignoredby: LINKED_LIST [STRING_32]
		do
			create l_ignoredby.make
			l_ignoredby.compare_objects
			library_class.force (False, a_class)
			nonlibrary_class.force (False, a_class)
			l_ast := a_class.ast

			across l_ast.internal_top_indexes as l_indexes loop

				if l_indexes.item.tag.name_32.is_equal ("ca_ignoredby") then
					across l_indexes.item.index_list as l_list loop
						l_item := l_list.item.string_value_32
						l_item.prune_all ('%"')
						l_ignoredby.extend (l_item)
					end
				elseif l_indexes.item.tag.name_32.is_equal ("ca_library") then
					if not l_indexes.item.index_list.is_empty then
						l_item := l_indexes.item.index_list.first.string_value_32
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

			ignoredby.force (l_ignoredby, a_class)
		end

	ignoredby: HASH_TABLE [LINKED_LIST [STRING_32], CLASS_C]

	library_class, nonlibrary_class: HASH_TABLE [BOOLEAN, CLASS_C]

invariant
--	law_of_non_contradiction: one class must not be both a library_class and a nonlibrary_class

end
