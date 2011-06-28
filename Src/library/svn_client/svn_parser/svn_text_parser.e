note
	description: "Summary description for {SVN_TEXT_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_TEXT_PARSER

inherit
	SVN_PARSER

feature -- Parse commands

	parse_checkout (a_checkout_command: SVN_CLIENT_CHECKOUT_COMMAND)
		do
		end

	parse_commit (a_commit_command: SVN_CLIENT_COMMIT_COMMAND)
		do
		end

	parse_list (a_list_command: SVN_CLIENT_LIST_COMMAND)
		local
			l_root: SVN_CLIENT_FOLDER
			l_list: LIST[STRING_8]
		do
			create l_root.make_with_name (a_list_command.target)
			l_list := string_to_list (a_list_command.last_result)

			l_root.append (list_to_items (l_list))

			a_list_command.set_last_list (l_root)
		end

	parse_log (a_log_command: SVN_CLIENT_LOG_COMMAND)
		do
		end

	parse_status (a_status_command: SVN_CLIENT_STATUS_COMMAND)
		local
			l_root: SVN_CLIENT_FOLDER
			l_status: LIST[STRING_8]
			l_status_list, l_status_properties: LINKED_LIST[STRING_8]
			l_item: STRING_8
		do
			create l_root.make_with_name (a_status_command.target)

			l_status := string_to_list (a_status_command.last_result)
			l_status := strip_blank_lines (l_status)
			create l_status_list.make
			create l_status_properties.make

			from l_status.start
			until l_status.after
			loop
				l_item := l_status.item_for_iteration
					-- Characters from 1 to 7: status, properties, locked (remaining 4 chars not relevant yet)
				l_status_properties.extend (l_item.substring (1, 7))
					-- Characters from 9 to end: directory or file name
				l_status_list.extend (l_item.substring (9, l_item.count))

				l_status.forth
			end

			l_root.append (status_to_items (l_status_list, l_status_properties))

			a_status_command.set_last_status (l_root)
		end

	parse_error (a_client_command: SVN_CLIENT_COMMAND)
		do
		end

feature {NONE} -- Parsing utilities

	string_to_list(a_data: STRING_8): LIST[STRING_8]
			-- Return `a_data' split into lines separated by the newline character
		require
			data_not_void: a_data /= Void
		do
			create {ARRAYED_LIST[STRING_8]}Result.make(20)
			Result := a_data.split ('%N')
				-- Remove last line, because it is always empty
			Result.finish
			Result.remove
		end

	strip_blank_lines (a_list: LIST[STRING_8]): like a_list
		require
			list_not_void: a_list /= Void
		do
			create {LINKED_LIST[STRING_8]}Result.make
			from a_list.start
			until a_list.after
			loop
				if not (a_list.item_for_iteration.is_empty or a_list.item_for_iteration.is_equal ("%U")) then
					Result.extend (a_list.item_for_iteration)
				end
				a_list.forth
			end
		ensure
			count_less_or_equal: Result.count <= a_list.count
		end

	list_to_items (a_list: LIST[STRING_8]): LINKED_LIST[SVN_CLIENT_ITEM]
		require
			list_not_void: a_list /= Void
		local
			l_folder: STRING_8
			l_svn_folder: SVN_CLIENT_FOLDER
			l_svn_file: SVN_CLIENT_FILE
			l_subfolder: LINKED_LIST[STRING_8]
			l_same_subfolder: BOOLEAN
		do
			create Result.make
			from a_list.start
			until a_list.after
			loop
				if is_folder(a_list.item_for_iteration) then
						-- We have a folder. Recursively create items
					l_folder := path_component_at_index (a_list.item_for_iteration, 1)
					create l_svn_folder.make_with_name (l_folder)

					create l_subfolder.make

					from a_list.forth; l_same_subfolder := True
					until a_list.after or not l_same_subfolder
					loop
						if a_list.item_for_iteration.starts_with (l_folder) then
							l_subfolder.extend (a_list.item_for_iteration.substring (l_folder.count + 2, a_list.item_for_iteration.count))
							a_list.forth
						else
							l_same_subfolder := False
						end
					end
					l_svn_folder.append (list_to_items (l_subfolder))
					Result.extend (l_svn_folder)
				else
						-- We have a file
					create l_svn_file.make_with_name (a_list.item_for_iteration)
					Result.extend (l_svn_file)
				end
				if not a_list.after then
					a_list.forth
				end
			end
		end

	status_to_items (a_status_items, a_status_properties: LINKED_LIST[STRING_8]): LINKED_LIST[SVN_CLIENT_ITEM]
		require
			status_items_not_void: a_status_items /= Void
			status_properties_not_void: a_status_properties /= Void
			same_length: a_status_items.count = a_status_properties.count
		local
			l_folder: STRING_8
			l_svn_folder: SVN_CLIENT_FOLDER
			l_svn_file: SVN_CLIENT_FILE
			l_subfolder_items, l_subfolder_properties: LINKED_LIST[STRING_8]
			l_same_subfolder: BOOLEAN
		do
			create Result.make
			from a_status_items.start; a_status_properties.start
			until a_status_items.after
			loop
				if is_folder (a_status_items.item_for_iteration) then
						-- Recursively add items
					l_folder := path_component_at_index (a_status_items.item_for_iteration, 1)
					create l_svn_folder.make_with_name (l_folder)
					l_svn_folder.set_properties (a_status_properties.item_for_iteration)

					create l_subfolder_items.make
					create l_subfolder_properties.make

					-- If it has a folder or file after the slash, add it to the subfolder list
					if l_folder.count < a_status_items.item_for_iteration.count then
						l_subfolder_items.extend (a_status_items.item_for_iteration.substring (l_folder.count + 2, a_status_items.item_for_iteration.count))
						l_subfolder_properties.extend (a_status_properties.item_for_iteration)
					end

					from l_same_subfolder := True; a_status_items.forth; a_status_properties.forth
					until a_status_items.after or not l_same_subfolder
					loop
						if a_status_items.item_for_iteration.starts_with (l_folder) then
							l_subfolder_items.extend (a_status_items.item_for_iteration.substring (l_folder.count + 2, a_status_items.item_for_iteration.count))
							l_subfolder_properties.extend (a_status_properties.item_for_iteration)
							a_status_items.forth
							a_status_properties.forth
						else
							l_same_subfolder := False
							a_status_items.back
							a_status_properties.back
						end
					end
					l_svn_folder.append (status_to_items (l_subfolder_items, l_subfolder_properties))
					Result.extend (l_svn_folder)
				else
						-- Add file
					create l_svn_file.make_with_name (a_status_items.item_for_iteration)
					l_svn_file.set_properties (a_status_properties.item_for_iteration)
					Result.extend (l_svn_file)
				end
				if not a_status_items.after then
					a_status_items.forth
					a_status_properties.forth
				end
			end
		end

	is_folder (a_path: STRING_8): BOOLEAN
			-- Does `a_path' contain at least once the character '/' or
			-- does the first path component have no extension (there could be files with no extension though)?
		require
			path_not_void: a_path /= Void
		local
			l_split_path: LIST[STRING_8]
			l_first_path_component: STRING_8
		do
			l_split_path := a_path.split ('/')
			l_first_path_component := l_split_path.i_th (1)
				-- Return True if there's more than one path component or first path component has one character
			Result := l_split_path.count > 1 or l_first_path_component.count = 1
				-- Return True if there's no file extension after the first character (which could be a dot `.')
			Result := Result or (l_split_path.count = 1 and l_first_path_component.count > 1 and then l_first_path_component.index_of ('.', 2) = 0)
		end

	path_component_at_index (a_path: STRING_8; a_index: INTEGER): STRING_8
			-- Path component at index `a_index' of `a_path'. If `a_index' is greater than the number
			-- of path components, the last path component will be returned
		require
			path_not_void: a_path /= Void
			valid_index: a_index > 0
		local
			l_split_path: LIST [STRING_8]
		do
			l_split_path := a_path.split ('/')
			if a_index <= l_split_path.count then
				Result := l_split_path.i_th (a_index)
			else
				Result := l_split_path.last
			end
		end

end
