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
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
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
				output_action.call ([at_strings.class_not_compiled (a_class.name)])
			end
		end

	set_output_action (a_action: PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]])
		do
			output_action := a_action
		end

feature {NONE} -- Implementation

	input_classes: LINKED_SET [CLASS_C]

	output_action: PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]]

end
