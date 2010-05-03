note
	description: "Context factory."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CONTEXT_FACTORY
inherit
	ETR_WORKBENCH_OPERATIONS

feature -- New

	new_class_context (a_name: STRING): ETR_CLASS_CONTEXT
			-- Returns the context in the class with `a_name'
		require
			system_defined: system_defined
			non_void: a_name /= void
		local
			l_cls: CLASS_C
		do
			l_cls := compiled_class_with_name (a_name)

			if l_cls /= void then
				create Result.make(l_cls)
			end
		end

	new_feature_context (a_classname, a_featurename: STRING): ETR_FEATURE_CONTEXT
				-- Returns the context in the feature `a_featurename' in the class with `a_classname'
		require
			system_defined: system_defined
			non_void: a_classname /= void and a_featurename /= void
		local
			l_class: CLASS_C
			l_feat: FEATURE_I
		do
			l_class := compiled_class_with_name (a_classname)
			l_feat := l_class.feature_named (a_featurename)
			create Result.make (l_feat, create {ETR_CLASS_CONTEXT}.make(l_class))
		end

	new_empty_context: ETR_CONTEXT
			-- Returns a new empty context
		do
			create Result.make_empty
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
