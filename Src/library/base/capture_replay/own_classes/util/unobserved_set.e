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
			create unobserved_class_names.make (40)
			unobserved_class_names.set_equality_tester (create {KL_STRING_EQUALITY_TESTER})

			unobserved_class_names.put ("ACTION_SEQUENCE")
			unobserved_class_names.put ("CONSOLE")
			unobserved_class_names.put ("C_STRING")
			unobserved_class_names.put ("FUNCTION")
			unobserved_class_names.put ("PROCEDURE")
			unobserved_class_names.put ("POINTER")
			unobserved_class_names.put ("STD_FILES")
			unobserved_class_names.put ("STRING_32")
			unobserved_class_names.put ("MANAGED_POINTER")
		end

feature -- Access

	has_class_name (class_name: STRING): BOOLEAN is
			-- Is the class with name `class_name' in the unobserved_set?
		do
			if class_name.substring (1, 3).is_equal("EV_") then
				-- The whole Vision2 library is unobserved...
				Result := True
			else
				Result := unobserved_class_names.has (class_name)
			end
		end

	has_object (obj: ANY): BOOLEAN is
			--
		local
			class_name: STRING
			end_of_class_name: INTEGER
		do
			class_name := obj.generating_type
			end_of_class_name := class_name.index_of (' ', 1)
			if end_of_class_name /= 0 then
				class_name := class_name.substring (1, end_of_class_name - 1)
			end
			Result := has_class_name (class_name)
		end



feature {NONE} -- Implementation

	unobserved_class_names: DS_HASH_SET [STRING]

invariant
	invariant_clause: True -- Your invariant here

end
