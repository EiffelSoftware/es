note
	description: "Summary description for {AFX_FIXING_TARGET_COLLECTOR_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FIXING_TARGET_COLLECTOR_I

feature -- Access

	context_feature: detachable E_FEATURE
			-- feature where the collecting is done
		deferred
		end

	fix_position: detachable AST_EIFFEL
			-- position in the feature when fix would be applied.
			-- this position also constrains the accessible fixing targets
		deferred
		end

	last_collection: HASH_TABLE [AFX_FIXING_TARGET_I, STRING]
			-- result of last collecting process
		deferred
		end

feature -- Status report

	is_setting_valid (a_feature: like context_feature; a_position: like fix_position): BOOLEAN
			-- are the argument valid for collecting?
		deferred
		end

feature -- Operation

	collect_fixing_targets (a_feature: like context_feature; a_position: like fix_position)
			-- start collecting
		require
		    setting_valid: is_setting_valid (a_feature, a_position)
		deferred
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
