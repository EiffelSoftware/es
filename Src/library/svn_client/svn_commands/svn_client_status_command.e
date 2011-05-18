note
	description: "Summary description for {SVN_CLIENT_STATUS_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_STATUS_COMMAND

inherit
	SVN_CLIENT_COMMAND
		redefine
			execute,
			command_data_received,
			command_did_finish
		end
create
	make

feature -- Execute

	execute
		do
				-- Clear last status and internal last status
			set_last_status (Void)
			set_internal_last_status (Void)
				-- Initialize last_status and internal_last_status
			create last_status.make
			create internal_last_status.make

			Precursor
		end

feature -- Access

	last_status: detachable LINKED_LIST[ARRAY[STRING_8]]
		-- Return svn status for current `working_path' and depth `depth'


feature {NONE} -- Implementation

	command_name: STRING_8
		do
			Result := "status"
		end

	set_last_status (a_status: like last_status)
		do
			last_status := a_status
		ensure
			last_status_set: last_status = a_status
		end

	set_internal_last_status (a_status: like internal_last_status)
		do
			internal_last_status := a_status
		ensure
			internal_last_status_set: internal_last_status = a_status
		end

	command_data_received (a_data_received: STRING_8)
		local
			l_data_list: LIST[STRING_8]
			l_status_list: LINKED_LIST[ARRAY[STRING_8]]
			l_status_item: ARRAY[STRING_8]
			l_item: STRING_8
		do
			l_data_list := parse_string_to_list (a_data_received)
			create l_status_list.make

			from l_data_list.start
			until l_data_list.after
			loop
				l_item := l_data_list.item_for_iteration
				create l_status_item.make_filled ("", 1, 2)
				-- Characters from 1 to 7: status, properties, locked (remaining 4 chars not relevant yet)
				-- TODO: create a list of SVN_ITEMs instead. The class has then properties like is_modified, is_locked, ...
				l_status_item[1] := l_item.substring (1, 7)

				-- Characters from 9 to end: directory or file name
				l_status_item[2] := l_item.substring (9, l_item.count)
				l_status_list.extend (l_status_item)

				l_data_list.forth
			end

			internal_last_status.append (l_status_list)

			Precursor (a_data_received)
		end

	command_did_finish
		do
			set_last_status (internal_last_status)
			set_internal_last_status (Void)
			Precursor
		end

	internal_last_status: detachable like last_status
		-- Temporary svn status

end
