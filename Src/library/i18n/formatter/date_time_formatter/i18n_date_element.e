class I18N_DATE_ELEMENT
inherit I18N_FORMATTING_ELEMENT

create
	make

feature {I18N_FORMAT_STRING_PARSER} -- Initialization

	make (a_date_action: FUNCTION[ANY,TUPLE[DATE],STRING_32]) is
			--
		do
			date_action := a_date_action
		end

feature -- Action

	date_action: FUNCTION[ANY,TUPLE[DATE],STRING_32]

feature --Output

 	filled (a_date: DATE; a_time: TIME): STRING_32 is
 			--
 		do
			Result := date_action.item ([a_date])
 		end


invariant

	correct_date_action: date_action /= Void

end
