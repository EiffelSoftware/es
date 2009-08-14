note
	description: "Summary description for {AFX_SIMPLE_FIX_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SIMPLE_FIX_INFO

inherit
	AFX_FIX_INFO_I

create
    make

feature -- Access

    make (a_position: like exception_position; an_op: like fix_operation)
    		-- Initialization
    	do
			exception_position := a_position
			fix_operation := an_op

			set_id
    	end

feature --Access

	exception_position: AFX_EXCEPTION_POSITION
			-- the position where this fix should be applied

	fix_operation: AFX_FIX_OPERATION_I
			-- the fix operation

feature -- Operation

	involved_classes: DS_LINEAR [CLASS_C]
			-- <Precursor>
		do
		    create {DS_ARRAYED_LIST[CLASS_C]}Result.make (5)
		end

	apply_fix (a_writer: AFX_FIX_WRITER)
			-- <Precursor>
		local
		    l_fix_position: AST_EIFFEL
		    l_ast_post: attached TUPLE [start_position: INTEGER; end_position: INTEGER]
		    l_start_pos, l_end_pos: INTEGER
		    l_leading_ws: STRING_32
		    l_fix_code_before, l_fix_code_after: STRING
		do
		    l_fix_position := exception_position.fix_position
		    check l_fix_position /= Void end

		    l_ast_post := a_writer.ast_position (l_fix_position)
		    l_start_pos := l_ast_post.start_position
		    l_end_pos := l_ast_post.end_position

				-- insert the fix in front of current line
			l_leading_ws := a_writer.initial_whitespace (l_start_pos)
			l_start_pos := l_start_pos - l_leading_ws.count

			l_fix_code_before := fix_operation.fix_code_before (id)
			l_fix_code_after := fix_operation.fix_code_after (id)

				-- apply fixing code to the class
			if not l_fix_code_before.is_empty then
				a_writer.insert_code (l_start_pos, l_fix_code_before)
			end
			if not l_fix_code_after.is_empty then
			    a_writer.insert_code (l_end_pos, l_fix_code_after)
			end

		end

	fix_report: STRING
			-- <Precursor>
		do
		    Result := exception_position.position_report + " " + fix_operation.operation_report
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
