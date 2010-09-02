note
	description: "Object that saves record/replay data on hard drive.%
				%(.sls file for logical schedule, .dot file for diagram)"
	author: "Nikonov Andrey, Rusakov Andrey"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_REPLAY_FILE

create
	make_open_read, make_open_write

feature -- Implementation

	make_open_read (a_file_name: STRING)
			-- Init
		do
			create file.make_open_read (a_file_name)
		end

	make_open_write (a_file_name: STRING)
			-- Init
		do
			create file.make_open_write (a_file_name)
		end

feature -- Access

	read_logical_schedule: LINKED_LIST [SCOOP_REPLAY_LOGICAL_SCHEDULE]
			-- Read replay data from .sls file into structure for replaying.
		local
			str : STRING
		do
			create Result.make
			create str.make_empty
			is_end_of_file := False
			file.start
			from
				file.read_character
			until
				file.last_character = ' ' or file.end_of_file
			loop
				str := str + file.last_character.out
				file.move (0)
				file.read_character
			end

			if str.is_equal ( {SCOOP_LIBRARY_CONSTANTS}.REPLAY_file_header ) then
				from
				until
					is_end_of_file
				loop
					Result.extend (read_processor_logical_schedule)
				end
			end
		end

	write_logical_schedule (a_schedules: LINKED_LIST [SCOOP_REPLAY_LOGICAL_SCHEDULE])
			-- Save logical schedule into .sls file.
		require
			ls_not_empty : a_schedules /= Void and then not a_schedules.is_empty
		do
			file.putstring ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_file_header + " ")
			from
				a_schedules.start
			until
				a_schedules.after
			loop
				write_processor_logical_schedule (a_schedules.item)
				a_schedules.forth
			end
			file.putint (-3)
				-- end of file
			file.flush
		end

	close
			-- Close file.
		do
			file.close
		end


feature {NONE} -- Implementation

	read_processor_logical_schedule: SCOOP_REPLAY_LOGICAL_SCHEDULE
			-- Read replay data for one processor.
		local
			l_gid: LINKED_LIST [INTEGER]
			is_odd: BOOLEAN
		do
			file.move (0)
			file.read_integer
			-- if not end of file
			if file.lastint /= -3 then
				create Result.make_empty
				create l_gid.make
				file.move (0)
				from
					file.read_integer
				until
					file.last_integer = -1
				loop
					l_gid.extend (file.last_integer)
					file.move (0)
					file.read_integer
				end
				Result.set_gid (l_gid)
				file.move (0)
				is_odd := True
				from
					file.read_integer
				until
					file.last_integer = -2
				loop
					if is_odd then
						Result.add_interval (file.last_integer, -1)
						is_odd := False
					else
						Result.set_last_interval (file.last_integer)
						is_odd := True
					end
					file.move (0)
					file.read_integer
				end
			else
				is_end_of_file := True
			end
		end

	write_processor_logical_schedule (a_logical_schedule: SCOOP_REPLAY_LOGICAL_SCHEDULE)
			-- Save current logical schedule.
		require
			sc_not_empty: a_logical_schedule /= Void
		do
			file.putint (a_logical_schedule.intervals.count)

			from
				a_logical_schedule.gid.start
			until
				a_logical_schedule.gid.after
			loop
				file.putint ( a_logical_schedule.gid.item )
				a_logical_schedule.gid.forth
			end
			file.putint ( -1 )
				--end of gid		

			from
				a_logical_schedule.intervals.start
			until
				a_logical_schedule.intervals.after
			loop
				file.putint (a_logical_schedule.intervals.item.first_critical_event)
				file.putint (a_logical_schedule.intervals.item.last_critical_event)
				a_logical_schedule.intervals.forth
			end
			file.putint ( -2 )
				--end of thread logical interval		
		end

	file: RAW_FILE
		-- File object.

	is_end_of_file: BOOLEAN
		-- Has end of file been detected?

end
