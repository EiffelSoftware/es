note
	description: "Object that lists directory entries in the repository."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_LIST_COMMAND

inherit
	SVN_CLIENT_COMMAND
		redefine
			command_did_finish
		end

create
	make

feature -- Access

	last_list: detachable SVN_CLIENT_FOLDER
		-- Return last result for svn list command in a tree hierarchy structure

feature {NONE} -- Result parsing

	parse_result (a_svn_parser: SVN_PARSER)
		do
			a_svn_parser.parse_list (Current)
		end

feature {SVN_PARSER}

	set_last_list (a_list: detachable like last_list)
		do
			last_list := a_list
		end

feature {NONE} -- Implementation

	command_name: STRING_8
		do
			Result := "list"
		end

	command_did_finish
			-- Build tree hierarchy of the repository only after the list command successfully completed
		do
			set_last_result (internal_last_result)
			parse_result (svn_client.parser)

			Precursor
		end

end
