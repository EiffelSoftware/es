note
	description: "Object that sends changes from the working copy to the repository."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_COMMIT_COMMAND

inherit
	SVN_CLIENT_COMMAND
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make(a_svn_client: SVN_CLIENT)
		do
			Precursor (a_svn_client)
			put_option ("-m", "")
		end

feature {NONE} -- Result parsing

	parse_result (a_svn_parser: SVN_PARSER)
		do
			a_svn_parser.parse_commit (Current)
		end

feature {NONE} -- Implementation

	command_name: STRING_8
		do
			Result := "commit"
		end

end
