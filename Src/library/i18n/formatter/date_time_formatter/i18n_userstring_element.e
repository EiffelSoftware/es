class I18N_USERSTRING_ELEMENT
inherit I18N_FORMATTING_ELEMENT

create
	make

feature {I18N_FORMAT_STRING_PARSER} -- Initialization

	make (a_string: STRING_32) is
			--
		do
			user_string := a_string
		end

feature -- Output

	filled (a_date: DATE; a_time: TIME): STRING_32 is
 			--
 		do
			Result := user_string
 		end

feature {NONE}-- Implementation

	user_string: STRING_32

invariant

correct_user_string: user_string /= Void

end
