note
	description: "Default implementation of the blackboard service."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_BLACKBOARD

inherit

	BLACKBOARD_S

	DISPOSABLE_SAFE

	SHARED_WORKBENCH
		export {NONE} all end

	SHARED_EIFFEL_PROJECT

	EBB_SHARED_ALL

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize empty blackboard.
		do
			create data.make
			create {EBB_IDLE_CONTROL} control.make
			create {LINKED_LIST [EBB_TOOL]} tools.make
			create {LINKED_LIST [EBB_FEATURE_VERIFICATION_RESULT]} verification_results.make
			create executions.make

			initialize

				-- Autostart Blackboard
			eiffel_project.manager.load_agents.extend (agent start)
		end

feature -- Access

	data: EBB_SYSTEM_DATA
			-- <Precursor>

	tools: LIST [EBB_TOOL]
			-- <Precursor>

	control: EBB_CONTROL
			-- <Precursor>

	executions: EBB_EXECUTIONS
			-- <Precursor>

feature -- Status report

	is_recording_results: BOOLEAN
			-- Is blackboard recording results at the moment?

	is_usable: BOOLEAN = True
			-- <Precursor>

feature -- Element change

	set_control (a_control: attached like control)
			-- Set `control' to `a_control'.
		do
			control := a_control
		ensure
			control_set: control = a_control
		end

feature -- Basic operations

	add_verification_result (a_result: EBB_FEATURE_VERIFICATION_RESULT)
			-- Add `a_result' to list of verification results.
		do
			if is_recording_results then
				verification_results.extend (a_result)
			else
				record_results
				verification_results.extend (a_result)
				commit_results
			end
		ensure
			recording_state_unchanged: is_recording_results = old is_recording_results
		end

	record_results
			-- Record results to update multiple results at once.
		require
			not_recording_results: not is_recording_results
		do
			is_recording_results := True
		ensure
			recording_results: is_recording_results
		end

	commit_results
			-- Commit all verification results added since last commit of results.
		require
			recording_results: is_recording_results
		do
			across verification_results as l_cursor loop
				data.feature_data (l_cursor.item.associated_feature).update_with_new_result (l_cursor.item)
				data.feature_data (l_cursor.item.associated_feature).recalculate_correctness_confidence
				data.feature_data (l_cursor.item.associated_feature).set_fresh
--				data.class_data (l_cursor.item.associated_class).verification_state.calculate_confidence
			end
			verification_results.wipe_out
			is_recording_results := False
			data_changed_event.publish ([])
		ensure
			not_recording_results: not is_recording_results
		end

	handle_added_class (a_class: CLASS_I)
			-- Handle that `a_class' was added.
		do
			data.add_class (a_class)
			executions.handle_changed_class (a_class)
			data_changed_event.publish ([])
		end

	handle_removed_class (a_class: CLASS_I)
			-- Handle that `a_class' was removed.
		do
			data.remove_class (a_class)
			executions.handle_changed_class (a_class)
			data_changed_event.publish ([])
		end

	handle_changed_feature (a_feature: FEATURE_I)
			-- Handle that `a_feature' changed.
		do
			if data.has_feature (a_feature) then
				data.update_feature (a_feature)
			else
					-- TODO: problem during first compilation and with classes from libraries
				if data.has_class (a_feature.written_class.original_class) then
					data.add_feature (a_feature)
				end
			end
			executions.handle_changed_class (a_feature.written_class.original_class)
			data_changed_event.publish ([])
		end

	handle_removed_feature (a_feature: FEATURE_I)
			-- Handle that `a_feature' was removed.
		do
			if data.has_feature (a_feature) then
				data.remove_feature (a_feature)
			end
			executions.handle_changed_class (a_feature.written_class.original_class)
			data_changed_event.publish ([])
		end

feature {NONE} -- Implementation

	verification_results: LIST [EBB_FEATURE_VERIFICATION_RESULT]
			-- List of verification results.

	safe_dispose (a_explicit: BOOLEAN)
			-- <Precursor>
		do
		end

end
