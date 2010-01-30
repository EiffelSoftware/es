note
	description: "Summary description for {ERF_EXTRACT_METHOD_CHECK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_EXTRACT_METHOD_CHECK

inherit
	ERF_CHECK
	SHARED_SERVER
	ETR_SHARED_PATH_TOOLS

create
	make

feature {NONE} -- Initialization

	make (a_refactorer: like refactorer; a_class: like class_c; a_start_line: like start_line; a_end_line: like end_line)
			-- Create a check
		require
			a_class_not_void: a_class /= Void
		do
			class_c := a_class
			start_line := a_start_line
			end_line := a_end_line
			refactorer := a_refactorer
		end

feature -- Basic operation

	execute
            -- Execute a check.
        local
			l_matchlist: LEAF_AS_LIST
			l_class_ast: CLASS_AS
			l_start_path, l_end_path: AST_PATH
			l_context: ETR_CONTEXT
			l_feat_transformable: ETR_TRANSFORMABLE
			l_feat_ast: AST_EIFFEL
			l_orig_feat: AST_EIFFEL
			l_written_feature: FEATURE_I
			l_target_feature_name: STRING
		do
			success := True

			-- Get the compiled class and feature
			l_matchlist := match_list_server.item (class_c.class_id)
			l_class_ast := class_c.ast

			-- Get current feature from line number
			l_target_feature_name := path_tools.feature_from_line (l_class_ast, l_matchlist, start_line)

			if l_target_feature_name = void then
				success := False
				error_message := "Start line is not in a feature"
			end

			if success then
				l_written_feature := class_c.feature_named (l_target_feature_name)
				l_orig_feat := l_written_feature.e_feature.ast

				-- Create a transformable
				create {ETR_FEATURE_CONTEXT}l_context.make (l_written_feature, void)
				create l_feat_transformable.make_from_ast (l_orig_feat, l_context, true)
				l_feat_ast := l_feat_transformable.target_node

				-- Convert line numbers to paths
				l_start_path := path_tools.path_from_line (l_orig_feat, l_matchlist, start_line)
				if l_start_path = void then
					success := False
					error_message := "Invalid start path"
				else
					l_start_path.set_root (l_feat_ast)

					l_end_path := path_tools.path_from_line (l_orig_feat, l_matchlist, end_line)

					if l_end_path = void then
						success := False
						error_message := "Invalid end path"
					else
						l_end_path.set_root (l_feat_ast)
					end
				end
			end

			if success then
				if not l_start_path.parent_path.is_equal (l_end_path.parent_path) then
					success := False
					error_message := "Line numbers are not in the same instruction-block"
				elseif start_line>end_line then
					success := False
					error_message := "End-line is before start-line"
				else
					refactorer.set_end_path (l_end_path)
					refactorer.set_start_path (l_start_path)
					refactorer.set_transformable (l_feat_transformable)
				end
			end
        end

feature {NONE} -- Implementation

	refactorer: ERF_EXTRACT_METHOD
			-- The refactoring engine

	class_c: CLASS_C
			-- The class to check.

	start_line: INTEGER
			-- The start line

	end_line: INTEGER
			-- The end line


invariant
	class_not_void: class_c /= Void
	refactorer_not_void: refactorer /= void
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
