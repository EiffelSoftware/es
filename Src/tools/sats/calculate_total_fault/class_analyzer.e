note
	description: "Summary description for {CLASS_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CLASS_ANALYZER

create
	make

feature{NONE} -- Initialization

	make (a_path: STRING) is
			-- Analyze class in `a_path'.
		require
			a_path_attached: a_path /= Void
		do
			path := a_path.twin
			create fault_id_mapper.make (20)
			create global_faults.make (20)
			create fault_id_session_table.make (30)
		end

feature -- Basic operations

	analyze is
			-- Analyze.
		local
			l_fault_loader: FAULT_LOADER
			l_file_path: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_dir: DIRECTORY
		do
			retrieve_session_paths
			from
				session_paths.start
			until
				session_paths.after
			loop
				create l_dir.make (session_paths.item)
				if l_dir.exists then
					analyze_one_session (session_paths.item)
				end

				session_paths.forth
			end

			create l_file_path.make_from_string (path)
			l_file_path.set_file_name ("noriginal_fault_number.txt")
			create l_file.make_create_read_write (l_file_path)
			l_file.put_string (global_faults.count.out + "%N")
			l_file.close

			create l_file_path.make_from_string (path)
			l_file_path.set_file_name ("noriginal_fault_description.txt")
			create l_file.make_create_read_write (l_file_path)
			from
				global_faults.start
			until
				global_faults.after
			loop
				print_fault_in_file (global_faults.item_for_iteration, l_file, global_faults.key_for_iteration)
				global_faults.forth
			end
			l_file.close

			from
				session_paths.start
			until
				session_paths.after
			loop
				create l_dir.make (session_paths.item)
				if l_dir.exists then
					analyze_one_session_fault (session_paths.item)
				end

				session_paths.forth
			end
		end

	analyze_one_session_fault (a_session_path: STRING) is
		local
			l_fault_loader: FAULT_LOADER
			l_global_id: INTEGER
			l_fault: FAULT
			l_local_id: INTEGER
			l_normalized_file_path: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_file2: PLAIN_TEXT_FILE
			l_fpath: FILE_NAME
			l_sections: LIST [STRING]
			l_fault_tbl: HASH_TABLE [STRING, INTEGER]
			i: INTEGER
			l_str: STRING
			l_ftb: HASH_TABLE [INTEGER, INTEGER]
		do
			l_ftb := fault_id_session_table.item (a_session_path)
			create l_normalized_file_path.make_from_string (a_session_path)
			l_normalized_file_path.set_file_name ("original_faults.txt")
			create l_file.make_open_read (l_normalized_file_path)

			create l_fpath.make_from_string (a_session_path)
			l_fpath.set_file_name ("noriginal_faults.txt")
			create l_file2.make_create_read_write (l_fpath)

			create l_fault_tbl.make (100)
			from
				i := 1
			until
				i > global_faults.count
			loop
				l_fault_tbl.put (i.out + "%T0%T-1%T-1", i)
				i := i + 1
			end

			from
				l_file.read_line
				l_file2.put_string (l_file.last_string.twin)
				l_file2.put_character ('%N')
				l_file.read_line
			until
				l_file.after
			loop
				l_sections := l_file.last_string.split ('%T')
				l_local_id := l_sections.i_th (1).to_integer
				l_global_id := l_ftb.item (l_local_id)
				l_sections.i_th (1).wipe_out
				l_sections.i_th (1).append (l_global_id.out)
				create l_str.make (64)
				from
					l_sections.start
				until
					l_sections.after
				loop
					l_str.append (l_sections.item)
					if l_sections.index < l_sections.count then
						l_str.append ("%T")
					end
					l_sections.forth
				end
				l_fault_tbl.force (l_str, l_global_id)
				l_file.read_line
			end
			from
				i := 1
			until
				i > l_fault_tbl.count
			loop
				l_file2.put_string (l_fault_tbl.item (i))
				l_file2.put_string ("%N")
				i := i + 1
			end
			l_file.close
			l_file2.close
		end

	fault_id_session_table: HASH_TABLE [HASH_TABLE [INTEGER, INTEGER], STRING]

	analyze_one_session (a_session_path: STRING) is
			-- Analyze one session.
		local
			l_fault_loader: FAULT_LOADER
			l_global_id: INTEGER
			l_fault: FAULT
			l_local_id: INTEGER
			l_normalized_file_path: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_file2: PLAIN_TEXT_FILE
			l_fpath: FILE_NAME
			l_sections: LIST [STRING]
			l_fault_tbl: HASH_TABLE [STRING, INTEGER]
			i: INTEGER
			l_str: STRING
		do
			create l_fault_loader.make (fault_file_name (a_session_path))
			create fault_id_mapper.make (20)
			create l_normalized_file_path.make_from_string (a_session_path)
			l_normalized_file_path.set_file_name ("noriginal_fault_description.txt")
			create l_file.make_create_read_write (l_normalized_file_path)

			from
				l_fault_loader.faults.start
			until
				l_fault_loader.faults.after
			loop
				l_fault := l_fault_loader.faults.item
				l_local_id := l_fault.id
				l_global_id := global_fault_id (l_fault)
				if l_global_id = 0 then
					l_global_id := global_faults.count + 1
					global_faults.force (l_fault, l_global_id)
				end
				fault_id_mapper.force (l_global_id, l_local_id)
				print_fault_in_file (l_fault, l_file, fault_id_mapper.item (l_fault.id))
				l_fault_loader.faults.forth
			end
			l_file.close
			fault_id_session_table.put (fault_id_mapper, a_session_path)
		end

	print_fault_in_file (a_local_fault: FAULT; a_file: PLAIN_TEXT_FILE; a_id: INTEGER) is
			--
		do
			a_file.put_integer (a_id)
			a_file.put_character ('%T')
			a_file.put_string (a_local_fault.classification)
			a_file.put_character ('%T')
			a_file.put_string (a_local_fault.text_case_index)
			a_file.put_character ('%T')

			a_file.put_string ("exception_code=" + a_local_fault.exception_code.out)
			a_file.put_character ('%T')

			a_file.put_string ("tag=" + a_local_fault.tag)
			a_file.put_character ('%T')

			a_file.put_string ("recipient=" + a_local_fault.recipient_class + "." + a_local_fault.recipient_feature)
			a_file.put_character ('%T')

			a_file.put_string ("break_point_slot=" + a_local_fault.breakpoint_slot.out)
			a_file.put_character ('%N')

			from
				a_local_fault.messages.start
			until
				a_local_fault.messages.after
			loop
				a_file.put_string (a_local_fault.messages.item)
				a_file.put_character ('%N')
				a_local_fault.messages.forth
			end
		end

	global_fault_id (a_local_fault: FAULT): INTEGER is
			-- 1-based Global fault id for `a_local_fault'.
			-- 0 means that there is no global fault which is equal to `a_local_fault'.
		do
			from
				global_faults.start
			until
				global_faults.after or Result > 0
			loop
				if global_faults.item_for_iteration.is_original_equal (a_local_fault) then
					Result := global_faults.key_for_iteration
				end
				global_faults.forth
			end
		end

	fault_file_name (a_path: STRING): STRING is
			-- Full path of fault file
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string (a_path)
			l_file_name.set_file_name ("original_fault_description.txt")
			Result := l_file_name
		end


feature -- Access

	path: STRING
			-- Path where data files are stored.

feature{NONE} -- Implementation

	global_faults: HASH_TABLE [FAULT, INTEGER]
			-- Table of global faults.
			-- [Fault, global_fault_id]

	fault_id_mapper: HASH_TABLE [INTEGER, INTEGER]
			-- Mapper from local fault id to global fault id.
			-- [global_id, local_id]

	session_paths: LIST [STRING]
			-- Paths for session

	retrieve_session_paths is
			-- Retrieve paths for session from `path'.
		local
			l_file_searcher: SAT_FILE_SEARCHER
		do
			create l_file_searcher.make_with_pattern ("*")
			l_file_searcher.set_is_dir_matched (True)
			l_file_searcher.locations.extend (path)
			l_file_searcher.search
			session_paths := l_file_searcher.last_found_files.twin
		end

invariant
	fault_id_mapper_attached: fault_id_mapper /= Void

end
