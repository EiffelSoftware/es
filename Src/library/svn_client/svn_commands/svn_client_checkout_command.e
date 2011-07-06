note
	description: "Object that checks out a working copy from a repository."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_CHECKOUT_COMMAND

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
			put_option ("--non-interactive", "")
			put_option ("--trust-server-cert", "")
		end

feature {NONE} -- Result parsing

	parse_result (a_svn_parser: SVN_PARSER)
		do
			a_svn_parser.parse_checkout (Current)
		end

feature {NONE} -- Implementation

	command_name: STRING_8
		do
			Result := "checkout"
		end

end
