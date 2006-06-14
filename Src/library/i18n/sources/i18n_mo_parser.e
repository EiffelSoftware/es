indexing
	description: "Parser for accessing MO files."
	status: "NOTE: This class is NOT production ready, we reccommend that you don't use it!"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_MO_PARSER

inherit
	I18N_DATASOURCE
		rename
			close as close_file,
			open as open_file
		end
	UC_IMPORTED_UTF8_ROUTINES

create {I18N_DATASOURCE_FACTORY}
	make_with_file

feature {NONE} -- Initialization
	make_with_file(a_file: RAW_FILE) is
			-- Using a_file
		require
			valid_file: a_file /= Void
			file_open: a_file.is_open_read
		do
			mo_file := a_file
			file_exists := true
		ensure
			mo_file_set: mo_file = a_file
		end

feature -- Status setting
	open_file is
			-- Open mo_file.
		do
			-- Read magic number.
			mo_file.read_integer
			if mo_file.last_integer = 0xde120495 then
				is_big_endian := True
			elseif mo_file.last_integer = 0x950412de then
				is_little_endian := True
			end
			if is_valid then
				-- Read mo file version.
				version := read_integer
				-- Read number of strings.
				string_count := read_integer
				-- Read offset of original strings' table.
				original_table_offset := read_integer
				-- Read offset of translated strings' table.
				translated_table_offset := read_integer
				-- Read size of hashing table.
				hash_table_size := read_integer
				-- Read offset of hashing table.
				hash_table_offset := read_integer
				extract_plural_informations
			end
			is_open := true
		end

	close_file is
			-- Close mo_file.
		do
			mo_file.close
			is_open := mo_file.is_closed
		end

feature -- File information
	is_big_endian,
	is_little_endian: BOOLEAN

	version: INTEGER
		-- Version of the mo file

	using_hash_table: BOOLEAN is
			-- Are we using an hash table?
		require
			correct_file: file_exists and then is_valid
		do
			Result := (hash_table_size > 0)
		end

	original_system_information: STRING_32 is
			-- Which original system information is attached to the mo file?
		require
			correct_file: file_exists and then is_valid
		do
			Result := extract_string(original_table_offset, 0)
		ensure
			result_exists : Result /= Void
		end

	translated_system_information : STRING_32 is
			-- Which translated system information is attached to the mo file?
		require
			correct_file: file_exists and then is_valid
		do
			Result := extract_string(translated_table_offset, 0)
		ensure
			result_exists : Result /= Void
		end

feature -- Basic operation
	get_original(i_th: INTEGER): STRING_32 is
			-- get i_th original string in the file
		obsolete
			"Use get_originals instead."
		require
			valid_index: valid_index(i_th)
			correct_file: file_exists and then is_valid
		local
			string_length, string_offset: INTEGER
		do
			mo_file.go(original_table_offset + (i_th - 1) * 8)
			string_length := read_integer
			string_offset := read_integer
			mo_file.go(string_offset)
			mo_file.read_stream(string_length)
			create Result.make_from_string(mo_file.last_string)
		ensure
			result_exists: Result /= Void
		end

	get_translated(i_th: INTEGER): STRING_32 is
			-- What's the i-th translated string?
		obsolete
			"Use get_translateds instead."
		require
			valid_index: valid_index(i_th)
			correct_file: file_exists and is_valid
		local
			string_length, string_offset: INTEGER
		do
			mo_file.go(translated_table_offset + (i_th - 1) * 8)
			string_length := read_integer
			string_offset := read_integer
			mo_file.go(string_offset)
			mo_file.read_stream(string_length)
			create Result.make_from_string(mo_file.last_string)
		ensure
			result_exists: Result /= Void
		end

	get_originals(i_th: INTEGER): LIST[STRING_32] is
			-- get `i_th' original string in the file
		require else
			correct_file: file_exists and then is_valid
		do
			Result := extract_string(original_table_offset, i_th).split('%U')
		end

	get_translateds(i_th: INTEGER): LIST[STRING_32] is
			-- What's the `i-th' translated string?
		require else
			correct_file: file_exists and is_valid
		do
			Result := extract_string(translated_table_offset, i_th).split('%U')
		end

	get_hash(i_th: INTEGER): INTEGER is
			-- What's the hash of the i-th original string?
			-- Actually not required, all the strings are hashed on load by the datastructure.
		obsolete
			"Actually not required, all the strings are hashed on load by the datastructure."
		require
			valid_index(i_th)
			correct_file: file_exists and then is_valid
		do

		end

feature --Errors
	is_valid: BOOLEAN is
			-- is the file valid?
		require
			the_file_exists: file_exists
		do
			Result := is_big_endian or is_little_endian
		end

	file_exists: BOOLEAN
		-- Does the file exist?


feature {NONE} --Implementation

	extract_string (a_offset, a_number: INTEGER): STRING_32 is
			-- Which is the a_number-th string into the table at a_offset?
		require
			valid_offset: (a_offset = translated_table_offset) or (a_offset = original_table_offset)
			valid_number: (0 <= a_number) and (a_number <= string_count)
			correct_file: file_exists and then is_valid
		local
			string_length,
			string_offset: INTEGER
			c_str: POINTER
			i: INTEGER
			ptr: MANAGED_POINTER
			uc_str: UC_STRING
			l_ch: CHARACTER
			ch_len: INTEGER
			code: NATURAL_32
		do
			mo_file.go(a_offset + (a_number - 1) * 8)
			string_length := read_integer
			string_offset := read_integer
			mo_file.go(string_offset)
			create Result.make_empty
			from
				i := 1
				ch_len := 0
			invariant
				i >= 1
				i <= string_length + 1
			variant
				string_length + 1 - i
			until
				i > string_length or mo_file.end_of_file
			loop
				mo_file.read_character
				l_ch := mo_file.last_character
				if ch_len > 0 then
					-- we are in the middle of a multi-byte char
					ch_len := ch_len - 1 -- one byte fewer to decode
					code := code + l_ch.natural_32_code.bit_and (127) * (2^(6*ch_len)).truncated_to_integer.as_natural_32
					if ch_len <= 0 then
						-- this was last byte
						Result.append_character (code.to_character_32)
						code := code.zero
					end
				elseif utf8.is_encoded_first_byte (l_ch) then
					ch_len := utf8.character_byte_count (l_ch)
					if ch_len = 1 then
						-- this is an ascii character
						Result.append_character (l_ch.to_character_32)
					else
						-- first byte of a multibyte character
						code := l_ch.natural_32_code.bit_and ({NATURAL_8}.max_value.bit_shift_right (ch_len).as_natural_32).bit_shift_left (6*(ch_len-1))
						ch_len := ch_len - 1
					end
				else
					-- something was wrong in the bytes sequence
					-- just discard the character
				end
				i := i + 1
			end
		ensure
			result_exists : Result /= Void
		end

	read_integer : INTEGER is
			-- read an integer from the current
			-- position in the mo file
			-- it moves the cursor
		local
			b0, b1, b2, b3 : NATURAL_8
		do
			mo_file.read_natural_8
			b0 := mo_file.last_natural_8
			mo_file.read_natural_8
			b1 := mo_file.last_natural_8
			mo_file.read_natural_8
			b2 := mo_file.last_natural_8
			mo_file.read_natural_8
			b3 := mo_file.last_natural_8
			if is_big_endian then
				Result :=  (b0 |<< 24) | (b1 |<< 16) | (b2 |<< 8) | b3;
			else
				Result :=  b0 | (b1 |<< 8) | (b2 |<< 16) | (b3 |<< 24);
			end
		end


	extract_plural_informations is
			-- extract from the mo file
			-- the informations abount the plural forms
		require
			correct_file: file_exists and then is_valid
		local
			t_list : LIST[STRING_32]
			t_string : STRING_32
			index : INTEGER
			char0: WIDE_CHARACTER
			code0: INTEGER -- used to get an integer
		do
			char0 := '0'
			code0 := char0.code
			t_list := get_translated (0).split ('%N')
			 -- Search the informations
			from
				t_list.start
			until
				t_string /= Void or t_list.after
			loop
				if t_list.item.has_substring ("Plural-Forms") then
					t_string := t_list.item
				end
				t_list.forth
			end
			if t_string /= Void then
				-- Informations found
				index := t_string.index_of (';', 1)
				if index > 1 and t_string.has_substring ("nplurals=") then
					plural_forms := (t_string.item_code(index-1) - code0)
						-- ?????? Does this find out the integer value of the represented character???
					index := t_string.index_of ('=', index)+1
					plural_form_identifier := t_string.substring (index, t_string.count)
				end
			end
			if t_string = Void or plural_form_identifier = Void then
				-- No informations found or invalid
				-- set to default values
				plural_forms := 2
				create plural_form_identifier.make_from_string ("n != 1;")
			end
		ensure
			plural_form_identifier_exists : plural_form_identifier /= Void
		end


	mo_file: RAW_FILE
		-- Reference to the mo file

	original_table_offset: INTEGER
		-- Offset of the table containing the original strings

	translated_table_offset: INTEGER
		-- Offset of the table containing the translated strings

	hash_table_size: INTEGER
		-- Size of the hash table

	hash_table_offset: INTEGER
		-- Offset of the hash table

invariant
	big_xor_little_endian: (file_exists and then is_valid) implies (is_little_endian xor is_big_endian)
	valid_mo_file: mo_file /= Void
	is_open implies mo_file.is_open_read

end -- class I18N_MO_PARSER
