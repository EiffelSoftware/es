indexing
	description : "This test case is used to test redeclarations."
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			non_separate_result: D
			separate_result: separate D

			a: A
			b: B
		do
			create a.make
			create b.make

			separate_result := a.parent_function
			a.parent_procedure (create {separate D}, create {D}, create {separate D})
			separate_result := a.parent_attribute

			non_separate_result := b.child_function
			b.child_procedure (create {separate D}, create {separate D}, create {separate D})
			non_separate_result := b.child_attribute

			a := b
			separate_result := a.parent_function
			a.parent_procedure (create {separate D}, create {D}, create {separate D})
			separate_result := a.parent_attribute
		end
end
