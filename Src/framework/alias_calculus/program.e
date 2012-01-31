note
	description: "Summary description for {PROGRAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROGRAM

inherit
	INSTRUCTION
		rename
			copy as instruction_copy, is_equal as instruction_is_equal
		redefine
			is_applicable
		select
			out
		end

	HASH_TABLE [PROCEDURE1, STRING]
		rename
			make as ht_make, out as old_out
		select
			copy, is_equal
			-- FIXME write specific versions BM 21.11.2009
		end

create
	make

feature -- Initialization

	make (pn: STRING)
			-- Initialize with `p'as the name of the procedure to execute.
		require
			exists: pn /= Void
			non_empty: not pn.is_empty
		do
			ht_make (Min_proc)
			main_name := pn
		ensure
			set: main_name = pn
		end

feature -- Access

	main: PROCEDURE1
			-- Name of procedure to call for this program
			-- (i.e. main program).
		require
			has_main
		do
			Result := item (main_name)
		end



feature -- Status report

	is_applicable (a: ALIAS_RELATION): BOOLEAN
			-- Is conditioal ready to be applied to ` a' ?
		do
			Result := main_body /= Void and then main_body.is_applicable (a)
		end


	is_indenting: BOOLEAN
			-- Should sub-components be indented one more level?
			-- Here no.
		do
			Result := True
		end

	has_main: BOOLEAN
			-- Is there a procedure of the expected name?
		do
			Result := main_name /= Void and then not main_name.is_empty and then has (main_name)
		end

feature -- Input and output

	out: STRING
			-- Printable representation of program.
			-- No indentation (taken care of by the program's elements).
		do
			create Result.make_from_string ("Program (main procedure: " + main.name + ")" + New_line)
			across Current as c loop Result := Result + c.item.out end
		end

feature -- Basic operations

	update (a: ALIAS_RELATION)
			-- Make `a' include aliases induced by main procedure.
		do
			main.update (a)
		end

feature {NONE} -- Implementation

	main_name: STRING
			-- Name of main procedure.

	main_body: COMPOUND
			-- Instruction of main procedure.
		do
			Result := main.body
		ensure
			definition: Result = main.body
		end

	Min_proc: INTEGER = 20
			-- Initial number of procedures in program.

invariant

	main_exists: main_name /= Void
	main_not_empty: not main_name.is_empty

end
