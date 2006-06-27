indexing

	description: "Singleton simulator for unicode converters"
	date: "$Date:$"
	revision: "$Revision:$"

class IMPORTED_UNICODE_ROUTINES

feature -- Access

	utf8: UTF8_CONVERTER is
		once
			create Result
		ensure
			converter_not_void: Result /= Void
		end

	utf16be: UTF16BE_CONVERTER is
		once
			create Result
		ensure
			converter_not_void: Result /= Void
		end

	utf16le: UTF16LE_CONVERTER is
		once
			create Result
		ensure
			converter_not_void: Result /= Void
		end
	
	utf16: UTF16_CONVERTER is
		once
			create Result
		ensure
			converter_not_void: Result /= Void
		end

end
