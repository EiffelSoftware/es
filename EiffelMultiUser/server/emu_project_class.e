indexing
	description: "A class of a project. Residing in a project cluster."
	author: "Bernhard S. Buss"
	date: "20.june.2006"
	revision: "$Revision$"

class
	EMU_PROJECT_CLASS

inherit
	EMU_PROJECT_UNIT

create
	make


feature -- Content
	
	content: STRING
			-- the code content of the class. Represented as a long string.


feature -- Attributes

	modification_date: DATE
			-- last date and time of modification.
	
	modification_user: EMU_USER
			-- user who did the last modification.


end
