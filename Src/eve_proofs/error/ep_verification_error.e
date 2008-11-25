indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_VERIFICATION_ERROR

inherit

	EP_ERROR
		redefine
			build_explain
		end

create
	make

feature -- Access

	description: STRING
			-- Description of error

	tag: STRING
			-- Tag which is violated

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

	set_tag (a_tag: like tag)
			-- Set `tag' to `a_tag'.
		require
			a_tag_not_void: a_tag /= Void
		do
			tag := a_tag
		ensure
			tag_set: tag.is_equal (a_tag)
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
			a_text_formatter.add_new_line

			check class_c /= Void end
			check e_feature /= Void end

			a_text_formatter.add ("Class: ")
			class_c.append_name (a_text_formatter)
			a_text_formatter.add_new_line
			a_text_formatter.add ("Feature: ")
			e_feature.append_name (a_text_formatter)
			a_text_formatter.add_new_line
			if tag /= Void then
				a_text_formatter.add ("Tag: ")
				a_text_formatter.add (tag)
			else
				a_text_formatter.add ("Unnamed assertion")
			end
			a_text_formatter.add_new_line
		end

end
