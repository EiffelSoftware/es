note
	description: "Unspedified domain for a function"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_UNSPECIFIED_DOMAIN

inherit
	CI_DOMAIN
		redefine
			is_unspecified
		end

feature -- Status report

	is_unspecified: BOOLEAN = True
			-- Does current represent an unspecified domain?

end
