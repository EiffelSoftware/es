note
	description: "Summary description for {AUT_AST_TYPE_OUTPUT_STRATEGY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_AST_TYPE_OUTPUT_STRATEGY

inherit
	AST_TYPE_OUTPUT_STRATEGY
		redefine
			process_like_feature,
			process_like_current,
			process_like_argument
		end

feature -- Process

	process_like_feature (a_type: LIKE_FEATURE)
			-- Process `a_type'.
--		local
--			l_feat: E_FEATURE
		do
--			if a_type.has_attached_mark then
--				text_formatter.process_keyword_text (ti_attached_keyword, Void)
--				text_formatter.add_space
--			elseif a_type.has_detachable_mark then
--				text_formatter.process_keyword_text (ti_detachable_keyword, Void)
--				text_formatter.add_space
--			end
--			text_formatter.process_keyword_text (ti_like_keyword, Void)
--			text_formatter.add_space
--			l_feat := current_class.feature_with_rout_id (a_type.routine_id)
--			check
--				l_feat_not_void: l_feat /= Void
--			end
--			text_formatter.add_feature (l_feat, l_feat.name)
			a_type.actual_type.process (Current)
		end

	process_like_current (a_type: LIKE_CURRENT)
			-- Process `a_type'.
		do
			a_type.actual_type.process (Current)
--			if a_type.has_attached_mark then
--				text_formatter.process_keyword_text (ti_attached_keyword, Void)
--				text_formatter.add_space
--			elseif a_type.has_detachable_mark then
--				text_formatter.process_keyword_text (ti_detachable_keyword, Void)
--				text_formatter.add_space
--			end
--			text_formatter.process_keyword_text (ti_like_keyword, Void)
--			text_formatter.add_space
--			text_formatter.process_keyword_text (ti_current, Void)
		end

	process_like_argument (a_type: LIKE_ARGUMENT)
			-- Process `a_type'.
		do
			a_type.actual_type.process (Current)
--			if a_type.has_attached_mark then
--				text_formatter.process_keyword_text (ti_attached_keyword, Void)
--				text_formatter.add_space
--			elseif a_type.has_detachable_mark then
--				text_formatter.process_keyword_text (ti_detachable_keyword, Void)
--				text_formatter.add_space
--			end
--			text_formatter.process_keyword_text (ti_like_keyword, Void)
--			text_formatter.add_space
--			if current_feature /= Void and then current_feature.argument_count <= a_type.position then
--				text_formatter.process_local_text (current_feature.arguments.item_name (a_type.position))
--			else
--				text_formatter.add (ti_argument_index)
--				text_formatter.add_int (a_type.position)
--			end
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
