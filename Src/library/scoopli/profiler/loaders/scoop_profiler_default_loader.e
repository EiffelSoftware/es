note
	description: "Default events loader."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_DEFAULT_LOADER

inherit
	SCOOP_PROFILER_LOADER

create
	make_with_directory

feature {NONE} -- Creation

	make_with_directory (a_dir: DIRECTORY)
			-- Creation procedure.
		require
			dir_readable: a_dir /= Void and then (a_dir.exists and then a_dir.is_readable)
		local
			l_file: SCOOP_PROFILER_FILE
			l_file_name: FILE_NAME
		do
			directory := a_dir
			directory.open_read

			-- Create hash
			create hash.make (1)
			from
				directory.start
				directory.readentry
			until
				directory.lastentry = Void
			loop
				-- This is a profile file
				if {SCOOP_LIBRARY_CONSTANTS}.Profile_file_extension.is_empty or else directory.lastentry.ends_with ("." + {SCOOP_LIBRARY_CONSTANTS}.Profile_file_extension) then
					-- Create file name
					create l_file_name.make
					l_file_name.set_directory (directory.name)
					l_file_name.set_file_name (directory.lastentry)

					-- Create file abstraction
					create l_file.make_with_name (l_file_name)

					if l_file.is_valid then
						-- Update min/max
						if start = Void or l_file.start < start then
							start := l_file.start
						end
						if stop = Void or l_file.stop > stop then
							stop := l_file.stop
						end

						if not hash.has (l_file.processor_id) then
							hash.extend (create {SCOOP_PROFILER_FILES_DESERIALIZER}.make_with_loader (Current), l_file.processor_id)
						end
						hash.item (l_file.processor_id).add_file (l_file)
					end
				end
				directory.readentry
			end
			directory.close

			-- Set min/max to default
			create min.make_by_date_time (start.date, start.time)
			create max.make_by_date_time (stop.date, stop.time)
		ensure
			directory_set: directory = a_dir
			hash_not_void: hash /= Void
		end

feature -- Basic Operations

	continue (a_processor: INTEGER)
			-- Continue with events for processor `a_processor`.
		do
			hash.item (a_processor).forth
			resume (a_processor)
		end

	delay (a_processor: INTEGER)
			-- Delay events for processor `a_processor`.
		do
			if hpq.has (hash.item (a_processor)) then
				hpq.prune (hash.item (a_processor))
			end
		end

	resume (a_processor: INTEGER)
			-- Resume events for processor `a_processor`.
		local
			l_item: SCOOP_PROFILER_FILES_DESERIALIZER
		do
			l_item := hash.item (a_processor)
			if not (hpq.has (l_item) or l_item.after) then
				hpq.extend (l_item)
			end
		end

	load (a_profile: like profile; a_visitor: SCOOP_PROFILER_EVENT_VISITOR)
			-- Load events into `a_profile` using `a_visitor`.
		local
			l_loader: SCOOP_PROFILER_FILES_DESERIALIZER
			l_item: SCOOP_PROFILER_EVENT
			l_current: DATE_TIME
			l_list: ARRAYED_LIST [SCOOP_PROFILER_FILES_DESERIALIZER]
		do
			profile := a_profile
			a_visitor.set_loader (Current)

			-- Start loaders
			l_list := hash.linear_representation
			l_list.do_all (agent {SCOOP_PROFILER_FILES_DESERIALIZER}.start)

			-- Create priority queue
			create hpq.make (l_list.count)
			from
				hpq.append (l_list)
			until
				hpq.is_empty
			loop
				-- Remove loader from queue
				l_loader := hpq.item
				hpq.remove

				-- Get next event
				l_item := l_loader.item
				if l_item.time < min then
					-- Go to next event
					l_loader.forth

					-- If there are other events, add to the queue
					if not l_loader.after then
						hpq.extend (l_loader)
					end
				elseif l_item.time > max then
					-- Don't do anything, don't add to the queue
				else
					-- Call progress action
					if l_current = Void or else l_current < l_item.time then
						l_current := l_item.time
						if progress_action /= Void then
							progress_action.call ([l_current])
						end
					end

					-- Visit item
					l_item.visit (a_visitor)
				end
			end
			-- Call progress action
			if progress_action /= Void then
				progress_action.call ([max])
			end
			
			-- Cleanup
			a_visitor.cleanup
		end

feature {NONE} -- Implementation

	profile: SCOOP_PROFILER_APPLICATION_PROFILE
			-- Reference to the application profile

	directory: DIRECTORY
			-- Directory where the profile data is stored

	hash: HASH_TABLE [SCOOP_PROFILER_FILES_DESERIALIZER, INTEGER]
			-- References to the deserializers for each processor

	hpq: HEAP_PRIORITY_QUEUE [SCOOP_PROFILER_FILES_DESERIALIZER]
			-- Priority queue of the active deserializers

invariant
	directory_not_void: directory /= Void and then (directory.exists and then directory.is_readable)
	hash_not_void: hash /= Void

end
