note
	description: "Summary description for {CA_CODE_ANALYZER}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CODE_ANALYZER

inherit {NONE}
	SHARED_EIFFEL_PROJECT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create settings
			create rules.make
			-- Adding example rules
			rules.extend (create {CA_SELF_ASSIGNMENT_RULE}.make)
			rules.extend (create {CA_UNUSED_ARGUMENT_RULE}.make)
		end

feature

	analyze_system
		local
			l_groups: LIST [CONF_GROUP]
			l_cluster: CLUSTER_I
		do
			create rules_checker.make
			across rules as l_rules loop
				if l_rules.item.is_enabled then -- important: only add enabled rules
					rules_checker.add_rule_checker (l_rules.item.rule_checker)
				end
			end

			from
				l_groups := eiffel_universe.groups
				l_groups.start
			until
				l_groups.after
			loop
				l_cluster ?= l_groups.item_for_iteration
					-- Only load top-level clusters, as they are loaded recursively afterwards
				if l_cluster /= Void and then l_cluster.parent_cluster = Void then
					analyze_cluster (l_cluster)
				end
				l_groups.forth
			end

			analysis_successful := rules_checker.last_run_successful
			if analysis_successful then
				rule_violations := rules_checker.last_result
			end
		ensure
			violation_list_exists: analysis_successful implies rule_violations /= Void
		end

	analyze_cluster (a_cluster: CLUSTER_I)
		local
			l_conf_class: CONF_CLASS
			l_class_i: CLASS_I
		do
			from
				a_cluster.classes.start
			until
				a_cluster.classes.after
			loop
				l_conf_class := a_cluster.classes.item_for_iteration
				l_class_i := eiffel_universe.class_named (l_conf_class.name, a_cluster)
				analyze_class_if_compiled (l_class_i)
				a_cluster.classes.forth
			end
			if a_cluster.sub_clusters /= Void then
				from
					a_cluster.sub_clusters.start
				until
					a_cluster.sub_clusters.after
				loop
					analyze_cluster (a_cluster.sub_clusters.item_for_iteration)
					a_cluster.sub_clusters.forth
				end
			end
		end

	analyze_classes (classes: LINKED_LIST[CLASS_AS])
		do

		ensure
			violation_list_exists: analysis_successful implies rule_violations /= Void
		end

	analyze_class (a_class_to_analyze: CLASS_AS)
		do
			create rules_checker.make
			across rules as l_rules loop
				if l_rules.item.is_enabled then -- important: only add enabled rules
					rules_checker.add_rule_checker (l_rules.item.rule_checker)
				end
			end

			rules_checker.run_on_class (a_class_to_analyze)
			analysis_successful := rules_checker.last_run_successful
			if analysis_successful then
				rule_violations := rules_checker.last_result
			end
		ensure
			violation_list_exists: analysis_successful implies rule_violations /= Void
		end

feature

	analysis_successful: BOOLEAN

	rules: LINKED_LIST[CA_RULE]

	rule_violations: detachable LINKED_LIST[CA_RULE_VIOLATION]

feature {NONE} -- Implementation

	settings: CA_SETTINGS

	analyze_class_if_compiled (a_class: CLASS_I)
		local
			l_class_c: CLASS_C
		do
			if a_class.is_compiled then
				l_class_c := a_class.compiled_class
				check l_class_c /= Void end
				print ("Analyzing class " + a_class.name + "...%N")
				rules_checker.run_on_class (l_class_c.ast)
			else
				print ("Class " + a_class.name + " not compiled (skipped).%N")
			end
		end

	rules_checker: CA_ALL_RULES_CHECKER

end
