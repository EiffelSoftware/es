note
	description: "Summary description for {SVN_CLIENT_LIST_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_LIST_COMMAND

inherit
	SVN_CLIENT_COMMAND
		rename
			target as target_url,
			set_target as set_target_url
		redefine
			execute,
			command_did_finish
		end

create
	make

feature -- Execute

	execute
		local
			l_args: LINKED_LIST[STRING_8]
		do
				-- Clear last result and internal last result
			set_last_result (Void)
			set_internal_last_result (Void)
				-- Initialize internal last result
			create internal_last_result.make

			create l_args.make
			l_args.extend (command_name)
			l_args.extend (target_url)
			l_args.append (options_to_args)

			launch_process (l_args)
		end

feature -- Access

	last_list: detachable SVN_CLIENT_FOLDER
		-- Return last result for svn list command

feature {NONE} -- Implementation

	command_name: STRING_8
		do
			Result := "list"
		end

	command_did_finish
			-- Build tree hierarchy of the repository only after the list command successfully completed
		do
			create last_list.make_with_name (target_url)
			last_list.recursively_add_items (internal_last_result)

			Precursor
		end

end
