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

			create classes_to_analyze.make
			create rule_violations.make (100)
		end

feature -- Analysis interface

	analyze
		local
			l_rules_checker: CA_ALL_RULES_CHECKER
		do
			create l_rules_checker.make
			across rules as l_rules loop
				if l_rules.item.is_enabled then -- important: only add enabled rules
					if system_wide_check or else (not l_rules.item.is_system_wide) then
						-- do not add system wide rules if we check only parts of the system
						l_rules.item.prepare_checking (l_rules_checker)
					end
				end
			end

			across classes_to_analyze as l_classes loop
				l_rules_checker.run_on_class (l_classes.item)

				rule_violations.extend (create {SORTED_TWO_WAY_LIST[CA_RULE_VIOLATION]}.make, l_classes.item)

				-- TODO: perhaps replace by more elegant and performant solution
				across rules as l_rules loop
					across l_rules.item.violations as l_v loop
						rule_violations.at (l_classes.item).extend (l_v.item)
					end
					l_rules.item.violations.wipe_out
				end
			end

			clear_classes_to_analyze
		ensure
			violation_list_exists: analysis_successful implies rule_violations /= Void
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
				print ("Analyzing class " + a_class.name + "...%N")
				classes_to_analyze.extend (l_class_c)
			else
				print ("Class " + a_class.name + " not compiled (skipped).%N")
			end
		end

feature -- Properties

	analysis_successful: BOOLEAN

	rules: LINKED_LIST[CA_RULE]

	rule_violations: detachable HASH_TABLE[SORTED_TWO_WAY_LIST[CA_RULE_VIOLATION], CLASS_C]

feature {NONE} -- Implementation

	settings: CA_SETTINGS

	classes_to_analyze: LINKED_SET[CLASS_C]

	system_wide_check: BOOLEAN

end
