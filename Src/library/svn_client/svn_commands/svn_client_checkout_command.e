note
	description: "Summary description for {SVN_CLIENT_CHECKOUT_COMMAND}."
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
		require else
			checkout_url_valid: is_checkout_url_valid
		local
			l_args: LINKED_LIST[STRING_8]
		do
			create l_args.make
			l_args.extend (command_name)
			l_args.extend (checkout_url)
			l_args.append (options_to_args)

			launch_process (l_args)
		end

	is_checkout_url_valid: BOOLEAN
			-- Return True if checkout_url is a valid repository address. A reg exp could be used
			-- to verify that the string represents indeed a valid svn URL (TODO)
		do
			Result := checkout_url /= Void and then not checkout_url.is_empty
		end

feature -- Element change

	set_checkout_url(a_checkout_url: detachable like checkout_url)
		do
			checkout_url := a_checkout_url
		end

feature {NONE} -- Implementation

	command_name: STRING_8
		do
			Result := "checkout"
		end

	checkout_url: detachable STRING_8

end
