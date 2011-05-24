note
	description: "Summary description for {SVN_CLIENT_ADD_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_ADD_COMMAND

inherit
	SVN_CLIENT_COMMAND

create
	make

feature {NONE} -- Implementation

	command_name: STRING_8
		do
			Result := "add"
		end

end
