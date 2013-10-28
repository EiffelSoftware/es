note
	description: "Summary description for {CA_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_FIX

create
	make

feature {NONE} -- Implementation
	make (a_class: CLASS_C)
		do
			class_to_change := a_class
		end

feature -- Commands

	apply
		do

		end

feature -- Properties

	class_to_change: CLASS_C

end
