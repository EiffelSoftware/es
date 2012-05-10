note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_ASSERTION_INFORMATION

create
	make

feature {NONE} -- Initialization

	make (a_type: STRING)
			-- Initialize assertion information.
		do
			type := a_type.twin
		ensure
			type_set: type ~ a_type
		end

feature -- Access

	type: STRING
			-- Type of assertion.

	tag: STRING
			-- Tag of assertion.

	line: STRING
			-- Line in source file.

feature -- Element change

	set_tag (a_tag: STRING)
			-- Set `tag' to `a_tag'.
		do
			if a_tag = Void then
				tag := Void
			else
				tag := a_tag.twin
			end
		ensure
			tag_set: tag ~ a_tag
		end

	set_line (a_line: INTEGER)
			-- Set `line' to `a_line'.
		do
			if a_line > 0 then
				line := a_line.out
			else
				line := Void
			end
		end

end
