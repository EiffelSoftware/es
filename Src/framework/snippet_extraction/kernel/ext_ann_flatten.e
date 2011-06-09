note
	description: "Class that represents an annotation indicating that how an `{IF_AS}' AST subtree should be transformed"
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_ANN_FLATTEN

inherit
	EXT_ANNOTATION

create
	make_with_mode

feature -- Initialization

	make_with_mode (a_mode: STRING)
		do
			set_mode (a_mode)
		end

feature -- Constants

	retain_if: STRING = "retain_if"

	retain_else: STRING = "retain_else"

feature -- Access

	mode: STRING
		assign set_mode

	set_mode (a_mode: STRING)
		require
			a_mode ~ retain_if or a_mode ~ retain_else
		do
			mode := a_mode
		end

end
