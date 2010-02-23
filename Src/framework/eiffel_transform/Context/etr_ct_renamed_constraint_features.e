note
	description: "Respresents renamings in constraints to be used by ETR_CONTEXT_TRANSFORMER"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CT_RENAMED_CONSTRAINT_FEATURES
create {ETR_TRANSFORM_CONTEXT}
	make

feature  -- Access

	feature_name: STRING
			-- Name of the target feature

	source_renaming, target_renaming: detachable RENAMING_A
			-- Renamings in the source and target context

feature {NONE} -- Creation

	make(a_feature_name: like feature_name; a_source_renaming: like source_renaming; a_target_renaming: like target_renaming)
			-- make with `feature_name', `a_source_renaming' and `a_target_renaming'
		require
			name_non_void: a_feature_name /= void
			one_set: a_source_renaming /= void or a_target_renaming /= void
		do
			feature_name := a_feature_name
			source_renaming := a_source_renaming
			target_renaming := a_target_renaming
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
