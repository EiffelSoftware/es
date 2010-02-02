note
	description: "Summary description for {SHARED_SCOOP_WORKBENCH}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_SCOOP_WORKBENCH

feature -- Initialisation

	setup_shared_scoop_workbench (a_scoop_workbench: SCOOP_WORKBENCH; l_system: SYSTEM_I) is
			-- setup the references
		require
			l_system_not_void: l_system /= Void
			a_scoop_workbench_not_void: a_scoop_workbench /= Void
		do
			shared_system := l_system
			l_scoop_workbench := a_scoop_workbench
		end

feature -- Access

	system: SYSTEM_I is
			-- Current system
		once
			Result := shared_system
		end

	shared_scoop_workbench: SCOOP_WORKBENCH is
			-- Current scoop workbench
		once
			Result := l_scoop_workbench
		end

	class_c: CLASS_C is
			-- Currenct class_c
		require
			class_c_not_void: shared_scoop_workbench /= Void and then shared_scoop_workbench.current_class_c /= Void
		do
			Result := shared_scoop_workbench.current_class_c
		end

	class_as: CLASS_AS is
			-- Current class_as
		require
			class_as_not_void: shared_scoop_workbench /= Void and then shared_scoop_workbench.current_class_as /= Void
		do
			Result := shared_scoop_workbench.current_class_as
		end

	feature_as: FEATURE_AS is
			-- Current feature_as
		require
			feature_as_not_void: feature_as /= Void
		do
			Result := shared_scoop_workbench.current_feature_as
		end

	feature_table: FEATURE_TABLE is
			-- Feature table of current class
		require
			feature_table_not_void: shared_scoop_workbench /= Void
				and then shared_scoop_workbench.current_class_c /= Void
				and then shared_scoop_workbench.current_class_c.feature_table /= Void
		do
			Result := shared_scoop_workbench.current_class_c.feature_table
		end

	scoop_classes: SCOOP_SEPARATE_CLASS_LIST is
			-- All classes which have to be processed.
		require
			scoop_classes_not_void: shared_scoop_workbench /= Void
				and then shared_scoop_workbench.scoop_classes /= Void
		do
			Result := shared_scoop_workbench.scoop_classes
		end

	set_scoop_classes (a_list: SCOOP_SEPARATE_CLASS_LIST) is
			-- Setter for 'scoop_class_list'
		do
			shared_scoop_workbench.set_scoop_classes (a_list)
		end

	set_current_class_c (a_class: CLASS_C) is
			-- Setter for 'current_class_c'
		do
			shared_scoop_workbench.set_current_class_c (a_class)
		end

	set_current_class_as (a_class: CLASS_AS) is
			-- Setter for 'current_class_as'
		do
			shared_scoop_workbench.set_current_class_as (a_class)
		end

	set_current_feature_as (a_feature: FEATURE_AS) is
			-- Setter for 'current_feature_as'
		do
			shared_scoop_workbench.set_current_feature_as (a_feature)
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
				i > system.classes.count
			loop
				a_class := system.classes.item (i)
				if a_class /= Void then
					if a_class.name_in_upper.is_equal (a_class_name.as_upper) then
						Result := a_class.ast
					end
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	l_scoop_workbench: SCOOP_WORKBENCH
			-- Reference to current scoop workbench

	shared_system: SYSTEM_I
			-- Reference to current system

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

end -- class SHARED_SCOOP_WORKBENCH
