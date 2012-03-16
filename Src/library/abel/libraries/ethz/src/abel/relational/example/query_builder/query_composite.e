note
	description: "Summary description for {QUERY_COMPOSITE}."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	QUERY_COMPOSITE [G -> ANY create default_create end]

inherit

	CONSTANTS

	QUERY_PART

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create children.make (10)
		end

feature -- Access

feature -- Basic operations

	add_part (p: QUERY_PART)
			-- Build a query sub-element.
		do
			children.extend (p)
		end

	output: STRING
			-- String representation of `Current'.
			-- Consider using a helper class (a builder) to control the building process and make sure
			-- that the necessary objects are there, that no redundant objects are present.
			-- The idea is to enforce a declarative approach where what is needed is:
			-- A CRUD command: create | read | update | delete
			-- An optional target: the table on which to perform the CRUD operation. Default is indicated by mapping.
			-- An optional projection: the table columns. Default is all.
			-- An optional selection: default is none.
		local
			is_where_clause_needed: BOOLEAN
			is_first_projection: BOOLEAN
		do
			from
				create Result.make_empty
				children.start
				is_where_clause_needed := True
				is_first_projection := True
			until
				children.after
			loop
				if children.item.generator.is_equal ("SELECTION") and is_where_clause_needed then
					Result.append_string (" WHERE ")
					is_where_clause_needed := False
				end
				if children.item.generator.is_equal ("PROJECTION") then
					if is_first_projection then
						is_first_projection := False
					else
						Result.append_string (", ")
					end
				end
				if children.item.generator.is_equal ("TABLE_NAME") then
					Result.append_string (" FROM ")
				end
				Result.append_string (children.item.output)
				children.forth
			end
			Result.append_string (";")
		end

feature {NONE} -- Implementation

	children: ARRAYED_LIST [QUERY_PART]
	-- A query can have 0..n children parts.

invariant
	invariant_clause: True -- Your invariant here

end
