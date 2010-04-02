note
	description: "Deserializer for a sequence of files containing profiler events."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_FILES_DESERIALIZER

inherit
	COMPARABLE

create
	make_with_loader

feature -- Creation

	make_with_loader (a_loader: like loader)
			-- Creation procedure.
		require
			loader_not_void: a_loader /= Void
		do
			create store_handler
			create events.make
			create files.make
			loader := a_loader
		ensure
			loader_set: loader = a_loader
			store_handler_not_void: store_handler /= Void
			events_not_void: events /= Void
			files_not_void: files /= Void
		end

feature -- Files

	add_file (a_file: SCOOP_PROFILER_FILE)
			-- Add `a_file` to `files`.
		require
			file_valid: a_file /= Void and then a_file.is_valid
		do
			files.extend (a_file)
		ensure
			files_incremented: files.count = old files.count + 1
		end

feature {NONE} -- Events

	events: LINKED_QUEUE [SCOOP_PROFILER_EVENT]
			-- Queue of already read events

	read_events
			-- Read events for the next file.
		require
			files_not_after: not files.after
		local
			l_file: RAW_FILE
			l_serializer: SED_MEDIUM_READER_WRITER
			e: SCOOP_PROFILER_EVENT
		do
			-- Prepare serializer
			l_file := queue.item.file
			create l_serializer.make (l_file)
			l_serializer.set_for_reading

			if l_file.exists and then l_file.is_readable then
				-- Open file and retrieve events
				from
					l_file.open_read
					e ?= store_handler.retrieved (l_serializer, True)
				until
					e = Void
				loop
					events.extend (e)
					e ?= store_handler.retrieved (l_serializer, True)
				end
				l_file.close
			elseif not queue.is_empty then
				queue.remove
				read_events
			end
		end

feature -- Cursor movement

	start
			-- Start.
		do
			-- Create queue
			create queue.make (files.count)
			queue.append (files)

			-- Go to first file inside the min-max range
			from
			until
				queue.item.stop >= loader.min
			loop
				queue.remove
			end

			-- Read events
			read_events
			queue.remove
		end

	after: BOOLEAN
			-- Is after?
		do
			Result := queue.is_empty and events.is_empty
		ensure
			definition: Result = (queue.is_empty and events.is_empty)
		end

	forth
			-- Move to the next event.
		require
			not_after: not after
		do
			events.remove
			if events.is_empty and not queue.is_empty then
				read_events
				queue.remove
			end
		end

	item: SCOOP_PROFILER_EVENT
			-- What's the current item?
		require
			not_after: not after
		do
			if not events.is_empty then
				Result := events.item
			end
		ensure
			result_not_void: Result /= Void
		end

feature -- Comparable

	is_less alias "<" (a_other: like Current): BOOLEAN
			-- Is this less than `a_other`?
			-- Less means that a_other starts before current, used for HEAP_PRIORITY_QUEUE.
		do
			if item /= Void and (a_other /= Void and then a_other.item /= Void) then
				Result := item.time > a_other.item.time
			end
		end

feature {NONE} -- Implementation

	files: LINKED_LIST [SCOOP_PROFILER_FILE]
			-- List of files

	queue: HEAP_PRIORITY_QUEUE [SCOOP_PROFILER_FILE]
			-- Queue (ordered by file number)

	store_handler: SED_STORABLE_FACILITIES
			-- Store handler

	loader: SCOOP_PROFILER_LOADER
			-- Reference loader

invariant
	store_handler_not_void: store_handler /= Void
	files_not_void: files /= Void
	events_not_void: events /= Void
	loader_not_void: loader /= Void

end
