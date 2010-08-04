note
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	A
	
create
	make

feature {NONE} -- Initialization

	make
		do
			parent_attribute := create {separate D}
		end

feature -- Access

	parent_function: separate D
	     do
			Result := create {separate D}
	     end

	parent_procedure (a: separate D; b: D; c: separate D)
		do
		end

	parent_attribute: separate D

end
