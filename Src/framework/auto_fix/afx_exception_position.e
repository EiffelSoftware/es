note
	description: "Summary description for {AFX_EXCEPTION_POSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXCEPTION_POSITION

inherit

	ES_FEATURE_TEXT_AST_MODIFIER
		rename
		    make as make_modifier,
		    prepare as prepare_modifier
		end

    AFX_SHARED_SESSION

    SHARED_TEST_SERVICE

    SHARED_AFX_FIX_REPOSITORY

create
    make

feature -- Creation

	make (a_class_name, a_routine_name: READABLE_STRING_8; a_breakpoint_slot: INTEGER)
			-- initialize
			-- Note: for some external routines, the breakpoint slot index info is missing from the trace.
			-- We allow an exception position object to be created, just to keep the sequence of the call stack,
			-- but these frames will be marked irrelevant later.
		require
		    class_name_not_empty: not a_class_name.is_empty
		    routine_name_not_empty: not a_routine_name.is_empty
		    breakpoint_slot_positive: a_breakpoint_slot >= 0
		do
			class_name := a_class_name
			routine_name := a_routine_name
			breakpoint_slot := a_breakpoint_slot

			create fix_operations.make_default
		end

feature -- status report

	is_relevant: BOOLEAN assign set_relevant
			-- should this position be considered when generating fixes?

	is_information_complete: BOOLEAN
			-- is information necessary for analysis complete?
		do
		    Result := (class_name /= Void and then not class_name.is_empty)
		    		and then (routine_name /= Void and then not routine_name.is_empty)
		end

	is_resolved: BOOLEAN
			-- is everything resolved successfully?
		require
		    is_relevant: is_relevant
		do
		    Result := e_feature /= Void and then breakpoint_info /= Void and then not relevant_objects.is_empty
		end

feature -- Access

	class_name: READABLE_STRING_8
			-- name of the class

	routine_name: READABLE_STRING_8
			-- name of the feature

	breakpoint_slot: INTEGER
			-- Index of the breakpoint where an exception was raised

	e_feature: detachable E_FEATURE
			-- E_FEATURE of the feature `class_name'.`feature_name'

	breakpoint_info: detachable DBG_BREAKABLE_POINT_INFO
			-- breakpoint information

	relevant_objects: HASH_TABLE[TYPE_A, STRING]
			-- relevant objects in the caller feature
		do
		    if relevant_objects_internal = Void then
		        create relevant_objects_internal.make(10)
		    end

		    Result := relevant_objects_internal
		end

	fix_position: detachable AST_EIFFEL assign set_fix_position
			-- the ast indicating the position where the fix to this exception should be applied

	fix_operations: DS_ARRAYED_LIST [ AFX_FIX_INFO_I]

feature -- Set status

	set_relevant (an_is_relevant: BOOLEAN)
			-- set if the position need to be examined during fixing
		do
		    is_relevant := an_is_relevant
		end

	set_fix_position (an_ast: AST_EIFFEL)
			-- set
		do
		    fix_position := an_ast
		end

feature -- Operation

	resolve_e_feature
			-- resolve e_feature
		local
		    l_test_suite: TEST_SUITE_S
		    l_list_class_i: LIST [CLASS_I]
		    l_list_class_c: ARRAYED_LIST[CLASS_C]
		    l_class_c: CLASS_C
		do
		    l_test_suite := test_suite.service

		    	-- resolve class_c according to class_name
		    l_list_class_i := l_test_suite.eiffel_project.system.system.universe.compiled_classes_with_name(class_name)
		    create l_list_class_c.make (l_list_class_i.count)
		    from
		        l_list_class_i.start
		    until
		        l_list_class_i.after
		    loop
		        if attached {CLASS_C} l_list_class_i.item_for_iteration.compiled_class as l_class then
		            l_list_class_c.force (l_class)
		        end
		        l_list_class_i.forth
		    end

		    -- TODO: check the situations where several classes are found having the same name
		    --		 and select the proper class

				-- resolve e_feature according to class_c and feature_name
	        l_class_c := l_list_class_c.at (1)
			e_feature := l_class_c.feature_with_name (routine_name)
		ensure
		    e_feature_resolved: e_feature /= Void
		end

	resolve_breakpoint_info
			-- resolve the `breakpoint_info' according to `breakpoint_slot'
			-- TODO: should we take into account also the nested breakpoint index?
		require
		    e_feature_resolved: e_feature /= Void
		    breakpoint_slot_valid: breakpoint_slot > 0
		local
		    l_points: ARRAYED_LIST [DBG_BREAKABLE_POINT_INFO]
		do
				-- search the breakable points until we find a match
			if attached debugger_ast_server.breakable_feature_info (e_feature) as l_breakable_info then
    		    l_points := l_breakable_info.points
		        from
		            l_points.start
		        until
		            l_points.after or breakpoint_info /= Void
		        loop
		            if attached l_points.item as l_point then
		                if l_point.bp = breakpoint_slot and l_point.bp_nested = 0 then
		                    breakpoint_info := l_point
		                end
		            end
		            l_points.forth
    		    end
			end
		ensure
		    breakpoint_info_resolved: breakpoint_info /= Void
		end

	collect_relevant_objects (a_callee_position: detachable AFX_EXCEPTION_POSITION)
			-- compute relevant objects at this fix position
		require
		    is_current_relevant: is_relevant
		    is_information_complete: is_information_complete
		    e_feature_not_void: e_feature /= Void
		    callee_ready: a_callee_position /= Void implies
		    					(a_callee_position.is_information_complete and a_callee_position.e_feature /= Void)
		local
		    l_caller_feature: E_FEATURE
		    l_callee_feature: detachable E_FEATURE
		    l_caller_ast: AST_EIFFEL
		    l_collector: AFX_AST_RELEVANT_OBJECT_COLLECTOR
		do
		    l_caller_feature := e_feature
		    if attached a_callee_position as l_position then
			    l_callee_feature := l_position.e_feature
			else
			    l_callee_feature := Void
		    end

		    l_caller_ast := breakpoint_info.ast
		    check l_caller_ast /= Void end

			create l_collector.make
			l_collector.collect_relevant_objects (l_caller_feature, l_callee_feature, l_caller_ast, relevant_objects)
		end

	apply_fix (a_writer: AFX_FIX_WRITER)
			-- apply fixes at this position
		require
		    fix_position_not_void: fix_position /= Void
		do
		    from
		        fix_operations.start
		    until
		        fix_operations.after
		    loop
		        fix_operations.item_for_iteration.apply_fix (a_writer)
		        fix_operations.forth
		    end
		end

	position_report: STRING
			-- report current position
		local
		    l_string: STRING
		do
		    Result := class_name + "." + routine_name + "@" + breakpoint_slot.out
		end

feature{NONE} --Implementation

	debugger_ast_server: DEBUGGER_AST_SERVER
			-- server to visit debugger's data from AST
		once
		    create Result.make(10)
		end

	relevant_objects_internal: detachable HASH_TABLE[TYPE_A, STRING]
			-- internal storage for `relevant_objects'


invariant
    information_complete: is_information_complete

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
