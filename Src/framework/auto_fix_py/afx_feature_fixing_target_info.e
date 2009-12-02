note
	description: "Summary description for {AFX_FEATURE_FIXING_TARGET_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FEATURE_FIXING_TARGET_INFO

create
    make

feature -- Initialization

	make (a_feature: like context_feature; ot_targets, loc_targets, arg_targets, att_targets: like local_variable_targets)
			-- initialize a new object
		do
		    context_feature := a_feature
		    object_test_targets := ot_targets
		    local_variable_targets := loc_targets
		    argument_targets := arg_targets
		    attribute_targets := att_targets
		end

feature -- Access

	context_feature: E_FEATURE
			-- the feature associated with the targets

	object_test_targets: like local_variable_targets assign set_object_test_targets
			-- set of targets which are object test local variables

	local_variable_targets: HASH_TABLE [AFX_FIXING_TARGET_I, STRING] assign set_local_variable_targets
			-- set of targets which are local variables

	argument_targets: like local_variable_targets assign set_argument_targets
			-- set of targets which are arguments

	attribute_targets: like local_variable_targets assign set_attribute_targets
			-- set of targets which are attributes

	found_target: detachable AFX_FIXING_TARGET_I
			-- result of last `has_target', if found

feature -- Status report

	has_target (a_name: STRING): BOOLEAN
			-- is there a target with the name `a_name'?
		require
		    name_not_empty: not a_name.is_empty
		do
		    a_name.to_lower
		    found_target := Void

		    if found_target = Void and then local_variable_targets.has_key (a_name) then found_target := local_variable_targets.found_item end
		    if found_target = Void and then argument_targets.has_key (a_name) then found_target := argument_targets.found_item end
		    if found_target = Void and then object_test_targets.has_key (a_name) then found_target := object_test_targets.found_item end
		    if found_target = Void and then attribute_targets.has_key (a_name) then found_target := attribute_targets.found_item end

			Result := found_target /= Void
		end

feature -- Setting

	set_local_variable_targets (a_table: like local_variable_targets)
		do
		    local_variable_targets := a_table
		end

	set_argument_targets (a_table: like argument_targets)
		do
		    argument_targets := a_table
		end


	set_object_test_targets (a_table: like object_test_targets)
		do
		    object_test_targets := a_table
		end


	set_attribute_targets (a_table: like attribute_targets)
		do
		    attribute_targets := a_table
		end


note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
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
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
