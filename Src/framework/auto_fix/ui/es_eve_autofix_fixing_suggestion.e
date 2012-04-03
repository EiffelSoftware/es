note
	description: "Summary description for {ES_EVE_AUTOFIX_FIXING_SUGGESTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EVE_AUTOFIX_FIXING_SUGGESTION

inherit
	ES_EVE_CODE_DIFF_HUNK
		rename make as make_hunk end

create
	make

feature {NONE} -- Initialize

	make (a_index: INTEGER; a_parent: ES_EVE_AUTOFIX_RESULT; a_context_class: CLASS_C; a_context_feature: FEATURE_I; a_base_code, a_diff_code: STRING)
			-- Initialization.
		require
			positive_index: a_index > 0
			parent_attached: a_parent /= VOid
			context_attached: a_context_class /= Void and then a_context_feature /= VOid
			code_attached: a_base_code /= Void and then a_diff_code /= Void
		local
			l_new_base, l_new_diff: STRING
		do
			l_new_base := a_base_code.substring (1, a_base_code.last_index_of ('d', a_base_code.count))
			l_new_base.append (" -- routine")
			l_new_diff := a_diff_code.substring (1, a_diff_code.last_index_of ('d', a_diff_code.count))
			l_new_diff.append (" -- routine")
			make_hunk (a_context_class, l_new_base, l_new_diff)
			index := a_index
			parent := a_parent
			context_feature := a_context_feature
		end

feature -- Access

	context_feature: FEATURE_I
			-- Context feature.

	index: INTEGER
			-- Index of the fix.

	parent: ES_EVE_AUTOFIX_RESULT
			-- AutoFix result containing the suggestion.

	short_summary_text: STRING
			-- Short summary text.
		do
			if parent /= Void and then parent.fix_index_applied = index then
				Result := "Fix_" + index.out + " (Applied)"
			else
				Result := "Fix_" + index.out
			end
		end

feature -- Basic operation

	apply
			-- Apply the fixing suggestion.
		do
			parent.apply_fix (Current)
		end


invariant

	parent_not_void: parent /= Void
	positive_index:  index > 0

;note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
