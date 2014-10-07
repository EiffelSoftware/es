class
	CAT_LOCAL_USED_FOR_RESULT

feature {NONE} -- Test

	locals: STRING
		local
			l_string, l_another_string: STRING
		do
			create l_string.make_empty
			create l_another_string.make (5)

			l_string.append ("Hallo")

			l_string.append("Welt")

			Result := l_string
			Result := l_another_string
		end

end
