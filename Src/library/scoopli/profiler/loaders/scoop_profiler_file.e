note
	description: "Abstraction for profile file."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_FILE

create {SCOOP_PROFILER_LOADER}
	make_with_name

feature {NONE} -- Creation

	make_with_name (a_name: like file_name)
			-- Creation procedure.
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		local
			l_name: STRING
			l_parts: LIST [STRING]
		do
			create l_name.make_from_string (a_name.out)
			if not {SCOOP_LIBRARY_CONSTANTS}.Profile_file_extension.is_empty then
				l_name.remove_tail (1 + {SCOOP_LIBRARY_CONSTANTS}.Profile_file_extension.count)
			end
			l_name := l_name.split (Operating_environment.directory_separator).last
			l_parts := l_name.split ('_')
			if l_parts.count = 4 then
				create start.make_from_epoch (l_parts.at (1).to_integer)
				create stop.make_from_epoch (l_parts.at (2).to_integer)
				stop.fine_second_add (1)
				processor_id := l_parts.at (3).to_integer
				number := l_parts.at (4).to_integer
				is_valid := True
			end
			file_name := a_name
		ensure
			valid: is_valid implies (start /= Void and stop /= Void and processor_id /= 0 and number /= 0)
			file_name_set: file_name = a_name
		end

feature -- Access

	is_valid: BOOLEAN
			-- Is this file valid?

	start, stop: DATE_TIME
			-- Start and stop times

	processor_id, number: INTEGER
			-- Processor id
			-- Number of the file

	file: RAW_FILE
			-- New raw file object
		do
			create Result.make (file_name.out)
		ensure
			result_not_void: Result /= Void
			result_not_open: Result.is_closed
		end

feature {NONE} -- Implementation

	file_name: FILE_NAME
			-- File name

invariant
	valid: is_valid implies (start /= Void and stop /= Void and processor_id /= 0 and number /= 0)
	file_name_not_void: file_name /= Void and then not file_name.is_empty

	times_ok: (start /= Void and stop /= Void) implies start <= stop

end
