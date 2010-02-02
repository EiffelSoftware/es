note
	description: "Summary description for {SHARED_SCOOP_WORKBENCH}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_WORKBENCH

inherit
	SHARED_WORKBENCH
		export
			{NONE} all
			{ANY} system
		end

	SHARED_SERVER
		export
			{NONE} all
			{ANY} match_list_server
		end

	SCOOP_WORKBENCH_ACCESS

feature -- CLASS_C access

	class_c: CLASS_C is
			-- Currenct class_c
		require
			class_c_not_void: scoop_workbench_objects /= Void and then scoop_workbench_objects.current_class_c /= Void
		do
			Result := scoop_workbench_objects.current_class_c
		end

	set_current_class_c (a_class: CLASS_C) is
			-- Setter for 'current_class_c'
		do
			scoop_workbench_objects.set_current_class_c (a_class)
		end

feature -- CLASS_AS access

	class_as: CLASS_AS is
			-- Current class_as
		require
			class_as_not_void: scoop_workbench_objects /= Void and then scoop_workbench_objects.current_class_as /= Void
		do
			Result := scoop_workbench_objects.current_class_as
		end

	set_current_class_as (a_class: CLASS_AS) is
			-- Setter for 'current_class_as'
		do
			scoop_workbench_objects.set_current_class_as (a_class)
		end

feature -- FEATURE_AS access

	feature_as: FEATURE_AS is
			-- Current feature_as
		do
			Result := scoop_workbench_objects.current_feature_as
		end

	set_current_feature_as (a_feature: FEATURE_AS) is
			-- Setter for 'current_feature_as'
		do
			scoop_workbench_objects.set_current_feature_as (a_feature)
		end

	set_current_feature_as_void is
			-- Setter for 'current_feature_as'
		do
			scoop_workbench_objects.set_current_feature_as (Void)
		end

feature {SCOOP_SEPARATE_PROXY_PRINTER, SCOOP_PROXY_FEATURE_VISITOR} -- FEATURE_CLAUSE_AS access

	feature_clause_as: FEATURE_CLAUSE_AS is
			-- Current processed feature clause
		require
			feature_clause_as_not_void: feature_clause_as /= Void
		do
			Result := scoop_workbench_objects.current_feature_clause_as
		end

	set_current_feature_clause_as (a_feature_clause: FEATURE_CLAUSE_AS) is
			-- Setter for 'feature_clause_as'
		do
			scoop_workbench_objects.set_current_feature_clause_as (a_feature_clause)
		end

	set_current_feature_clause_as_void is
			-- Setter for 'feature_clause_as'
		do
			scoop_workbench_objects.set_current_feature_clause_as (Void)
		end

feature {SCOOP_SEPARATE_PROXY_PRINTER, SCOOP_PROXY_FEATURE_VISITOR} -- FEATURE_CLAUSE_AS access

	is_first_feature: BOOLEAN is
			-- Indicates the first occurance of a feature in a feature clause.
		do
			Result := scoop_workbench_objects.is_first_feature
		end

	set_is_first_feature (a_value: BOOLEAN) is
			-- Setter for 'is_first_feature'
		do
			scoop_workbench_objects.set_is_first_feature (a_value)
		end

feature -- FEATURE_TABLE access

	feature_table: FEATURE_TABLE is
			-- Feature table of current class
		require
			feature_table_not_void: scoop_workbench_objects /= Void
				and then scoop_workbench_objects.current_class_c /= Void
				and then scoop_workbench_objects.current_class_c.feature_table /= Void
		do
			Result := scoop_workbench_objects.current_class_c.feature_table
		end

feature -- SCOOP_SEPARATE_CLASS_LIST access

	scoop_classes: SCOOP_SEPARATE_CLASS_LIST is
			-- All classes which have to be processed.
		require
			scoop_classes_not_void: scoop_workbench_objects /= Void
				and then scoop_workbench_objects.scoop_classes /= Void
		do
			Result := scoop_workbench_objects.scoop_classes
		end

	set_scoop_classes (a_list: SCOOP_SEPARATE_CLASS_LIST) is
			-- Setter for 'scoop_class_list'
		do
			scoop_workbench_objects.set_scoop_classes (a_list)
		end

feature -- Current SCOOP_CLIENT_FEATURE_OBJECT access

	feature_object: SCOOP_CLIENT_FEATURE_OBJECT is
			-- Getter for `current_feature_object'.
		do
			Result := scoop_workbench_objects.current_feature_object
		end

	set_feature_object (a_feature_object: SCOOP_CLIENT_FEATURE_OBJECT) is
			-- Setter for `current_feature_object'.
		do
			scoop_workbench_objects.set_current_feature_object (a_feature_object)
		end

feature -- Current proxy feature name

	proxy_feature_name: STRING is
			-- Getter for `current_proxy_feature_name'
		do
			Result := scoop_workbench_objects.current_proxy_feature_name
		ensure
			Result_not_void: Result /= Void
		end

feature -- System support

	get_class_as_by_name (a_class_name: STRING): CLASS_AS is
			-- Get a class_as by name
		local
			i: INTEGER
			a_class: CLASS_C
		do
			from
				i := 1
			until
				i > system.classes.sorted_classes.count
			loop
				a_class := system.classes.sorted_classes.item (i)
				if a_class /= Void then
					if a_class.name_in_upper.is_equal (a_class_name.as_upper) then
						Result := a_class.ast
					end
				end
				i := i + 1
			end
		end

invariant
	scoop_workbench_objects_not_void: scoop_workbench_objects /= Void

note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- class SCOOP_WORKBENCH
