note
	description: "Commands for annotation collection"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ANN_COMMAND

feature -- Access

	config: ANN_CONFIG
			-- Config for annotation collection

feature -- Basic operations

	execute
			-- Execute Current command
		deferred
		end

end
