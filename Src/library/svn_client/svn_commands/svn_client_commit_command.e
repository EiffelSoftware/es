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
			execute
		end

create
	make

feature -- Execute

	execute
		do
			if not options.has (svn_client.commit_options.message) then
				put_option (svn_client.commit_options.message, "")
			end
			Precursor
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
