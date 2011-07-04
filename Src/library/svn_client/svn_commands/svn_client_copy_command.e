note
	description: "Summary description for {SVN_CLIENT_COPY_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_COPY_COMMAND

inherit
	SVN_CLIENT_COMMAND
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_svn_client: SVN_CLIENT)
		do
			Precursor (a_svn_client)
			create source.make_from_string (".")
		end

feature -- Element change

	set_source (a_source: like source)
		require
			valid_source: a_source /= Void and then not a_source.is_empty
		do
			source := a_source
		end

feature -- Access

	source: STRING_8


feature {NONE} -- Result parsing

	parse_result (a_svn_parser: SVN_PARSER)
		do
		end

feature {NONE} -- Implementation

	command_name: STRING_8
		do
			Result := "copy"
		end

end
