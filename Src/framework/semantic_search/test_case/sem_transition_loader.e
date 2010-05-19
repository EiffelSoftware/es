note
	description: "Loader to load test cases into transitions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TRANSITION_LOADER

feature -- Access

	last_transitions: LIST [SEM_FEATURE_CALL_TRANSITION]
			-- Last transitions loaded by last `load'

	last_objects: LIST [SEM_OBJECTS]
			-- Last objects loaded by last `load'

feature -- Status report

	is_recursive: BOOLEAN
			-- Should directories be traversed recursively to find test case files?
			-- Default: False

feature -- Setting

	set_is_recursive (b: BOOLEAN)
			-- Set `is_recursive' with `b'.
		do
			is_recursive := b
		ensure
			is_recursive_set: is_recursive = b
		end

feature -- Basic operations

	load (a_location: STRING)
			-- Load test case(s) from `a_location' and store result in `last_transitions'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create {LINKED_LIST [SEM_FEATURE_CALL_TRANSITION]} last_transitions.make
			create {LINKED_LIST [SEM_OBJECTS]} last_objects.make
			create l_file.make (a_location)
			if l_file.is_directory then
				load_from_directory (a_location)
			else
				load_from_file (a_location)
			end
		end

feature{NONE} -- Implementation

	load_from_file (a_file: STRING)
			-- Load transition from test case file `a_file' and store result in `last_transitions'.
		do
			loader.load_transition (a_file)
			if attached {SEM_FEATURE_CALL_TRANSITION} loader.last_transition  as l_transition then
				l_transition.add_written_precondition
				l_transition.add_written_postcondition
				last_transitions.extend (l_transition)
			end
		end

	load_from_directory (a_dir: STRING)
			-- Load transitions from test cases in directory `a_dir' and store result in `last_transitions'.
		local
			l_dir: DIRECTORY
			l_entry: STRING
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
		do
			create l_dir.make_open_read (a_dir)
			from
				l_dir.readentry
			until
				l_dir.lastentry = Void
			loop
				l_entry := l_dir.lastentry.twin
				if not (l_entry ~ once ".")  and not (l_entry ~ once "..") then
					create l_file_name.make_from_string (a_dir)
					l_file_name.extend (l_entry)
					create l_file.make (l_file_name)
					if l_file.is_directory then
						if is_recursive then
							load_from_directory (l_file_name)
						end
					else
						load_from_file (l_file_name)
					end
				end
				l_dir.readentry
			end
		end

	loader: SEM_FEATURE_CALL_TRANSITION_LOADER_FROM_TEST_CASE
			-- Loader to load test cases
		local
			l_new_loader: like loader
		do
			if attached {like loader} loader_internal as l_loader then
				Result := l_loader
			else
				create l_new_loader.make (create {UT_ERROR_HANDLER}.make_standard)
				loader_internal := l_new_loader
				Result := l_new_loader
			end
		end

	loader_internal: detachable like loader
			-- Cache for `loader'

end
