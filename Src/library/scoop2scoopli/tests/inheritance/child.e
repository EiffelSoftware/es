indexing
	description : "A non-expanded child."
	date        : "$Date$"
	revision    : "$Revision$"


class
	CHILD

inherit
	PARENT
		rename
			parent_procedure as child_procedure,
			parent_function as child_function
		redefine
			child_procedure,
			child_function
		end

create
	child_procedure

feature
	child_procedure (a_argument: attached separate APPLICATION)
		do
		end

	child_function (a_argument: attached separate APPLICATION): BOOLEAN
		do
		end
end
