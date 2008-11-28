indexing
	description:
		"[
			Launcher to start an executable.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_BOOGIE_LAUNCHER

inherit

	EB_PROCESS_LAUNCHER

create
	make

feature {NONE} -- Initalization

	make is
			-- Initialization
		do
			set_buffer_size (128)
			set_time_interval (100)
		end

feature -- Access

	data_storage: EB_PROCESS_IO_STORAGE is
			-- Data storage location.
		do
			Result := external_storage
		end

end
