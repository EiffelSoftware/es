note
	description: "Object that duplicates files or folders in working copy or repository, remembering history."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_COPY_COMMAND

inherit
	SVN_CLIENT_COMMAND
		redefine
			make,
			execute
		end

create
	make

feature {NONE} -- Initialization

	make (a_svn_client: SVN_CLIENT)
		do
			Precursor (a_svn_client)
			create source.make_from_string (".")
		end

feature -- Execute

	execute
		-- Perform command for target `target' and options `options'
		local
			l_args: LINKED_LIST[STRING_8]
		do
			initialize_last_result

			create l_args.make
			l_args.extend (command_name)
			l_args.extend (source)
			l_args.extend (target)
			l_args.append (options_to_args)

			launch_process (l_args)
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
