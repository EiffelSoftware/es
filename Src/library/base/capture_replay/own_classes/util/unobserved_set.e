indexing
	description: "[
				   The set of unobserved classes.
				   Override this class to change the set of unobserved classes.
				   ]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	UNOBSERVED_SET

create
		make

feature -- Initialization
	make is
			-- Create a hashtable that contains the names of the classes
			-- that aren't observed.
		do
			create observed_class_names.make (10)
			observed_class_names.put ("CONSOLE")
			observed_class_names.put ("STD_FILES")
			observed_class_names.put ("EV_TITLED_WINDOW_IMP")
			observed_class_names.put ("EV_LITE_ACTION")
			observed_class_names.put ("EV_WINDOW_I")
			observed_class_names.put ("EV_VERTICAL_BOX")
			observed_class_names.put ("EV_LABEL")
			observed_class_names.put ("EV_TEXT_FIELD")
			observed_class_names.put ("EV_BUTTON")
			observed_class_names.put ("EV_FRAME")
			observed_class_names.put ("EV_VERTICAL_BOX")
			observed_class_names.put ("EV_APPLICATION")
			observed_class_names.put ("EV_APPLICATION_IMP")
			observed_class_names.put ("POINTER")
		end

feature -- Access

	has_class_name (class_name: STRING): BOOLEAN is
			-- Is the class with name `class_name' in the unobserved_set?
		do
			Result := observed_class_names.has (class_name)
		end

	has_object (obj: ANY): BOOLEAN is
			--
		local
			class_name: STRING
			end_of_class_name: INTEGER
		do
			class_name := Current.generating_type
			end_of_class_name := class_name.index_of (' ', 1)
			if end_of_class_name /= 0 then
				class_name := class_name.substring (0, end_of_class_name)
			end

			Result := not has_class_name (class_name)
		end



feature {NONE} -- Implementation

	observed_class_names: DS_HASH_SET [STRING]

invariant
	invariant_clause: True -- Your invariant here

end
