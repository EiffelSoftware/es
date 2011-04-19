note
	description: "[
		Class to select classes according to given criteria
		Note: This class is similar to {QL_CLASS_DOMAIN_GENERATOR}.
		Actually most of the code in here is copied and adapted from
		{QL_CLASS_DOMAIN_GENERATOR}. It is so because we cannot use
		QL_* classes from here since the QL_* classes are not in a library.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CLASS_SELECTOR

inherit
	ANY
		redefine
			default_create
		end

	SHARED_WORKBENCH
		undefine
			default_create
		end

create
	default_create

feature{NONE} -- Initialization

	default_create
			-- Initialize Current.
		do
			create criteria.make
		end

feature -- Access

	last_classes: LINKED_LIST [CLASS_C]
			-- Last found classes

feature -- Selection

	select_from_group (a_group_name: STRING)
			-- Select classes from a group named `a_group_name'
			-- A group can by either a library or a cluster.
			-- Make results available in `last_classes'.
		do
			create last_classes.make
			across groups_from_target (universe.target) as l_groups loop
				if l_groups.key ~ a_group_name then
					process_classes_from_group (l_groups.item, agent last_classes.extend)
				end
			end
		end

	select_from_target
			-- Select classes from current application target
			-- Make results available in `last_classes'.
		do
			create last_classes.make
			across groups_from_target (universe.target) as l_groups loop
				process_classes_from_group (l_groups.item, agent last_classes.extend)
			end
		end

feature -- Feature selection criteria

	criteria: LINKED_LIST [FUNCTION [ANY, TUPLE [a_feature: CLASS_C], BOOLEAN]]
			-- List of criteria to select a class
			-- A class is to be selected if and only if it passes
			-- all criteria. If no criterion is given, all classes are passed by default.
			-- Do not modify this list, only use `add_xxx_selector' features.

feature{NONE} -- Implementation

	process_groups_from_target (a_target: CONF_TARGET; a_action: PROCEDURE [ANY, TUPLE [group: CONF_GROUP; name: STRING]])
			-- Process `a_target' to collect groups.
			-- Call `a_action' on each collected group.
		do
			across a_target.groups as l_groups loop
				a_action.call ([l_groups.item, l_groups.key])
			end
		end

	process_classes_from_group (a_group: CONF_GROUP; a_action: PROCEDURE [ANY, TUPLE [CLASS_C]])
			-- Process classes from `a_group'.
			-- If a class from `a_group' satisfies `criteria', call `a_action' on that class.
		local
			l_conf_class: CONF_CLASS
		do
			if a_group.classes_set then
				across a_group.classes.twin as l_classes loop
					l_conf_class := l_classes.item
					if is_class_compiled (l_conf_class) then
						if attached {CLASS_I} l_conf_class as l_class_i then
							if attached {CLASS_C} l_class_i.compiled_representation as l_class_c then
								if across criteria as l_cris all l_cris.item.item ([l_class_c]) end then
									a_action.call ([l_class_c])
								end
							end
						end
					end
				end
			end
		end

	is_class_compiled (a_conf_class: CONF_CLASS): BOOLEAN
			-- Does `a_conf_class' represent a compiled class?
		local
			l_class_i: CLASS_I
		do
			if not (a_conf_class.is_overriden or a_conf_class.does_override) then
				Result := a_conf_class.is_compiled
			else
				l_class_i ?= a_conf_class
				Result := l_class_i.compiled_representation /= Void
			end
		end

	groups_from_target (a_target: CONF_TARGET): HASH_TABLE [CONF_GROUP, STRING]
			-- Groups from `a_target'
			-- Keys are group names, values are groups.
		do
				-- Collect all groups from application target.
			create Result.make (10)
			Result.compare_objects
			process_groups_from_target (universe.target, agent Result.force)
		end

end
