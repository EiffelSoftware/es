note
	ca_only: "CA050"
class
	CAT_LOCAL_USED_FOR_RESULT

feature {NONE} -- Test

	locals: STRING
		local
			l_string: STRING
		do
			create l_string.make_empty

			l_string.append ("Hallo")

			l_string.append("Welt")

			Result := l_string
		end

end
