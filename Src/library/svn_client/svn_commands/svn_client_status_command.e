note
	description: "Summary description for {SVN_CLIENT_STATUS_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_STATUS_COMMAND

inherit
	SVN_CLIENT_COMMAND
		redefine
			execute,
			command_did_finish
		end
create
	make

feature -- Execute

	execute
		do
				-- Clear last status
			set_last_status (Void)
			Precursor
		end

feature -- Access

	last_status: detachable SVN_CLIENT_FOLDER
		-- Last svn status for current `working_path'

feature {NONE} -- Result parsing

	parse_result (a_svn_parser: SVN_PARSER)
		do
			a_svn_parser.parse_status (Current)
		end

feature {SVN_PARSER} -- Element change

	set_last_status (a_status: detachable like last_status)
		do
			last_status := a_status
		end

feature {NONE} -- Implementation

	command_name: STRING_8
		do
			Result := "status"
		end

	command_did_finish
		do
			set_last_result (internal_last_result)
			set_internal_last_result (Void)

			parse_result (svn_client.parser)

			Precursor
		end

end
