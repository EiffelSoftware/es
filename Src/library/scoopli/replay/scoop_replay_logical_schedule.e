note
	description: "Logical schedule for current scoop processor."
	author: "Nikonov Andrey, Rusakov Andrey"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_REPLAY_LOGICAL_SCHEDULE

create
	make_with_processor, make_empty

feature {NONE} -- Initialization

	make_with_processor (a_proc : SCOOP_PROCESSOR)
			-- Init when record mode activated.
		do
			create intervals.make
			pid := a_proc.thread_id.to_integer_32
			gid := a_proc.build_global_id
			add_interval( 0, -1 )
		end

	make_empty
			-- Init when replay mode activated.
		do
			create intervals.make
		end

feature -- Access

	is_empty: BOOLEAN
			-- Is intervals list empty?
		do
			Result := intervals.is_empty
		end

	add_interval (first_event: INTEGER; last_event: INTEGER)
			-- Add interval of critical events to processor's list.
		local
			tmp : SCOOP_REPLAY_LOGICAL_INTERVAL
		do
			create tmp.make (first_event, last_event)
			intervals.extend (tmp)
		end

	set_last_interval (last_event: INTEGER)
			-- Replaces last_critical_event value in the last logical interval with last_event.
		do
			intervals.last.set_last_critical_event (last_event)
		end

	set_local_tick (a_tick: INTEGER)
			-- Set local_tick value.
		do
			local_tick := a_tick
		end

	close_intervals
			-- Process interval list (delete formal interval if exists and close last interval with local_clock value).
		do
			set_last_interval (local_tick - 1)
			if (intervals.first.last_critical_event < 0) then
				intervals.start
				intervals.remove
			end
		end

feature {SCOOP_REPLAY_FILE}

	set_gid (a_gid: LINKED_LIST [INTEGER])
			-- Set global_id value.
		do
			gid := a_gid
		end

feature {SCOOP_PROCESSOR}

	has_separate_call (separate_call_number: INTEGER) : BOOLEAN
			-- Check is this separate call inside one of critical intevals of current processor
		do
			from
				Result := False
				intervals.start
			until
				intervals.after or Result = True
			loop
				if separate_call_number >= intervals.item.first_critical_event and
					separate_call_number <= intervals.item.last_critical_event
				then
					Result := True
				end
				intervals.forth
			end
		end

feature -- Implementation

	gid: LINKED_LIST [INTEGER]
		-- Global identifier for current processor (stores path in processor's tree from the root).

	pid: INTEGER
		-- Local identifier for current processor (processor.tread_id).

	intervals: LINKED_LIST [SCOOP_REPLAY_LOGICAL_INTERVAL]
		-- List of intervals that represent sequence of critical events for current processor.

	local_tick: INTEGER
		-- Counter for making logical schedule intervals.

feature -- Output

	output_replay
			-- Print logical schedule (for replay mode)
		do
			io.putstring ("{ ")
			output_global_id
			io.putstring ("}: ")
			from
				intervals.start
			until
				intervals.after
			loop
				io.putstring ("[ " + intervals.item.first_critical_event.out + ", " + intervals.item.last_critical_event.out + " ], ")
				intervals.forth
			end
			io.putstring ("%N")
		end

	output_intervals
			-- Print logical intervals
		do
			io.put_string (" pid = " + pid.out + ", ")
			from
				intervals.start
			until
				intervals.after
			loop
				io.put_string ( "[ " + intervals.item.first_critical_event.out + ", " + intervals.item.last_critical_event.out + " ], " )
				intervals.forth
			end
			io.put_string ("%N")
		end

	output_intervals_g (a_length: INTEGER)
			-- Print graphical interpretation
		local
			j, k : INTEGER
			n : INTEGER
			tmp : SCOOP_REPLAY_LOGICAL_INTERVAL
			tmp_next : SCOOP_REPLAY_LOGICAL_INTERVAL
			next_pos : INTEGER
			cur_pos : INTEGER
		do
			n := intervals.count
			cur_pos := -1
			from
				intervals.start
			until
				intervals.after
			loop
				from
					k := cur_pos + 1
				until
					k >= intervals.item.first_critical_event
				loop
					io.put_string ( "-" )
					k := k + 1
				end

				from
					k := intervals.item.first_critical_event
				until
					k > intervals.item.last_critical_event
				loop
					io.put_string ( "x" )
					k := k + 1
				end
				cur_pos := intervals.item.last_critical_event
				intervals.forth
			end
			from
				k := cur_pos + 1
			until
				k >= a_length
			loop
				io.put_string ( "-" )
				k := k + 1
			end
			io.put_string (" pid = " + pid.out + "%N")
		end

	output_global_id
			-- Print path in processor's tree
		do
			from
				gid.start
			until
				gid.after
			loop
				io.putstring (gid.item.out + ",")
				gid.forth
			end
		end

end
