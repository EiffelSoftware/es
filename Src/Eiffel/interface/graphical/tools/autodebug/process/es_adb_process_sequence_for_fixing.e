note
	description: "Summary description for {ES_ADB_FIXING_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_PROCESS_SEQUENCE_FOR_FIXING

inherit
	ES_ADB_PROCESS_SEQUENCE
		redefine
			remove_task
		end

create
	make

feature -- Access

	make (a_faults: DS_ARRAYED_LIST [ES_ADB_FAULT]; a_should_reattempt: BOOLEAN)
			-- Initialization.
		require
			a_faults /= Void and then not a_faults.is_empty
		local
			l_class_groups: DS_ARRAYED_LIST [DS_HASH_SET [CLASS_C]]
			l_group_cursor: DS_ARRAYED_LIST_CURSOR [DS_HASH_SET [CLASS_C]]
			l_group: DS_HASH_SET [CLASS_C]
		do
			make_sequence

			tasks.append_last (relaxed_testing_and_fixing_tasks_for_faults (a_faults, a_should_reattempt))
			sub_task := tasks.first
			tasks.remove_first
		end

feature -- Access

	sub_task: ES_ADB_PROCESS
			-- <Precursor>

feature -- Status report

	should_output_be_parsed: BOOLEAN
			-- <Precursor>
		do
			Result := sub_task /= Void and then sub_task.should_output_be_parsed
		end

feature -- Operation

	remove_task (a_task: like sub_task; a_cancel: BOOLEAN)
			-- <Precursor>
		local
			l_process: ES_ADB_PROCESS
			l_classes: DS_HASH_SET [CLASS_C]
		do
			if a_cancel then
				sub_task := Void
				tasks.wipe_out
				wrap_up
			else
				if tasks.is_empty then
					sub_task := Void
					wrap_up
				else
					sub_task := tasks.first
					tasks.remove_first
				end
			end
		end


	relaxed_testing_and_fixing_tasks_for_faults (a_faults: DS_ARRAYED_LIST [ES_ADB_FAULT]; a_should_reattempt: BOOLEAN): DS_ARRAYED_LIST [ES_ADB_PROCESS]
			--
		require
			a_faults /= Void and then not a_faults.is_empty
		local
			l_fault_cursor: DS_ARRAYED_LIST_CURSOR [ES_ADB_FAULT]
			l_fault: ES_ADB_FAULT
			l_relaxed_features: DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS]
			l_relaxed_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_relaxed_testing_process: ES_ADB_RELAXED_TESTING_PROCESS
			l_fixing_process: ES_ADB_FIXING_PROCESS

		do
			create Result.make_equal (a_faults.count * 2 + 1)
			if not a_faults.is_empty then
				create l_relaxed_features.make_equal (a_faults.count)

				from
					l_fault_cursor := a_faults.new_cursor
					l_fault_cursor.start
				until
					l_fault_cursor.after
				loop
					l_fault := l_fault_cursor.item
					if
						l_fault.is_approachable_per_config (config) -- Approachable
						and then (l_fault.is_not_yet_attempted 		-- Not yet attempted
									or else a_should_reattempt 		-- should reattempt and not yet fixed.
									and then not l_fault.is_candidate_fix_accepted
									and then not l_fault.is_manually_fixed)
					then
						if config.should_fix_contracts and then l_fault.is_exception_type_in_scope_of_contract_fixing then
							l_relaxed_feature := l_fault.failing_feature_with_context

							-- CHECK IF WE CAN SKIP THE RELAXED TESTING IN SOME CASES.
							if (l_relaxed_feature.is_public or else l_relaxed_feature.is_creation_feature) and then not l_relaxed_features.has (l_relaxed_feature) then
								create l_relaxed_testing_process.make (l_relaxed_feature, Void, output_buffer)
								Result.force_last (l_relaxed_testing_process)

								l_relaxed_features.force (l_relaxed_feature)
							end
						end

						create l_fixing_process.make (l_fault, Void, output_buffer)
						Result.force_last (l_fixing_process)
					end

					l_fault_cursor.forth
				end
			end
		end

feature{NONE} -- Implementation

	tasks: DS_ARRAYED_LIST [ES_ADB_PROCESS]
			-- Tasks to perform.
		do
			if tasks_internal = Void then
				create tasks_internal.make_equal (10)
			end
			Result := tasks_internal
		end

feature{NONE} -- Internals

	tasks_internal: like tasks


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
