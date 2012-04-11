indexing
	description: "class that provides basic form validation functions"
	author: "Peizhu Li, Marco Piccioni"
	date: "17.1.2011"
	revision: "$0.7$"

class
	FORM_VALIDATOR

create
	make

feature -- Attributes

context: REQUEST_DISPATCHER
	-- actual HTTP context

last_value: STRING
	-- value from last checked field

feature -- creation

make(a_context: REQUEST_DISPATCHER) is
		-- initialization
	do
		context := a_context
	end

feature -- CGI_FORMS

	text_field_value (field_name: STRING): STRING is
			-- get a text field value as string /wrapper of CGI_FORM text_field_value
		do
			last_value := context.text_field_value (field_name)
			last_value.left_adjust
			last_value.right_adjust
			Result := last_value
		end

	button_value (field_name, overriding_value: STRING_8): BOOLEAN is
			-- wrapper of CGI_FORM button_value
		do
			Result := context.button_value (field_name, overriding_value)
			last_value := Result.out
		end

	menu_values (field_name: STRING): LINKED_LIST[STRING] is
			-- wrapper of CGI_FORM menu_values
		do
			Result := context.menu_values (field_name)
			last_value := Result.out
		end

	fields: ARRAY[STRING] is
			-- wrapper of CGI_FORM fields
		do
			Result := context.fields
		end

	value_count (field_name: STRING): INTEGER is
			-- wrapper of CGI_FORM value_count
		do
			Result := context.value_count (field_name)
		end

	value_list (field_name: STRING): LINKED_LIST[STRING] is
			-- wrapper of CGI_FORM value_list
		do
			Result := context.value_list (field_name)
		end

	field_defined (field_name: STRING): BOOLEAN is
			-- wrapper of CGI_FORM field_defined
		do
			Result := context.field_defined (field_name)
		end

feature -- Access

	get_field_string (a_field_name: STRING): STRING is
			-- retrieve the string value of a text field with the specified name.
		require
			field_name_valid: a_field_name /= void and then not a_field_name.is_empty
		do
			if field_defined (a_field_name) then
				Result := text_field_value (a_field_name)
				Result.left_adjust
				Result.right_adjust
			else
				create Result.make_empty
			end
			last_value := Result
		end

	get_field_integer(a_field_name: STRING):INTEGER is
			-- retrieve the integer value of a given field
		require
			field_name_valid: a_field_name /= void and then not a_field_name.is_empty
			field_defined: field_defined (a_field_name) and then is_field_value_not_empty(a_field_name)
		do
			Result := get_field_string (a_field_name).to_integer
			last_value := Result.out
		end

	get_field_double(a_field_name: STRING): DOUBLE is
			-- retrieve the double value of a given field
		require
			field_name_valid: a_field_name /= void and then not a_field_name.is_empty
			field_defined: field_defined (a_field_name) and then is_field_value_not_empty(a_field_name)
		do
			Result := get_field_string (a_field_name).to_double
			last_value := Result.out
		end

feature -- validation

	is_string_not_empty (value: STRING):BOOLEAN
			--is field value valid?
		do
			if  value /= Void then
				value.left_adjust
				value.right_adjust
				if (NOT value.is_empty) then
					Result:= True
				end
			end
		end

	is_field_value_not_empty (field: STRING):BOOLEAN
			--is field value valid?
		do
			if  field_defined (field) and then text_field_value (field) /= Void then
				last_value := text_field_value (field)
				last_value.left_adjust
				last_value.right_adjust
				if (NOT last_value.is_empty) then
					Result:= True
				end
			else
				last_value := ""
			end
		end

	is_email_valid (email:STRING):BOOLEAN
			--is email valid? (non-void, non-empty after eliminating leading and trailing spaces, with only one '@')
		do
			if  email /= Void then
				email.left_adjust
				email.right_adjust
				if (NOT email.is_empty AND THEN email.occurrences('@')=1) then
					Result:= True
				end
			end
		end

	is_date_valid (day,month,year:STRING):BOOLEAN
			-- is date valid?
		local
			date_checker:DATE_VALIDITY_CHECKER
		do
			if is_string_not_empty (day) AND is_string_not_empty (month) AND is_string_not_empty (year) then
				if day.is_integer AND month.is_integer AND year.is_integer then
					create date_checker
					if  date_checker.is_correct_date (year.to_integer,month.to_integer,day.to_integer) then
						Result:= True
					end
				end
			end
		end

	is_non_required_date_valid (day,month,year:STRING):BOOLEAN
			-- is date which is not required valid? It accepts 'n/a'
		local
			date_checker:DATE_VALIDITY_CHECKER
		do
			if is_string_not_empty (day) AND is_string_not_empty (month) AND is_string_not_empty (year) then
				if day.is_equal("n/a") OR month.is_equal("n/a") OR year.is_equal("n/a") then
					Result:=True
				elseif day.is_integer AND month.is_integer AND year.is_integer then
					create date_checker
					if  date_checker.is_correct_date (year.to_integer,month.to_integer,day.to_integer) then
						Result:= True
					end
				end
			end
		end

	is_must_field_filled (a_field_name: STRING): BOOLEAN is
			-- check a field value for non emptyness
		require
			field_name_valud: a_field_name /= void and then not a_field_name.is_empty
		do
			create last_value.make_from_string(get_field_string (a_field_name))
			if not last_value.is_empty then
				result := true
			end
		end


	is_field_in_range(field_name: STRING; min,max: DOUBLE): BOOLEAN is
			-- whether a integer/float field in specified min/max range
		require
			field_name_valud: field_name /= void and then not field_name.is_empty
			field_exists:is_must_field_filled(field_name)
		local
			value: DOUBLE
		do
			value := get_field_double(field_name)
			if value >= min and then value <= max then
				Result := true
			end
		end

	are_fields_equal(name1, name2: STRING): BOOLEAN is
			-- whether two fields have same values
		require
			field_name_valud: name1 /= void and then not name1.is_empty and then name2 /= void and then not name2.is_empty
			fields_exist: is_must_field_filled(name1) and then is_must_field_filled(name2)
		local
			value1, value2: STRING
		do
			create value1.make_from_string(get_field_string (name1))
			create value2.make_from_string(get_field_string (name2))
			if value1.is_equal (value2) then
				result := true
			end
		end

	is_must_fields_valid(names: ARRAY[STRING]): ARRAY[STRING] is
			-- check a given must field list to see whether they are filled with values. return an array contains fields names that failed validation.
		local
			i,j: INTEGER
		do
			create Result.make (1, 100)
			j := 1

			from
				i := names.lower
			until
				i > names.upper
			loop
				if names.item (i) /= Void then
					if not is_must_field_filled (names.item(i)) then
						Result.put(names.item(i), j)
						j := j + 1
					end
				end
				i := i + 1
			end
		end

	is_captcha_valid (question, answer: STRING): BOOLEAN
			-- Is the provided `answer' to the captcha `question' valid?
		do
			Result := question.is_equal (answer)
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
