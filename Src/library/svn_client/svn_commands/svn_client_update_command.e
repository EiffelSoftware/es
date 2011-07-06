note
	description: "Object that brings changes from the repository into the working copy."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_UPDATE_COMMAND

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
			Result := "update"
		end

end
