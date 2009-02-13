indexing
	description:
		"[
			Error in verification with an associated tag and possibly a called feature.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_VERIFICATION_ERROR

inherit

	EP_ERROR
		redefine
			build_explain,
			trace_single_line
		end

create
	make

feature -- Access

	tag: STRING
			-- Tag which is violated

	associated_feature: E_FEATURE
			-- Feature associated with error

feature -- Element change

	set_tag (a_tag: like tag)
			-- Set `tag' to `a_tag'.
		require
			a_tag_not_void: a_tag /= Void
		do
			tag := a_tag
		ensure
			tag_set: tag.is_equal (a_tag)
		end

	set_associated_feature (a_feature: FEATURE_I)
			-- Set `associated_feature' to `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
		do
			associated_feature := a_feature.api_feature (a_feature.written_in)
		end

feature -- Output

	build_explain (a_text_formatter: TEXT_FORMATTER)
			-- Build specific explanation image for current error
			-- in `error_window'.
		do
			if description /= Void then
				a_text_formatter.add (description)
			else
				a_text_formatter.add (names.description_no_description)
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
			if associated_feature /= Void then
				a_text_formatter.add_new_line
				a_text_formatter.add ("Associated feature: ")
				a_text_formatter.add ("{")
				associated_feature.written_class.append_name (a_text_formatter)
				a_text_formatter.add ("}.")
				associated_feature.append_full_name (a_text_formatter)
				a_text_formatter.add_new_line
			end
			if tag /= Void then
				a_text_formatter.add ("Tag: ")
				a_text_formatter.add (tag)
			else
				a_text_formatter.add ("Unnamed assertion")
			end
			a_text_formatter.add_new_line
		end

	trace_single_line (a_text_formatter: TEXT_FORMATTER) is
			-- Display short error, single line message in `a_text_formatter'.
		do
			Precursor {EP_ERROR} (a_text_formatter)
			if tag /= Void then
				a_text_formatter.add_space
				a_text_formatter.add ("(")
				a_text_formatter.add ("tag: ")
				a_text_formatter.add (tag)
				a_text_formatter.add (")")
			end
		end

end
