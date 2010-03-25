note
	description: "Shared objects needed during SCOOP compilation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_WORKBENCH_OBJECTS

create
	make

feature -- Initialization

	make
			-- Initialize SCOOP workbench objects.
		do
			create proxy_parent_objects.make
			create parent_redefine_list.make
		end

feature -- Access

	reset is
			-- Reset classdependant values.
		do
			current_class_as := Void
			current_class_c := Void
			current_feature_as := Void
			current_feature_object := Void
			proxy_parent_objects.wipe_out
			parent_redefine_list.wipe_out
			if proxy_infix_prefix_wrappers /= Void then
				proxy_infix_prefix_wrappers.wipe_out
			end
		end

feature -- Current CLASS_C access

	current_class_c: CLASS_C
			-- Current processed class_c, access from scoop workbench.

	set_current_class_c (a_class: CLASS_C) is
			-- Set `a_class' to current class_c.
		do
			current_class_c := a_class
		end

feature -- Current CLASS_AS access

	current_class_as: CLASS_AS
			-- Current processed class_as, access from scoop workbench.

	set_current_class_as (a_class: CLASS_AS) is
			-- Set `a_class' to current class_as.
		do
			current_class_as := a_class
		end

feature -- Current FEATURE_AS access

	current_feature_as: FEATURE_AS
			-- Current processed feature_as, access from scoop workbench.

	set_current_feature_as (a_feature: FEATURE_AS) is
			-- Set `a_feature' to current feature_as.
		do
			current_feature_as := a_feature
		end

feature -- Current FEATURE_CLAUSE_AS access

	current_feature_clause_as: FEATURE_CLAUSE_AS
			-- Current processed feature_clause_as, access from scoop workbench.

	set_current_feature_clause_as (a_feature_clause: FEATURE_CLAUSE_AS) is
			-- Set `a_feature_clause' to current feature_clase_as.
		do
			current_feature_clause_as := a_feature_clause
		end

feature -- Current FEATURE_CLAUSE_AS access

	is_first_feature: BOOLEAN
			-- Is current feature the first in feature clause?

	set_is_first_feature (a_value: BOOLEAN) is
			-- Set `a_value' for first feature occurrence.
		do
			is_first_feature := a_value
		end

feature -- SCOOP_SEPARATE_CLASS_LIST access

	scoop_classes: SCOOP_SEPARATE_CLASS_LIST
			-- The classes to be processed.

	set_scoop_classes (a_list: SCOOP_SEPARATE_CLASS_LIST) is
			-- Set `a_list' containing classes to be processed.
		do
			scoop_classes := a_list
		end

feature -- SCOOP_CLIENT_FEATURE_OBJECT access

	current_feature_object: SCOOP_CLIENT_FEATURE_OBJECT
			-- Reference to current client feature object.

	current_derived_class_information: SCOOP_DERIVED_CLASS_INFORMATION
			-- Reference to current derived class information.

	set_current_feature_object (a_feature_object: SCOOP_CLIENT_FEATURE_OBJECT) IS
			-- Set `a_feature_object' to current client feature object.
		do
			current_feature_object := a_feature_object
		end

	set_current_derived_class_information (a_derived_class_information: SCOOP_DERIVED_CLASS_INFORMATION) IS
			-- Set `a_derived_class_information' to current derived class information.
		do
			current_derived_class_information := a_derived_class_information
		end

feature -- SCOOP proxy feature name access

	current_proxy_feature_name: STRING
			-- Name of current processed proxy feature.

	set_current_proxy_feature_name (a_name: STRING)
			-- Set `a_name' to proxy feature name.
		do
			current_proxy_feature_name := a_name
		end

feature -- SCOOP_PROXY_PARENT_OBJECT access

	add_proxy_parent_object (a_proxy_parent_object: SCOOP_PROXY_PARENT_OBJECT) is
			-- Adds `a_proxy_parent_object' to the proxy parent objects.
		require
			a_proxy_parent_object_not_void: a_proxy_parent_object /= Void
		do
			if not has_proxy_parent_object (a_proxy_parent_object.parent_name) then
				proxy_parent_objects.extend (a_proxy_parent_object)
			end
		end

	proxy_parent_object (a_parent_name: STRING): SCOOP_PROXY_PARENT_OBJECT is
			-- Proxy parent object with name `a_parent_name'.
		require
			a_parent_name_not_void: a_parent_name /= Void
		local
			i, nb: INTEGER
		do
			from
				i := 1
				nb := proxy_parent_objects.count
			until
				i > nb
			loop
				if proxy_parent_objects.i_th (i).parent_name.is_equal (a_parent_name) then
					Result := proxy_parent_objects.i_th (i)
				end
				i := i + 1
			end
		end

	has_proxy_parent_object (a_parent_name: STRING): BOOLEAN is
			-- Is `a_parent_name' in the parent object list?
		require
			a_parent_name_not_void: a_parent_name /=  Void
		local
			i, nb: INTEGER
		do
			from
				i := 1
				nb := proxy_parent_objects.count
			until
				i > nb
			loop
				if proxy_parent_objects.i_th (i).parent_name.is_equal (a_parent_name) then
					Result := True
				end
				i := i + 1
			end
		end

	append_parent_redefine_list (a_list: like parent_redefine_list) is
			-- Set `a_list' to the parent redefine list.
		require
			a_list_not_void: a_list /= Void
		do
			parent_redefine_list.append (a_list)
		end

	insert_redefine_statement (an_original_feature_name, an_original_alias_name, a_feature_name: STRING; a_string_context: ROUNDTRIP_STRING_LIST_CONTEXT) is
			-- Insert `a_string_context' the redefine statement for the assigner
			-- wrapper feature if `an_original_feature_name' or `an_original_alias_name'
			-- is exists the parent redefine list.
		require
			an_original_feature_name_not_void: an_original_feature_name /= Void
		local
			i, nb: INTEGER
			l_str: STRING
			l_parent_object: SCOOP_PROXY_PARENT_OBJECT
			l_tuple: TUPLE [orignial_feature_name, original_feature_alias_name: STRING; parent_object: SCOOP_PROXY_PARENT_OBJECT ]
		do
			from
				i := 1
				nb := parent_redefine_list.count
			until
				i > nb
			loop
				l_tuple := parent_redefine_list.i_th (i)
				if l_tuple.orignial_feature_name.is_equal (an_original_feature_name)
					or l_tuple.original_feature_alias_name.is_equal (an_original_alias_name) then
					-- get parent object
					l_parent_object := l_tuple.parent_object

					-- create redefine string
					create l_str.make_from_string (a_feature_name + "_scoop_separate_assigner_")

					-- insert a redefine feature for the wrapper feature
					l_parent_object.add_redefine_clause (l_str, a_string_context)
				end

				i := i + 1
			end
		end

feature -- SCOOP proxy infix prefix wrapper feature

	proxy_infix_prefix_wrappers: LINKED_LIST [STRING]
			-- List of new created wrapper features.
			-- Remove this item with EiffelStudio 6.4

	extend_proxy_infix_prefix_wrappers (a_wrapper: STRING) is
			-- Adds the wrapper feature tot he wrapper list.
			-- Remove this item with EiffelStudio 6.4
		do
			if proxy_infix_prefix_wrappers = Void then
				create proxy_infix_prefix_wrappers.make
			end
			proxy_infix_prefix_wrappers.extend (a_wrapper)
		end

feature {NONE} -- SCOOP_CLIENT_FEATURE_OBJECT implementation

	proxy_parent_objects: LINKED_LIST[SCOOP_PROXY_PARENT_OBJECT]
			-- List of proxy parent objects.

	parent_redefine_list: LINKED_LIST [TUPLE [orignial_feature_name, original_feature_alias_name: STRING; parent_object: SCOOP_PROXY_PARENT_OBJECT ]]
			-- List of redefine features with corresponding parent object.

invariant
	proxy_parent_objects_not_void: proxy_parent_objects /= Void

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

end -- class SCOOP_WORKBENCH_OBJECTS
