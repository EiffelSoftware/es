note
	description: "[
		TODO: how can we integrate the fixes with the code? If the feature is a inherited one, which class should we apply the fixes to?
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_POSITION

create
    make

feature -- Initialization

	make (an_exception_position: like exception_position; an_ast_position: AST_EIFFEL)
			-- initialize a new object
		do
		    exception_position := an_exception_position
		    ast_position := an_ast_position
		    create absolute_position
		end

feature -- Access

	exception_position: AFX_EXCEPTION_CALL_STACK_FRAME_I
			-- corresponding exception position

	fixing_targets: DS_LINEAR [AFX_FIXING_TARGET_I]
			-- fixing targets at current fix position
		do
		    if internal_fixing_targets = Void then
		        create internal_fixing_targets.make_default
		    end

		    Result := internal_fixing_targets
		end

	ast_position: AST_EIFFEL
			-- position in the ast, on which the fix should be applied

	absolute_position: TUPLE[start_position: INTEGER; end_position: INTEGER]
			-- positions in the class text, where fix should be applied.

feature -- Access (position report)

	text: STRING
			-- original text at this position.

	line_no: INTEGER
			-- original starting line in the file.

	last_position_report: STRING
			-- result of last `build_position_report'

feature -- Status report

	is_absolute_position_resolved: BOOLEAN
			-- are the absolute positions resolved?
		do
		    Result := last_modifier /= Void
						and then absolute_position.start_position > 0
						and then absolute_position.end_position > 0
		end

feature -- Operation

	register_fixing_targets (a_target_list: HASH_TABLE [AFX_FIXING_TARGET_I, STRING])
			-- register the targets
		do
		    if internal_fixing_targets = Void then
		        create internal_fixing_targets.make (a_target_list.count)
		    end

		    from a_target_list.start
		    until a_target_list.after
		    loop
		        internal_fixing_targets.force_last (a_target_list.item_for_iteration)

		        a_target_list.forth
		    end
		ensure
		    internal_fixing_targets_not_void: internal_fixing_targets /= Void
			internal_fixing_targets_set: internal_fixing_targets.count >= a_target_list.count
		end

	update_absolution_fix_position (a_modifier: AFX_FIX_WRITER)
			-- update the absolute fix position in `a_modifier'
		require
--		    same_class_name: exception_position.class_name ~ a_modifier.context_class.name
		    ast_available: a_modifier.is_ast_available
		local
		    l_locator: AFX_FIX_POSITION_LOCATOR
		    l_text: STRING
		    l_index: INTEGER
		do
			if a_modifier = last_modifier
						and then absolute_position.start_position > 0
						and then absolute_position.end_position > 0 then
			    	-- do nothing, already up-to-date
			else
			    last_modifier := a_modifier

			    	-- update absolute positions of `ast_position' in `a_modifier'
			    create l_locator
			    l_locator.locate_fix_position (a_modifier, ast_position)
			    if l_locator.last_found /= Void then
					absolute_position.start_position := l_locator.absolute_fix_positions.absolute_start_position
					absolute_position.end_position := l_locator.absolute_fix_positions.absolute_end_position

						-- update info for report
					l_text := l_locator.last_found.text (a_modifier.ast_match_list).twin
					from l_index := 1 until l_index > l_text.count
					loop
					    if l_text.at (l_index).is_space then l_text.put (' ', l_index) end
					    l_index := l_index + 1
					end
					l_text.prune_all_leading (' ')
					l_text.prune_all_trailing (' ')
					l_text := l_text.substring (1, l_text.count.min (20))
					l_text.append (" ... ")
					text := l_text
					line_no := ast_position.complete_start_location (a_modifier.ast_match_list).line
				else
				    	-- report error
			    end
			end
		ensure
		    valid_absolute_position: absolute_position.start_position > 0 and then absolute_position.end_position > 0
		end

	build_position_report
			-- build position report for users
		require
		    valid_line_no: line_no > 0
		    text_not_empty: not text.is_empty
		local
		    l_report: STRING
		do
		    create l_report.make_empty
		    l_report.append (exception_position.origin_class_name + "(")
		    l_report.append (line_no.out + ")")
		    l_report.append (": " + text)
		    last_position_report := l_report
		end

feature{NONE} -- Implementation

	last_modifier: detachable AFX_FIX_WRITER
			-- last modifier, against which were the absolute positions checked

	internal_fixing_targets: detachable DS_ARRAYED_LIST [AFX_FIXING_TARGET_I]
			-- internal storage for the fixing targets

;note
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
