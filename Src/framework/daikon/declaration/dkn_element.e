note
	description: "Daikon element"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DKN_ELEMENT

feature -- Access

	daikon_name: STRING
			-- Name of current element
			-- This is the name directly output to Daikon related files,
			-- thus, space are encoded as "\_", for example, "has\_(o)".
			-- If you want to get an decoded name, use `interface_name'.

	name: STRING
			-- Name of current element, with normal space

end
