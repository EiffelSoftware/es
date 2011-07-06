note
	description: "Object that shows the log messages for a set of revision(s) and/or file(s)."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_LOG_COMMAND

inherit
	SVN_CLIENT_COMMAND

create
	make

feature {NONE} -- Result parsing

	parse_result (a_svn_parser: SVN_PARSER)
		do
			a_svn_parser.parse_log (Current)
		end

feature {NONE} -- Implementation

	command_name: STRING_8
		do
			Result := "log"
		end

end
