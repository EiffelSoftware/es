note
	description: "Summary description for {AFX_FIX_POSITION_LOCATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_POSITION_LOCATOR

inherit
	AST_ITERATOR
		redefine
		    	-- instructions
			process_assign_as,
			process_assigner_call_as,
			process_creation_as,
			process_instr_call_as,
			process_check_as,

				-- constructs
			process_if_as,
			process_inspect_as,
			process_loop_as

				-- lists of `INSTRUCTION_AS'es do not need special process
			-- process_debug_as,
			-- else part of if	
		end

feature -- Access

	last_found: detachable AST_EIFFEL
			-- result of last locate operation

	modifier: AFX_FIX_WRITER
			-- modifier

	target_ast: detachable AST_EIFFEL
			-- target ast to locate

	absolute_fix_positions: TUPLE [absolute_start_position: INTEGER; absolute_end_position: INTEGER]
			-- absolute fix position associated with the fix position, if `last_found /= Void'

feature -- Operation

	locate_fix_position (a_modifier: AFX_FIX_WRITER; a_target: AST_EIFFEL)
			-- locate `a_target' in `a_context' and put the result in `last_found', if found
		require
		    modifier_ast_available: a_modifier.is_ast_available
		do
		    last_found := Void
		    modifier := a_modifier
		    target_ast := a_target
		    create absolute_fix_positions

		    safe_process (modifier.ast)
		end

feature{NONE} -- Implementation

	is_same_as_target (l_as: AST_EIFFEL): BOOLEAN
			-- if `l_as' is same as `target_ast'
		do
		    Result := target_ast.equivalent (l_as, target_ast)
		    		and then target_ast.start_position = l_as.start_position
		    		and then target_ast.end_position = l_as.end_position
		end

	check_position_and_update (a_as: AST_EIFFEL)
			-- check if `a_as' is the target ast we are looking for, record `last_found' if yes.
		local
		    l_modifier: AFX_FIX_WRITER
		    l_ast_post: attached TUPLE [start_position: INTEGER; end_position: INTEGER]
		    l_start_pos, l_end_pos: INTEGER
		    l_leading_ws, l_tailing_ws: STRING_32
		do
			if last_found = Void and then is_same_as_target (a_as) then
		    	last_found := a_as
		    	l_modifier := modifier

    		    l_ast_post := l_modifier.ast_position (a_as)
    		    l_start_pos := l_ast_post.start_position
    		    l_end_pos := l_ast_post.end_position

    				-- insert the fix in front of current line
    			l_leading_ws := l_modifier.initial_whitespace (l_start_pos)
    			absolute_fix_positions.absolute_start_position := l_start_pos - l_leading_ws.count

					-- insert the fix after the current line
				l_tailing_ws := l_modifier.tailing_whitespace (l_end_pos)
				absolute_fix_positions.absolute_end_position := l_end_pos - l_tailing_ws.count
			end
		end

feature{NONE} -- Process

	process_assign_as (l_as: ASSIGN_AS)
		do
		    check_position_and_update (l_as)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
		    check_position_and_update (l_as)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
		    check_position_and_update (l_as)
		end

	process_creation_as (l_as: CREATION_AS)
		do
		    check_position_and_update (l_as)
		end

	process_check_as (l_as: CHECK_AS)
			-- no fix inside a check construct
		do
		    check_position_and_update (l_as)
		end

feature{NONE} -- Process constructs

	process_if_as (l_as: IF_AS)
		do
		    check_position_and_update (l_as)

			Precursor(l_as)
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
		    check_position_and_update (l_as)

			Precursor(l_as)
		end

	process_loop_as (l_as: LOOP_AS)
			-- in case a fix position ast is of type `LOOP_AS', the exception was inside until-part or inv/var-part
			-- thus the fix should be either after the from-part or after the body-part
		local
		    l_modifier: AFX_FIX_WRITER
		    l_from_part: EIFFEL_LIST [INSTRUCTION_AS]
		    l_compound: EIFFEL_LIST [INSTRUCTION_AS]
		    l_ast_post: attached TUPLE [start_position: INTEGER; end_position: INTEGER]
		    l_end_pos: INTEGER
		    l_tailing_ws: STRING_32
		do
			if last_found = Void and then is_same_as_target (l_as) then
		    	last_found := l_as
		    	l_modifier := modifier

		    	l_from_part := l_as.from_part
		    	l_compound := l_as.compound

					-- process from part.
					-- 		Attention: result in `absolute_start_position'
    		    l_ast_post := l_modifier.ast_position (l_from_part)
    		    l_end_pos := l_ast_post.end_position
				l_tailing_ws := l_modifier.tailing_whitespace (l_end_pos)
				absolute_fix_positions.absolute_start_position := l_end_pos - l_tailing_ws.count

					-- process from part.
					-- 		Attention: result in `absolute_end_position'
    		    l_ast_post := l_modifier.ast_position (l_compound)
    		    l_end_pos := l_ast_post.end_position
				l_tailing_ws := l_modifier.tailing_whitespace (l_end_pos)
				absolute_fix_positions.absolute_end_position := l_end_pos - l_tailing_ws.count
			end

			Precursor(l_as)
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
