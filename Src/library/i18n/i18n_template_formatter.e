indexing
	description: "This class supplies functions for filling templates strings with other dinamically generated objects' representations."
	status: "NOTE: This class is NOT production ready, we reccommend that you don't use it!"
	author: "Originally created from Martino Trosi, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_TEMPLATE_FORMATTER

-- Should this class inherit from the ST_FORMATTER from the gobo library?
-- Let us know your opinion on the wiki: http://eiffelsoftware.origo.ethz.ch/index.php/Internationalization/translation_function

create {I18N_LOCALIZATOR}
	make,
	make_with_escape

feature {NONE} -- Initialization

	make is
			-- Initialize `Current', with default escape character '\'.
		do
			make_with_escape('\')
		end

	make_with_escape(a_escape: WIDE_CHARACTER) is
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
	solve_template(a_string: STRING_GENERAL; a_args: TUPLE): STRING_32 is
			-- What's the completed template?
		require
			valid_string: a_string /= Void
			valid_args: a_args /= Void
		local
			last_escape_character: BOOLEAN
			temp_code: INTEGER
			i: INTEGER
				-- Counter
		do
			create Result.make_empty
			from
				i := 1
			until
				i > a_string.count
			loop
				if a_string.code(i) = escape_character.code.as_natural_32 then
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
	code1: NATURAL_32 is
			-- Code for character '1'
		local
			char1: WIDE_CHARACTER
		once
			char1 := '1'
			Result := char1.code.as_natural_32
		end

	code9: NATURAL_32 is
			-- Code for character '9'
		local
			char1: WIDE_CHARACTER
		once
			char1 := '9'
			Result := char1.code.as_natural_32
		end

invariant
	invariant_clause: True -- Your invariant here

end
