indexing
	description:
		"[
			Context information of current processing
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_CONTEXT

feature -- Access

	current_class: CLASS_C
			-- Class which is currently being processed

	current_feature: FEATURE_I
			-- Feature which is currently being processed

	line_number: INTEGER
			-- Source line number of current instruction (if known)

	column_number: INTEGER
			-- Column number of current instruction (if known)

feature -- Element change

	set_current_class (a_class: like current_class)
			-- Set `current_class' to `a_feature'.
		do
			current_class := a_class
		ensure
			current_class_set: current_class = a_class
		end

	set_current_feature (a_feature: like current_feature)
			-- Set `current_feature' to `a_feature'.
		do
			current_feature := a_feature
		ensure
			current_feature_set: current_feature = a_feature
		end

	set_line_number (a_value: like line_number)
			-- Set `line_number' to `a_value'.
		do
			line_number := a_value
		ensure
			line_number_set: line_number = a_value
		end

	set_column_number (a_value: like column_number)
			-- Set `column_number' to `a_value'.
		do
			column_number := a_value
		ensure
			column_number_set: column_number = a_value
		end

	set_location (a_location: LOCATION_AS)
			-- Set `line_number' and `column_number' from `a_location'.
		do
			line_number := a_location.line
			column_number := a_location.column
		ensure
			line_number_set: line_number = a_location.line
			column_number_set: column_number = a_location.column
		end

feature -- Basic operations

	reset
			-- Reset context.
		do
			current_class := Void
			current_feature := Void
			line_number := 0
			column_number := 0
		end

end
