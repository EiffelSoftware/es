note
	description: "Input to translator."
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
		ensure
			class_list_empty: class_list.is_empty
			feature_list_empty: feature_list.is_empty
		end

feature -- Acces

	class_list: attached LINKED_LIST [attached CLASS_C]
			-- List of classes to be translated.

	feature_list: attached LINKED_LIST [attached FEATURE_I]
			-- List of features to be translated.

feature -- Element change

	add_class (a_class: attached CLASS_C)
			-- Add `a_class' to be translated.
		do
			class_list.extend (a_class)
		end

	add_feature (a_feature: attached FEATURE_I)
			-- Add `a_feature' to be translated.
		do
			feature_list.extend (a_feature)
		end

end
