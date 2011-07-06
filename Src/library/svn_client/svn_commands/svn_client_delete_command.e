note
	description: "Object that removes files and directories from version control."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_DELETE_COMMAND

inherit
	SVN_CLIENT_COMMAND

create
	make

feature {NONE} -- Result parsing

	parse_result (a_svn_parser: SVN_PARSER)
		do
		end

feature {NONE} -- Implementation

	command_name: STRING_8
		do
			Result := "delete"
		end

end
