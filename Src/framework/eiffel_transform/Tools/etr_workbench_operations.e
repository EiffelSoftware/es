note
	description: "Operations in an active Eiffel workbench."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_WORKBENCH_OPERATIONS
inherit
	SHARED_SERVER
		export
			{NONE} all
		end

	INTERNAL_COMPILER_STRING_EXPORTER

feature -- Access

	system_defined: BOOLEAN
			-- Is there a system (Eiffel-project) loaded
		do
			Result := workbench.system_defined
		end

feature {NONE} -- Implementation

	compiled_class_with_name (a_name: STRING): detachable CLASS_C
			-- Returns the compiled class with `a_name' if it exists
		require
			system_defined: system_defined
			non_void: a_name /= void
		local
			l_classlist: LIST[CLASS_I]
		do
			l_classlist := universe.compiled_classes_with_name(a_name)
			if l_classlist /= void and then not l_classlist.is_empty then
				Result := l_classlist.first.compiled_class
			end
		end

	feature_of_compiled_class(a_classname, a_featurename: STRING): detachable FEATURE_I
			-- Returns the feature `a_featurename' of class `a_classname'
		require
			system_defined: system_defined
			non_void: a_classname /= void and a_featurename /= void
		local
			l_cls: CLASS_C
			l_feat: FEATURE_I
		do
			l_cls := compiled_class_with_name(a_classname)

			if l_cls /= void then
				l_feat := l_cls.feature_named (a_featurename)

				if l_feat /= void and then l_feat.e_feature /= void then
					Result := l_feat
				end
			end
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
