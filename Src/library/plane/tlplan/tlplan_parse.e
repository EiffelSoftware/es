note
	description: "Summary description for {TLPLAN_OUTPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TLPLAN_PARSE

create
	make

feature
	make
		do

		end

	parse (file: PLAIN_TEXT_FILE) : LIST [VALUE]
		local
			l_file: PLAIN_TEXT_FILE
			l_list: ARRAYED_LIST [VALUE]
		do
			l_file := file
			create l_list.make (10)

			l_file.read_line
			parse_comment (l_file.last_string)

			from
			until l_file.after
			loop
				l_file.read_line
				if attached parse_value (strip_step_number (l_file.last_string)) then
					l_list.extend (last_value)
				end
			end

			Result := l_list
		end

	parse_comment (a_str: STRING)
		do

		end

	last_value: VALUE

	strip_step_number (a_str: STRING) : STRING
		local
			i: INTEGER
		do
			Result := a_str.substring ( a_str.index_of (':', 1) + 1, a_str.count)
			Result.left_adjust
		end

	parse_value (a_str: STRING) : STRING
		local
			str: STRING
		do
			io.put_string ("Parsing string as value: "  + a_str + "%N")

			if not a_str.is_empty then
				if a_str[1] = '(' then
					str := a_str.substring (2, a_str.count)

					Result := parse_var (str)

					if not attached Result then
						Result := parse_call (str)
					end

					if attached Result and then Result [1] = ')' then
						Result.remove_head (1)
					else
						Result := Void
					end
				elseif a_str [1] /= ')' then

					Result := parse_int (a_str)

					if not attached Result then
						Result := parse_var (a_str)
					end
				end
			end

		end

	parse_call (a_str: STRING) : STRING
		local
			name, tmp: STRING
			vals: ARRAYED_LIST [VALUE]
			cal: CALL
		do
			io.put_string ("Parsing string as call: "  + a_str + "%N")
			create vals.make (10)
			if a_str.starts_with (call_tag) then
				name := ident (a_str)
				Result := remove_ident (a_str)

				from
					tmp := Result
					Result := parse_value (Result)
				until not attached Result
				loop
					vals.extend (last_value)

					tmp := Result
					Result := parse_value (Result)
				end

					-- Restore the previous result, as the
					-- loop only ends when we can't parse anymore
					-- so the last good state is tmp.
				Result := tmp

				create cal.make (name, vals)
			end

			if attached Result then
				last_value := cal
			end

		end

	parse_var (a_str: STRING) : STRING
		local
			name: STRING
			var: VAR_VALUE
		do
			io.put_string ("Parsing string as var: "  + a_str + "%N")
			if a_str.starts_with (var_tag) then
				name := ident (a_str)
				Result := remove_ident (a_str)

				create var.make (name)
				last_value := var
			end
		end

	parse_int (a_str: STRING) : STRING
		local
			intstr: STRING
			var: INTEGER_VALUE
		do
			io.put_string ("Parsing string an int: "  + a_str + "%N")
			intstr := ident (a_str)

			if intstr.is_integer then
				Result := remove_ident (a_str)

				create var.make (intstr.to_integer)
				last_value := var
			end
		end

	var_tag : STRING = "var-"
	call_tag : STRING = "call-"

	end_ident_pos (a_str : STRING) : INTEGER
		do
			Result := a_str.index_of (' ', 1)
			if Result = 0 or a_str.index_of (')', 1) < Result then
				Result := a_str.index_of (')', 1)
			end

			if Result = 0 then
				Result := a_str.count + 1
			end
		end

	ident (a_str: STRING) : STRING
		do
			Result := a_str.substring (1, end_ident_pos (a_str) - 1)
		end

	remove_ident (a_str: STRING) : STRING
		do
			Result := a_str.substring (end_ident_pos (a_str), a_str.count)
			Result.left_adjust
		end

end
