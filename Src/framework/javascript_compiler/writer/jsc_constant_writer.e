note
	description : "Translate a constant to JavaScript."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_CONSTANT_WRITER

inherit
	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
		do
		end

feature -- Basic Operation

	process_string (a_value: attached STRING): attached STRING
			-- Process a string constant
		local
			l_temp: STRING
		do
			create l_temp.make_from_string (a_value)
			l_temp.replace_substring_all ("\", "\\")
			l_temp.replace_substring_all ("%"", "\%"")
			l_temp.replace_substring_all ("%N", "\n")
			l_temp.replace_substring_all ("%R", "\r")
			l_temp.replace_substring_all ("%T", "\t")

			Result := "%"" + l_temp + "%""
		end

	process (a_value: attached VALUE_I): attached STRING
			-- Process a constant value
		local
			l_string_value: STRING
		do
			l_string_value := a_value.string_value
			check l_string_value /= Void end

			if a_value.is_boolean then
				Result := l_string_value.as_lower

			elseif a_value.is_character or a_value.is_string then
				Result := process_string (l_string_value)

			else
				Result := l_string_value

			end
		end

end
