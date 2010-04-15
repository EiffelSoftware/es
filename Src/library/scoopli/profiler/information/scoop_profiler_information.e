note
	description: "Profiling information."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_INFORMATION

create
	make

feature {NONE} -- Creation

	make
			-- Creation procedure.
		do
			create classes.make (0)
		ensure
			classes_not_void: classes /= Void
		end

feature -- Access

	classes: HASH_TABLE [SCOOP_PROFILER_CLASS_INFORMATION, INTEGER]
			-- Classes information
			-- key: class id, value: class information object

	is_profiling_enabled: BOOLEAN
			-- Is profiling enabled?

	buffer_size: INTEGER
			-- What's the buffer size?

	directory: DIRECTORY
			-- Directory where to put profile data

feature -- Basic Operations

	enable_profiling
			-- Enable profiling.
		do
			is_profiling_enabled := True
		ensure
			profiling_enabled: is_profiling_enabled
		end

	disable_profiling
			-- Disable profiling.
		do
			is_profiling_enabled := False
		ensure
			profiling_disabled: not is_profiling_enabled
		end

	set_directory (a_dir: like directory)
			-- Set `directory` to `a_dir`.
		require
			directory_writable: a_dir.exists and then a_dir.is_writable
		do
			directory := a_dir
		ensure
			directory_set: directory = a_dir
		end

	set_buffer_size (a_size: like buffer_size)
			-- Set `buffer_size` to `a_size`.
		require
			size_non_negative: a_size >= 0
		do
			buffer_size := a_size
		ensure
			buffer_size_set: buffer_size = a_size
		end

invariant
	classes_not_void: classes /= Void

end
