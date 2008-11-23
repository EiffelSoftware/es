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
			build_explain,
			has_associated_file,
			is_defined
		end

create
	make

feature -- Access

	description: STRING
			-- Description of error

feature -- Status report

	is_defined: BOOLEAN is True
			-- Is error fully defined?

	has_associated_file: BOOLEAN is False
			-- Does error have an associated file?

feature -- Element change

	set_description (a_text: STRING)
			-- Set `description' to `a_text'.
		require
			a_text_not_void: a_text /= Void
		do
			description := a_text
		ensure
			description_set: description.is_equal (a_text)
		end

feature -- Output

	build_explain (a_text_formatter: TEXT_FORMATTER)
			-- Build specific explanation image for current error
			-- in `error_window'.
		do
			if description /= Void then
				a_text_formatter.add (description)
			else
					-- TODO: internationalization
				a_text_formatter.add ("No description available")
			end
			a_text_formatter.add_new_line
		end

end
