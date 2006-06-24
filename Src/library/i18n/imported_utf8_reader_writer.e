indexing
	description: "Imported routines for reading and writing STRING_32 objects using UTF-8 encoding"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	IMPORTED_UTF8_READER_WRITER

feature -- Access

	utf8_rw: UTF8_READER_WRITER is
			-- Routines for reading and writing UTF-8 strings
		once
			create Result
		ensure
			result_not_void: Result /= Void
		end

end
