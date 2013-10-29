note
	description: "Summary description for {CA_SHARED_NAMES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_SHARED_NAMES

feature -- Names

	ca_names: CA_NAMES
		once
			create Result
		end

	ca_messages: CA_MESSAGES
		once
			create Result
		end

end
