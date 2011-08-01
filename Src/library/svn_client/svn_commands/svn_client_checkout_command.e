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
			execute
		end

create
	make

feature -- Execute

	execute
		do
			put_option (svn_client.global_options.non_interactive, "")
			put_option (svn_client.global_options.trust_server_certificates, "")
			Precursor
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
