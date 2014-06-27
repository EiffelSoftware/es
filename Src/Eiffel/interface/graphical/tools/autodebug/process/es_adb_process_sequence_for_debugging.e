note
	description: "Summary description for {ES_ADB_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_PROCESS_SEQUENCE_FOR_DEBUGGING

inherit
	ES_ADB_PROCESS_SEQUENCE_FOR_FIXING
		rename
			make as make_fixing
		redefine
			remove_task
		end

create
	make

feature -- Access

	make
			-- Initialization.
		local
			l_class_groups: DS_ARRAYED_LIST [DS_HASH_SET [CLASS_C]]
			l_group_cursor: DS_ARRAYED_LIST_CURSOR [DS_HASH_SET [CLASS_C]]
			l_group: DS_HASH_SET [CLASS_C]
			l_process: ES_ADB_REGULAR_TESTING_PROCESS
		do
			make_sequence

			l_class_groups := config.classes_to_test_in_sessions
			from
				l_group_cursor := l_class_groups.new_cursor
				l_group_cursor.start
			until
				l_group_cursor.after
			loop
				l_group := l_group_cursor.item
				create l_process.make (l_group, Void, output_buffer)
				tasks.force_last (l_process)

				l_group_cursor.forth
			end

			sub_task := tasks.first
			tasks.remove_first
		end

feature -- Operation

	remove_task (a_task: like sub_task; a_cancel: BOOLEAN)
			-- <Precursor>
		local
			l_process: ES_ADB_PROCESS
			l_classes: DS_HASH_SET [CLASS_C]
			l_relaxed_testing_and_fixing_tasks: DS_ARRAYED_LIST [ES_ADB_PROCESS]
		do
			if a_cancel then
				sub_task := Void
				tasks.wipe_out
				wrap_up
			else
				l_process := sub_task
				if attached {ES_ADB_REGULAR_TESTING_PROCESS} l_process as lt_regular_testing_process then
					if info_center.config.is_starting_fixing_after_each_testing_session then
							-- Fix the faults found during `sub_task'.
						l_relaxed_testing_and_fixing_tasks := relaxed_testing_and_fixing_tasks_for_faults_in_classes (lt_regular_testing_process.classes)
						tasks.append_first (l_relaxed_testing_and_fixing_tasks)
					elseif info_center.config.is_starting_fixing_after_all_testing_sessions and then tasks.is_empty then
							-- Fix the faults found during ALL testing sessions.
						l_relaxed_testing_and_fixing_tasks := relaxed_testing_and_fixing_tasks_for_faults_in_classes (info_center.config.all_classes)
						tasks.append_first (l_relaxed_testing_and_fixing_tasks)
					elseif info_center.config.is_starting_fixing_manually then
							-- Do nothing.
					end
				end

				if tasks.is_empty then
					sub_task := Void
					wrap_up
				else
					sub_task := tasks.first
					tasks.remove_first
				end
			end
		end

	is_new_fault_in_classes (a_fault: ES_ADB_FAULT; a_classes: DS_HASH_SET [CLASS_C]): BOOLEAN
			-- Is `a_fault' discovered during testing `a_classes', and new (not AutoFixed)?
		require
			a_fault /= Void
			a_classes /= Void and then not a_classes.is_empty
		do
			Result := a_classes.has (a_fault.signature.class_under_test_) and then a_fault.status = {ES_ADB_FAULT}.status_not_yet_attempted
		end

	relaxed_testing_and_fixing_tasks_for_faults_in_classes (a_classes: DS_HASH_SET [CLASS_C]): DS_ARRAYED_LIST [ES_ADB_PROCESS]
			--
		require
			a_classes /= Void and then not a_classes.is_empty
		local
			l_faults: DS_ARRAYED_LIST [ES_ADB_FAULT]
			l_fault_cursor: DS_ARRAYED_LIST_CURSOR [ES_ADB_FAULT]
			l_fault: ES_ADB_FAULT
			l_relaxed_features: DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS]
			l_relaxed_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_relaxed_testing_process: ES_ADB_RELAXED_TESTING_PROCESS

		do
			l_faults := info_center.filtered_faults (agent is_new_fault_in_classes (?, a_classes))
			Result := relaxed_testing_and_fixing_tasks_for_faults (l_faults, True)
		end

;note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
