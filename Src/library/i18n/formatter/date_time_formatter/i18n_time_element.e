class I18N_TIME_ELEMENT
inherit I18N_FORMATTING_ELEMENT

create
	make

feature {I18N_FORMAT_STRING_PARSER}  -- Initialization

	make (a_time_action: FUNCTION[ANY,TUPLE[TIME],STRING_32]) is
			--
		do
			time_action := a_time_action
		end

feature -- Action

	time_action: FUNCTION[ANY,TUPLE[TIME],STRING_32]

feature --Output

 	filled (a_date: DATE; a_time: TIME): STRING_32 is
 			--
 		do
			Result := time_action.item ([a_time])
 		end


invariant

	correct_date_action: time_action /= Void
end
