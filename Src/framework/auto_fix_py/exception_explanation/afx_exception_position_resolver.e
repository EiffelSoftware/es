note
	description: "Summary description for {AFX_EXCEPTION_POSITION_RESOLVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXCEPTION_POSITION_RESOLVER

inherit

	AFX_EXCEPTION_POSITION_RESOLVER_I

    SHARED_TEST_SERVICE

    SHARED_AFX_LOGGING_INFRASTRUCTURE

feature -- Operation

	resolve (an_exception_frames: DS_LINEAR [AFX_EXCEPTION_CALL_STACK_FRAME_I])
			-- <Precursor>
		local
		    l_logging_service: like logging_service
		    l_entry_factory: like log_entry_factory
		    l_frame: AFX_EXCEPTION_CALL_STACK_FRAME_I
		do
		    l_logging_service := logging_service
		    l_entry_factory := log_entry_factory

			from an_exception_frames.start
			until an_exception_frames.after
			loop
			    l_frame := an_exception_frames.item_for_iteration
			    if l_frame.is_information_complete then
			        resolve_frame (l_frame)
			    end
			    an_exception_frames.forth
			end

		    l_logging_service.log (
		    			l_entry_factory.make_info_entry (
		    						Msg_finished_resolving_all_exception_frames))
		end

feature{NONE} -- Implementation

	resolve_frame (a_frame: AFX_EXCEPTION_CALL_STACK_FRAME_I)
			-- resolve the information of a single frame
		require
		    frame_information_complete: a_frame.is_information_complete
		do
		    resolve_context_feature (a_frame)
		    resolve_breakpoint_info (a_frame)
		end

	resolve_context_feature (a_frame: AFX_EXCEPTION_CALL_STACK_FRAME_I)
			-- resolve the `context_feature' of `a_frame'
		require
		    frame_information_complete: a_frame.is_information_complete
		local
		    l_test_suite: TEST_SUITE_S
		    l_logging_service: like logging_service
		    l_entry_factory: like log_entry_factory
		    l_list_class_i: LIST [CLASS_I]
		    l_set_class_c: ARRAYED_SET[CLASS_C]
		    l_class_c: CLASS_C
		do
		    l_test_suite := test_suite.service
		    l_logging_service := logging_service
		    l_entry_factory := log_entry_factory

		    	-- resolve class_c according to class_name
		    l_list_class_i := l_test_suite.eiffel_project.system.system.universe.compiled_classes_with_name(a_frame.origin_class_name)
		    create l_set_class_c.make (l_list_class_i.count)
		    l_set_class_c.compare_objects
		    from
		        l_list_class_i.start
		    until
		        l_list_class_i.after
		    loop
		        if attached {CLASS_C} l_list_class_i.item_for_iteration.actual_class.compiled_class as l_class then
		            l_set_class_c.put (l_class)
		        end
		        l_list_class_i.forth
		    end

		    -- TODO: check the situations where several classes are found having the same name
		    --		 and select the proper class
		    --		 (does override-class need any special process?)

				-- resolve e_feature according to class_c and feature_name
			check not l_set_class_c.is_empty end
	        l_set_class_c.start
	        l_class_c := l_set_class_c.item

			a_frame.e_feature := l_class_c.feature_with_name (a_frame.routine_name)

			check a_frame.e_feature /= Void end
			l_logging_service.log (
						l_entry_factory.make_info_entry (
									Msg_finished_resolving_exception_frame_e_feature_pre + a_frame.class_name + "." + a_frame.routine_name + "(from "
												+ a_frame.origin_class_name + ")"))
		ensure
		    e_feature_resolved: a_frame.e_feature /= Void
		end

	resolve_breakpoint_info (a_frame: AFX_EXCEPTION_CALL_STACK_FRAME_I)
			-- resolve the `breakpoint_info' of `a_frame'
		require
		    frame_information_complete: a_frame.is_information_complete
		    context_feature_resolved: a_frame.e_feature /= Void
		    breakpoint_info_unresolved: a_frame.breakpoint_info = Void
		local
		    l_logging_service: like logging_service
		    l_entry_factory: like log_entry_factory
		    l_points: ARRAYED_LIST [DBG_BREAKABLE_POINT_INFO]
		    l_slot_index: INTEGER
		do
		    l_logging_service := logging_service
		    l_entry_factory := log_entry_factory

				-- search the breakable points until we find a match
			if attached debugger_ast_server.breakable_feature_info (a_frame.e_feature) as l_breakable_info then
    		    l_points := l_breakable_info.points
    		    l_slot_index := a_frame.breakpoint_slot_index
		        from
		            l_points.start
		        until
		            l_points.after or a_frame.breakpoint_info /= Void
		        loop
		            if attached l_points.item as l_point then
		                if l_point.bp = l_slot_index and then l_point.bp_nested = 0 then
		                    	-- we do not differentiate nested breakpoints, since we don't have nested breakpoint slot index from the exception trace.
		                    	-- Here, we just get the information of the first breakpoint slot with given index.
		                    	-- As a result, instructions would be the level where we work
		                    a_frame.breakpoint_info := l_point
		                end
		            end
		            l_points.forth
    		    end
			end

			check breakpoint_info_resolved: a_frame.breakpoint_info /= Void end
			l_logging_service.log (
						l_entry_factory.make_info_entry (
									Msg_finished_resolving_exception_frame_breakpoint_slot_info_pre + a_frame.routine_name + "%A" + a_frame.breakpoint_slot_index.out))
		ensure
		    breakpoint_info_resolved: a_frame.breakpoint_info /= Void
		end

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
