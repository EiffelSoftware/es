note
	description : "Data representation for JSC_WRITER."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_BUFFER_DATA

create
	make_from_buffer,
	make_from_string

feature {NONE} -- Initialization

	make_from_buffer (a_buffer: attached KL_STRING_OUTPUT_STREAM)
		do
			buffer := a_buffer
		end

	make_from_string (a_string: attached STRING)
		do
			create buffer.make (a_string)
		end

feature -- Access

	force_string: attached STRING
		local
			l_string: STRING
		do
			l_string := buffer.string
			check l_string /= Void end

			Result := l_string
		end

feature {JSC_BUFFER} -- Access

	buffer: attached KL_STRING_OUTPUT_STREAM

end
