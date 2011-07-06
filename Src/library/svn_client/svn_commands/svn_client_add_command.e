note
	description: "Object that puts files and folders under version control."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_ADD_COMMAND

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
			Result := "add"
		end

end
