note
	description: "Summary description for {AFX_FIX_OPERATION_INSERTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_OPERATION_INSERTION

inherit
	AFX_FIX_OPERATION_I

	ES_FEATURE_TEXT_AST_MODIFIER
		rename
		    make as make_modifier,
		    prepare as prepare_modifier
		end


create
    make

feature	-- Creation

    make (a_code: STRING)
    		-- initialize
    	require
    	    code_not_empty: not a_code.is_empty
    	do
			code := a_code
    	end

feature -- Access

	code: STRING

	apply_operation (a_position: AFX_EXCEPTION_POSITION)
			-- <Precursor>
		local
		    l_fix_position: AST_EIFFEL
		    l_ast_position: TUPLE [start_position: INTEGER; end_position: INTEGER]
		    l_start_position: INTEGER
		do
			l_fix_position := a_position.fix_position

		end

    fix_code_before (an_id: INTEGER): STRING
    		-- <Precursor>
    	do
		    Result := "if (create {AFX_FIX_SELECTION_ARBITOR}).is_fix_active(" + an_id.out + ") then%N"
		    			 + "%T" + code + "%N"
		    			 + "end%N"
    	end

    fix_code_after (an_id: INTEGER): STRING
    		-- <Precursor>
    	do
			Result := ""
    	end

	prepare
			-- <Precursor>
		do
		end

	operation_report: STRING
			-- <Precursor>
		do
		    Result := "<Insert>: " + code
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
