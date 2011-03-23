note
	description : "Default JavaScript values for different types."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_DEFAULT_VALUE_WRITER

create
	make

feature {NONE} -- Initialization

	make
		do
		end

feature -- Basic Operation

	default_value (a_type: attached TYPE_A): attached STRING
			-- The default value for `a_type'.
		do
			if a_type.is_boolean then
				Result := "false"
			elseif a_type.is_numeric then
				Result := "0"
			elseif a_type.is_character or a_type.is_character_32 then
				Result := "%'%'"
			else
				Result := "null"
			end
		end


end
