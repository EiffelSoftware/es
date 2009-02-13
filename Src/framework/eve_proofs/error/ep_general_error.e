indexing
	description:
		"[
			A general error which is not associated with a file.
			The error has a short message and a description.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_GENERAL_ERROR

inherit

	EP_ERROR
		redefine
			has_associated_file,
			is_defined
		end

create
	make

feature -- Status report

	is_defined: BOOLEAN is True
			-- Is error fully defined?

	has_associated_file: BOOLEAN is False
			-- Does error have an associated file?

end
