indexing
	description: "Objects that are observed"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	OBSERVED_CLASS

inherit

create
	make

feature -- Initialization

	make is
			-- create an observed object.
		do
			create unobserved_object.make
		end

feature -- Basic operations
	check_literal_string_from_unobserved is
			-- Test a literal string received from an unobserved object.
		local
			string: STRING
		do
			string := unobserved_object.read_literal_string
			if not string.is_equal ("literal string") then
				exceptions.raise ("literal string from UNOBSERVED_CLASS incorrect")
			end
		end

	check_string_from_file is
			-- test reading of a string from a file through an unobserved object.
		local
			string: STRING
			ignored_result: ANY
		do
			string := unobserved_object.read_from_file
			if not string.is_equal ("this is a line from the input file.") then
				exceptions.raise("string from file (via UNOBSERVED_CLASS) incorrect.")
			end
		end


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
	unobserved_object: UNOBSERVED_CLASS

	exceptions: EXCEPTIONS is
	 once
	 	create Result
	 end

invariant
	invariant_clause: True -- Your invariant here

end
