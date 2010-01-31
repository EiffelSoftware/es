note
	description: "[
		A frame in the exception trace.
		
		For some external routines, the breakpoint slot index info is missing from the trace (in this case, `a_breakpoint_slot' = 0)
		We allow an exception position object to be created, just to keep the sequence of the call stack,
		but these frames will be marked as irrelevant.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXCEPTION_CALL_STACK_FRAME

inherit

    AFX_EXCEPTION_CALL_STACK_FRAME_I

	SHARED_WORKBENCH

create
    make

feature -- Creation

	make (a_class_name, a_origin_class_name, a_routine_name, a_tag, a_nature: STRING_8;
				a_breakpoint_slot_index: INTEGER)
			-- initialize
		require
		    class_name_not_empty: not a_class_name.is_empty
		    routine_name_not_empty: not a_routine_name.is_empty
		    breakpoint_slot_index_valid_or_zero: a_breakpoint_slot_index >= 0
		do
			context_class_name := a_class_name
			if not a_origin_class_name.is_empty then
				origin_class_name := a_origin_class_name
			else
			    origin_class_name := context_class_name
			end
			feature_name := a_routine_name
			tag := a_tag
			nature_of_exception := a_nature
			breakpoint_slot_index := a_breakpoint_slot_index

			is_relevant := True
		end

feature -- status report

	is_relevant: BOOLEAN assign set_relevant
			-- <Precursor>

	is_resolved: BOOLEAN
			-- <Precursor>
		do
		    Result := is_information_complete and then origin_feature /= Void and then (breakpoint_slot_index /= 0 implies breakpoint_info /= Void)
		end

feature -- Access

	context_class_name: detachable STRING_8
			-- <Precursor>

	origin_class_name: detachable STRING_8
			-- <Precursor>

	feature_name: detachable STRING_8
			-- <Precursor>

	breakpoint_slot_index: INTEGER
			-- <Precursor>

	tag: STRING
			-- <Precursor>

	nature_of_exception: STRING
			-- <Precursor>

	nested_breakpoint_slot_index: INTEGER
			-- <Precursor>

	context_class: detachable CLASS_C
			-- <Precursor>

	origin_class: detachable CLASS_C
			-- <Precursor>

	origin_feature: detachable FEATURE_I
			-- <Precursor>

	breakpoint_info: detachable DBG_BREAKABLE_POINT_INFO assign set_breakpoint_info
			-- <Precursor>

feature -- Set status

	set_relevant (an_is_relevant: BOOLEAN)
			-- <Precursor>
		do
		    is_relevant := an_is_relevant
		end

feature{AFX_EXCEPTION_POSITION_RESOLVER_I} --Setting

	set_context_class (a_class: like context_class)
			-- <Precursor>
		do
		    context_class := a_class
		end

	set_origin_class (a_class: like origin_class)
			-- <Precursor>
		do
		    origin_class := a_class
		end

	set_origin_feature (a_context: like origin_feature)
			-- <Precursor>
		do
		    origin_feature := a_context
		end

	set_breakpoint_info (an_info: like breakpoint_info)
			-- <Precursor>
		do
		    breakpoint_info := an_info
		end

feature -- Operating

--	resolve_exception_position_info
--			-- <Precursor>
--		do
--			resolve_e_feature
--			resolve_breakpoint_info
--		end

--feature{NONE} -- Implementation

--	resolve_e_feature
--			-- resolve e_feature
--		require
--		    is_information_complete: is_information_complete
--		local
--		    l_system: SYSTEM_I
--		    l_list_class_i: LIST [CLASS_I]
--		    l_set_class_c: ARRAYED_SET[CLASS_C]
--		    l_class_c: CLASS_C
--		do
--		    l_system := Workbench.system

--		    	-- resolve class_c according to class_name
--		    l_list_class_i := l_system.system.universe.compiled_classes_with_name(context_class_name)
--		    create l_set_class_c.make (l_list_class_i.count)
--		    l_set_class_c.compare_objects
--		    from
--		        l_list_class_i.start
--		    until
--		        l_list_class_i.after
--		    loop
--		        if attached {CLASS_C} l_list_class_i.item_for_iteration.actual_class.compiled_class as l_class then
--		            l_set_class_c.put (l_class)
--		        end
--		        l_list_class_i.forth
--		    end

--		    -- TODO: check the situations where several classes are found having the same name
--		    --		 and select the proper class

--				-- resolve e_feature according to class_c and feature_name
--			check not l_set_class_c.is_empty end
--	        l_set_class_c.start
--	        l_class_c := l_set_class_c.item

--			origin_class := l_class_c
--			origin_feature := l_class_c.feature_named (feature_name)

--			check origin_feature /= Void end
--		ensure
--		    e_feature_resolved: origin_feature /= Void
--		end

--	resolve_breakpoint_info
--			-- resolve the `breakpoint_info' according to `breakpoint_slot'
--			-- TODO: breakpoint in inherited contracts
--		require
--		    is_information_complete: is_information_complete
--		    e_feature_resolved: origin_feature /= Void
--		local
--		    l_points: ARRAYED_LIST [DBG_BREAKABLE_POINT_INFO]
--		do
--				-- search the breakable points until we find a match
--			if attached debugger_ast_server.breakable_feature_info (origin_feature.e_feature) as l_breakable_info then
--    		    l_points := l_breakable_info.points
--		        from
--		            l_points.start
--		        until
--		            l_points.after or breakpoint_info /= Void
--		        loop
--		            if attached l_points.item as l_point then
--		                if l_point.bp = breakpoint_slot_index then
--		                    	-- we do not differentiate nested breakpoints, since we don't have nested breakpoint slot index from the exception trace.
--		                    	-- Here, we just get the information of the first breakpoint slot with given index.
--		                    	-- As a result, instructions would be the level where we work
--		                    set_breakpoint_info (l_point)
--		                end
--		            end
--		            l_points.forth
--    		    end
--			end

--			check breakpoint_info_resolved: breakpoint_info /= Void end
--		ensure
--		    breakpoint_info_resolved: breakpoint_info /= Void
--		end

	debugger_ast_server: DEBUGGER_AST_SERVER
			-- server to visit debugger's data from AST
		once
		    create Result.make(10)
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
