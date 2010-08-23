note
	description: "Summary description for {E2B_TRANSLATOR_INPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TRANSLATOR_INPUT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize empty input.
		do
			create class_list.make
			create feature_list.make
		end

feature -- Acces

	class_list: LINKED_LIST [CLASS_C]
			-- List of classes to be translated.

	feature_list: LINKED_LIST [FEATURE_I]
			-- List of features to be translated.

end
