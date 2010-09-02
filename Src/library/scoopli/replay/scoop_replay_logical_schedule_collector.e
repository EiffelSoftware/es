note
	description: "Class collects logical schedules for scoop executions and executes replay."
	author: "Nikonov Andrey, Rusakov Andrey"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_REPLAY_LOGICAL_SCHEDULE_COLLECTOR

create
	make

feature {NONE} -- Initialization

	make (a_is_record_mode: BOOLEAN; a_is_replay_mode: BOOLEAN)
			-- init
		do
			if a_is_record_mode then
				create record_schedules.make
			end
			if a_is_replay_mode then
				create replay_schedules.make
			end
		end

feature {SCOOP_REPLAY_FILE, SCOOP_SCHEDULER} -- Implementation

	record_schedules: LINKED_LIST [SCOOP_REPLAY_LOGICAL_SCHEDULE]
		-- Logical schedules for recording processor's critical events.

	replay_schedules: LINKED_LIST [SCOOP_REPLAY_LOGICAL_SCHEDULE]
		-- Logical schedules for replaying processor's critical events.

	record_global_tick: INTEGER
		-- Global counter for record.

feature {SCOOP_SCHEDULER}

	replay_global_tick: INTEGER
		-- Global counter for replay.

feature {SCOOP_SCHEDULER}

	add_processor (a_proc: SCOOP_PROCESSOR)
			-- Create schedule for current processor to track down critical events.
		local
			current_logical_schedule : SCOOP_REPLAY_LOGICAL_SCHEDULE
		do
			create current_logical_schedule.make_with_processor (a_proc)
			record_schedules.extend (current_logical_schedule)
			a_proc.set_logical_schedule_record (current_logical_schedule)
		end

	add_critical_event (a_schedule: SCOOP_REPLAY_LOGICAL_SCHEDULE)
			-- Add critical event into logical schedule for current processor.
		do
			if (a_schedule.local_tick < record_global_tick) then
				a_schedule.set_last_interval (a_schedule.local_tick - 1)
				a_schedule.add_interval (record_global_tick, -1)
			end
			record_global_tick := record_global_tick + 1
			a_schedule.set_local_tick (record_global_tick)
		end

	close_intervals
			-- Close last critical interval for each processor
			-- and delete formal intervals (where FirstCriticalEvent is equal to -1).
		do
			from
				record_schedules.start
			until
				record_schedules.after
			loop
				record_schedules.item.close_intervals
				record_schedules.forth
			end
		end

	inc_replay_global_clock
			-- Increase replay_global_clock by 1 (go to the next critical event).
		do
			replay_global_tick := replay_global_tick + 1
		end

	set_replay_schedules (a_replay_schedules: LINKED_LIST [SCOOP_REPLAY_LOGICAL_SCHEDULE])
			-- Set logical schedule for execution replay.
		do
			if a_replay_schedules /= Void then
				replay_schedules := a_replay_schedules
			end
		end

feature {SCOOP_SCHEDULER}

	match_processor (a_proc: SCOOP_PROCESSOR)
			-- Find schedule inside replay_schedules for the processor by "gid" (global path in processor's tree structure).
		local
			proc_gid: LINKED_LIST [INTEGER]
			current_schedule: SCOOP_REPLAY_LOGICAL_SCHEDULE
			is_found: BOOLEAN
			is_different: BOOLEAN
		do
			proc_gid := a_proc.build_global_id
			from
				is_found := False
				replay_schedules.start
			until
				replay_schedules.after or is_found = True
			loop
				current_schedule := replay_schedules.item
				if proc_gid.count = current_schedule.gid.count then
					from
						proc_gid.start
						current_schedule.gid.start
						is_different := False
					until
						proc_gid.after or current_schedule.gid.after or is_different = True
					loop
						if proc_gid.item /= current_schedule.gid.item then
							is_different := True
						end
						proc_gid.forth
						current_schedule.gid.forth
					end
					if not is_different then
						is_found := True
					end
				end
				replay_schedules.forth
			end
			if is_found then
				a_proc.set_logical_schedule_replay (current_schedule)
			end
		end

feature -- Access

	is_empty: BOOLEAN
			-- Is logical schedule for record empty?
		do
			Result := record_schedules.is_empty
		end

	output_replay
			-- Print logical schedule for replay mode.
		do
			from
				replay_schedules.start
			until
				replay_schedules.item = Void
			loop
				replay_schedules.item.output_replay
				replay_schedules.forth
			end
		end

	output_record
			-- Print graphical and list interpretation of critical intervals for all processors in record mode.
		do
			io.putstring ("********************************************%N")
			from
				record_schedules.start
			until
				record_schedules.after
			loop
				record_schedules.item.output_intervals_g (record_global_tick)
				record_schedules.forth
			end
			from
				record_schedules.start
			until
				record_schedules.after
			loop
				record_schedules.item.output_global_id
				record_schedules.item.output_intervals
				record_schedules.forth
			end
		end
end
