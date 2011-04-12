note
	description : "JavaScript implementation of EiffelBase class LINKED_LIST_CURSOR and ARRAYED_LIST_CURSOR."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBase: LINKED_LIST_CURSOR, ARRAYED_LIST_CURSOR"
class
	EIFFEL_LIST_CURSOR

create
	make

feature {NONE} -- Initialization

	make (a_inner_index: INTEGER)
		do
			inner_index := a_inner_index
		end

feature -- Access

	inner_index: INTEGER

end
