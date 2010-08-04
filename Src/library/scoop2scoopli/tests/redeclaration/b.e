note
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	B


inherit
	A
		rename
			parent_function as child_function,
			parent_procedure as child_procedure,
			parent_attribute as child_attribute
		redefine
			child_function,
			child_procedure,
			child_attribute
		end

create
	make

feature -- Access

	child_function: D
	     do
			Result := create {D}
	     end

	child_procedure (a, b: separate D; c: separate D)
	     do
	     end

	child_attribute: D

end
