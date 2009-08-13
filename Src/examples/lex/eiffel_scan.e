note
	legal: "See notice at end of class."
	status: "See notice at end of class."
-- Example of a lexical analyzer based on the Eiffel syntax.
-- The analyzer itself is found in the file ``eiffel_lex'', which
-- is created according to the file  ``eiffel_token'' if not
-- previously built and stored.

class EIFFEL_SCAN

inherit
	SCANNING
		rename
			make as scanning_make
		redefine
			analyze
		end;

create
	make

feature {NONE} -- Initialization

	make
			-- Create a lexical analyser for Eiffel,
		do
			scanning_make;
			build ("eiffel_lex", "eiffel_regular");
		end

feature -- Basic operations

	analyze (file_name: STRING)
			-- <Precursor>
		do
			io.putstring ("Scanning file `");
			io.putstring (file_name);
			io.putstring ("'.%N");
			Precursor (file_name)
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"


end -- class EIFFEL_SCAN

