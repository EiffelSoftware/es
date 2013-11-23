note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_AUTOPROOF_ERROR

feature -- Access

	eiffel_class: detachable CLASS_C
			-- Related Eiffel class (if any)

	eiffel_feature: detachable FEATURE_I
			-- Related Eiffel feature (if any)

	type: STRING
			-- Type of error.

	single_line_message: STRING
			-- Short one-line message about error.

	multi_line_message: STRING
			-- Long multi-line message about error.

feature -- Element change

	set_eiffel_class (a_class: CLASS_C)
			-- Set `eiffel_class' to `a_class'.
		require
			eiffel_feature_not_set: eiffel_feature = Void
		do
			eiffel_class := a_class
		end

	set_eiffel_feature (a_feature: FEATURE_I)
			-- Set `eiffel_feature' to `a_feature'.
		require
			eiffel_class_not_set: eiffel_class = Void
		do
			eiffel_feature := a_feature
			eiffel_class := a_feature.written_class
		end

	set_type (a_string: STRING)
			-- Set `type' to `a_type'.
		do
			type := a_string
		end

	set_single_line_message (a_string: STRING)
			-- Set `single_line_message' to `a_string'.
		do
			single_line_message := a_string
		end

	set_multi_line_message (a_string: STRING)
			-- Set `multi_line_message' to `a_string'.
		do
			multi_line_message := a_string
		end

end
