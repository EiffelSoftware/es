indexing
	description : "A parent."
	date        : "$Date$"
	revision    : "$Revision$"


class
	PARENT

inherit
	GRAND_PARENT
		rename
			grand_parent_procedure as parent_procedure,
			grand_parent_function as parent_function
		redefine
			parent_procedure,
			parent_function
		end
	GRAND_PARENT
		rename
			grand_parent_procedure as parent_procedure,
			grand_parent_function as parent_function
		undefine
			parent_procedure,
			parent_function
		end

feature
	parent_procedure (a_argument: attached separate APPLICATION)
		do
		end

	parent_function (a_argument: attached separate APPLICATION): BOOLEAN
		do
		end
end
