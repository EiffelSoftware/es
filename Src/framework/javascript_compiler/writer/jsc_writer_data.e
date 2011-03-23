note
	description : "Data representation for JSC_WRITER."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_WRITER_DATA

create
	make_from_buffer,
	make_from_string

feature {NONE} -- Initialization

	make_from_buffer (a_buffer: attached LIST[attached STRING])
		do
			buffer := a_buffer
		end

	make_from_string (a_string: attached STRING)
		do
			create {LINKED_LIST[attached STRING]}buffer.make
			buffer.extend (a_string)
		end

feature -- Access

	force_string: attached STRING
		do
			Result := ""
			from
				buffer.start
			until
				buffer.after
			loop
				Result.append (buffer.item)
				buffer.forth
			end
		end

feature {JSC_WRITER} -- Access

	buffer: attached LIST[attached STRING]

end
