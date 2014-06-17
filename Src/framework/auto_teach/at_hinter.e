note
	description: "Summary description for {AT_HINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HINTER

inherit
	SHARED_WORKBENCH

	AT_SHARED_STRINGS

create
	make_with_options

feature {NONE} -- Initialization

	make_with_options (a_options: AT_OPTIONS)
			-- Initialization for `Current'.
		do
			options := a_options
			create input_classes.make
		end

feature -- Interface

	add_class (a_class: attached CONF_CLASS)
			-- Adds class `a_class'.
		do
			if attached {EIFFEL_CLASS_I} a_class as l_eiffel_class
				and then attached l_eiffel_class.compiled_class as l_compiled
			then
				input_classes.extend (l_compiled)
			else
				output_action.call ([at_strings.error_class_not_compiled (a_class.name)])
			end
		end

	set_output_action (a_action: PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]])
		do
			output_action := a_action
		end

feature {NONE} -- Implementation

	input_classes: LINKED_SET [CLASS_C]

	output_action: PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]]

	options: AT_OPTIONS

end
