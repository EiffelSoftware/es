indexing
	description: "This class supplies functions for filling templates strings with other dinamically generated objects' representations."
	remark: "[
	  Feel free to use other template engines instead of this, by not using the i18n_comp* functions.
	  These functions will not be available in a future version of the library!
	  ]"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_TEMPLATE_FORMATTER
-- Should this class inherit from the ST_FORMATTER from the gobo library?
-- Actually ST_FORMATTER is explicitly excluded from the library, why? -- [vaninic]
-- Let us know your opinion on the wiki: http://eiffelsoftware.origo.ethz.ch/index.php/Internationalization/translation_function
-- Answer: no, the templates handling will be moved out of this library.

create
	make,
	make_with_escape

feature {NONE} -- Initialization

	make is
			-- Initialize `Current', with default escape character '\'.
		do
			make_with_escape('$')
		end

	make_with_escape (a_escape: WIDE_CHARACTER) is
			-- Initialize `Current'.
		do
			escape_character := a_escape
		ensure
			escape_character_set: escape_character.is_equal(a_escape)
		end

feature -- Access

	escape_character: WIDE_CHARACTER
		-- Escape character

feature -- Basic operations

	solve_template (a_string: STRING_GENERAL; a_args: TUPLE): STRING_32 is
			-- What's the completed template?
		require
			valid_string: a_string /= Void
			valid_args: a_args /= Void
		local
			last_escape_character: BOOLEAN
			last_code_pre: BOOLEAN
			last_no_number: BOOLEAN
			temp_code: INTEGER
			i, j: INTEGER
				-- Counter
			l_string: STRING_32
			l_multiplier: DOUBLE
			l_code: INTEGER
		do
			create Result.make_empty
			from
				i := 1
			invariant
				i >= 1
				i <= a_string.count + 1
			variant
				a_string.count + 1 - i
			until
				i > a_string.count
			loop
				if last_code_pre then
					if a_string.code(i) = code_post then
						last_code_pre := false
					end
				elseif a_string.code(i) = escape_character.code.as_natural_32 then
					if last_escape_character then
						-- Last characted was escape_character, print escaped escape_character
						Result.append_character(escape_character)
						last_escape_character := false
					else
						-- This is an escape_character, print nothing and see what comes next
						last_escape_character := true
					end
				else
					if last_escape_character then
						-- Insert argument
						temp_code := 9 - (code9.as_integer_32 - a_string.code(i).as_integer_32)
						if temp_code >= 1 and temp_code <= 9 then
							-- Valid index, insert argument
							Result.append(a_args.item(temp_code).out.to_string_32)
						elseif a_string.code(i) = code_pre then
							temp_code := 0
							l_string := a_string.substring((i+1),a_string.count).to_string_32.split('}').i_th(1)
							from
								j := 1
							invariant
								j >= 1
								j <= l_string.count + 1
							variant
								l_string.count + 1 - j
							until
								j > l_string.count or last_no_number
							loop
								l_multiplier := 10 ^ (l_string.count - j)
								l_code := (9 - (code9.as_integer_32 - l_string.code(j).as_integer_32))
								if l_code >= 0 and l_code <= 9 then
									temp_code := (temp_code + (l_code * l_multiplier.ceiling))
								else
									last_no_number := true
								end
								j := j + 1
							end
							if last_no_number then
								Result.append_character(escape_character)
								Result.append_code(a_string.code(i))
							else
								if temp_code > 0 and temp_code <= a_args.count then
									Result.append(a_args.item(temp_code).out.to_string_32)
								end
								last_code_pre := true
							end
						else
							-- Invalid index, print escape_character and current character
							Result.append_code(escape_character.code.as_natural_32)
							Result.append_code(a_string.code(i))
						end
					else
						-- Simply print character
						Result.append_code(a_string.code(i))
					end
					last_escape_character := false
				end
				i := i + 1
			end
			if last_escape_character then
				Result.append_character(escape_character)
			end
		ensure
			valid_result: Result /= Void
		end

feature {NONE} -- Implementation

	code_pre: NATURAL_32 is
			-- Code for character '1'
		local
			l_char: WIDE_CHARACTER
		once
			l_char := '{'
			Result := l_char.code.as_natural_32
		end

	code_post: NATURAL_32 is
			-- Code for character '9'
		local
			l_char: WIDE_CHARACTER
		once
			l_char := '}'
			Result := l_char.code.as_natural_32
		end

	code1: NATURAL_32 is
			-- Code for character '1'
		local
			l_char: WIDE_CHARACTER
		once
			l_char := '1'
			Result := l_char.code.as_natural_32
		end

	code9: NATURAL_32 is
			-- Code for character '9'
		local
			l_char: WIDE_CHARACTER
		once
			l_char := '9'
			Result := l_char.code.as_natural_32
		end

invariant

	invariant_clause: True -- Your invariant here

end
