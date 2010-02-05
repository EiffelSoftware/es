note
	description: "Refactoring that creates a setter for an attribute"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_CREATE_SETTER

inherit
	ERF_ETR_REFACTORING
		redefine
			refactor,
			ask_run_settings
		end

	SHARED_WORKBENCH
		export
			{NONE} all
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end

	SHARED_ERROR_HANDLER

	ETR_SHARED_AST_TOOLS
	ETR_SHARED_OPERATORS

create
	make

feature -- Status

	feature_set: BOOLEAN
			-- Has the the feature to pull been set?
		do
			Result := feature_i /= Void
		end

feature -- Element change

	set_feature (a_feature: FEATURE_I)
			-- The feature that get's pulled.
		require
			a_feature_not_void: a_feature /= Void
		do
			feature_i := a_feature
		ensure
			feature_set_correct: feature_set and feature_i = a_feature
		end

feature {NONE} -- Implementation

	feature_i: FEATURE_I
			-- The feature to pull.

	ask_run_settings
            -- Ask for the settings, that are run specific.
		require else
			feature_set: feature_set
        do
			retry_ask_run_settings := true
        end

	refactor
			-- Do the refactoring changes.
		require else
			feature_set: feature_set
		local
			l_feat_ast: FEATURE_AS
			l_matchlist: LEAF_AS_LIST
			l_written_class: CLASS_C
			l_class_modifier: ERF_CLASS_TEXT_MODIFICATION
			l_transformable: ETR_TRANSFORMABLE
			l_append_text: STRING
			l_brk_text: STRING
			l_region_start_index, l_region_end_index: INTEGER
			l_replacement_region: ERT_TOKEN_REGION
		do
			success := true
			etr_error_handler.reset_errors

			l_feat_ast := feature_i.e_feature.ast
			l_written_class := feature_i.written_class
			l_matchlist := system.match_list_server.item (l_written_class.class_id)

			create l_transformable.make_in_class (l_feat_ast, l_written_class)

			setter_generator.generate_setter (l_transformable)

			if not etr_error_handler.has_errors then
				-- Get the trailing break text
				create l_brk_text.make_empty
				if l_feat_ast.break_included then
					l_region_start_index := l_feat_ast.last_token (l_matchlist).index
					l_brk_text := l_matchlist.i_th (l_region_start_index).text (l_matchlist)
					l_brk_text := ast_tools.remove_ending_indentation (l_brk_text, '%T')
				elseif l_feat_ast.has_trailing_separator (l_matchlist) then
					l_region_start_index := l_feat_ast.last_token (l_matchlist).index+1
					l_brk_text := l_matchlist.i_th (l_region_start_index).text (l_matchlist)
					l_brk_text := ast_tools.remove_ending_indentation (l_brk_text, '%T')
				else
					l_brk_text := "%N"
				end

				l_append_text := l_brk_text

				if not l_append_text.ends_with ("%N%N") then
					if l_append_text.ends_with ("%N") then
						l_append_text.append ("%N")
					else
						l_append_text.append ("%N%N")
					end
				end

				l_append_text.append	(	ast_tools.commented_feature_to_string (
												setter_generator.transformation_result.target_node,
												" Set `"+feature_i.feature_name+"' to `a_"+feature_i.feature_name+"'",
												1)
										)
				l_append_text.append("%N")

				create l_replacement_region.make (l_region_start_index, l_region_start_index)
				l_matchlist.replace_region (l_replacement_region, l_append_text)


				create l_class_modifier.make (l_written_class.original_class)
				l_class_modifier.prepare
				l_class_modifier.set_changed_text (l_matchlist.all_modified_text)
				l_class_modifier.commit
	        	current_actions.extend (l_class_modifier)
			else
	        	show_etr_error
	        	success := false
	        	error_handler.wipe_out
			end
		rescue
			show_etr_error
			success := false
			error_handler.wipe_out
		end

note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
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
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
