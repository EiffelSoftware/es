note
	description: "first design of a query_builder"
	date: "$Date$"
	revision: "$Revision$"

class
	QUERY_MANAGER

inherit

	CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			create_query_full_projection
			create_query_custom_projection
		end

	create_query_full_projection
			-- Create a query projecting all attributes of an object into columns of a table
		local
			q: QUERY_COMPOSITE [PERSON_]
			validator: QUERY_VALIDATOR [PERSON_]
		do
			create q.make
				-- This can be added automatically depending on which object is created (query, update, insert, delete)
			q.add_part (select_)
				-- This has to be fixed not to use * but to read all the attributes of an object and look in the mapping
				-- for the corresponding table columns.
			q.add_part (all_)
				-- This can be done automatically by default, given that a class-table mapping is selected.
			q.add_part (create {TABLE_NAME}.make_from_string ("Person"))
				-- The mapper will take care of mapping the attribute names to column names
			q.add_part (create {SELECTION [INTEGER]}.make ("items_owned", gt, 5))
			q.add_part (Or_)
			q.add_part (create {SELECTION [INTEGER]}.make ("items_owned", eq, 3))
			q.add_part (And_)
			q.add_part (create {SELECTION [STRING]}.make ("first_name", eq, "Pippo"))
			create validator
			if validator.is_validated (q) then
			end
			print (q.output)
		end

	create_query_custom_projection
			-- Create a query projecting a custom set of attributes of an object into the correspondent columns of a table
		local
			q: QUERY_COMPOSITE [PERSON_]
		do
			create q.make
			q.add_part (select_)
			q.add_part (create {PROJECTION}.make_with_attribute ("first_name"))
			q.add_part (create {PROJECTION}.make_with_attribute ("items_owned"))
			q.add_part (create {TABLE_NAME}.make_from_string ("Person"))
			q.add_part (create {SELECTION [INTEGER]}.make ("items_owned", gt, 5))
			q.add_part (Or_)
			q.add_part (create {SELECTION [INTEGER]}.make ("items_owned", eq, 3))
			q.add_part (And_)
			q.add_part (create {SELECTION [STRING]}.make ("first_name", eq, "Pippo"))
			print (q.output)
		end

end
