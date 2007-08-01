indexing
	description: "Objects that are not observed"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	UNOBSERVED_CLASS
inherit
	ANY
	redefine
		is_observed
	end

create
	make

feature -- Initialization
	make is
			-- Create an object of UNOBSERVED_CLASS
		do
			create file.make("input.txt")
			file.open_read
		end

feature -- Access
	is_observed: BOOLEAN is False

	read_literal_string: STRING is
			--
		do
			Result := "literal string"
			Result.get_area.note_direct_manipulation (Result.get_area)
		end

	read_from_file: STRING is
		do
			file.read_line
			Result := file.last_string
			-- This would belong to the FILE class:
			Result.get_area.note_direct_manipulation(Result.get_area)
		end


feature {NONE} -- Implementation
	file: KL_TEXT_INPUT_FILE

invariant
	invariant_clause: True -- Your invariant here

end
