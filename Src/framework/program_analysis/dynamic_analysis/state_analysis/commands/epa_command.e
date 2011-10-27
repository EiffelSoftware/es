note
	description: "Commands for annotation collection"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_COMMAND

feature -- Access

	config: EPA_CONFIG
			-- Config for annotation collection

feature -- Basic operations

	execute
			-- Execute Current command
		deferred
		end

end
