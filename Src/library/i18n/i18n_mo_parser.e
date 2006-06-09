indexing
	description: "Parser for accessing MO files."
	status: "NOTE: This class is NOT production ready, we reccommend that you don't use it!"
	author: "i18n team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_MO_PARSER

create {I18N_DATASTRUCTURE}
	make_with_path

feature {NONE} -- Initialization
	make_with_path(a_path: STRING) is
			-- Open the mo_file located in a_path
			-- and extract information from it.
		require
			path_exists: a_path /= Void
			non_empty_path: not a_path.is_empty
		do
			create mo_file.make(a_path)
			file_exists:= mo_file.exists
			if file_exists then
				mo_file.make_open_read(a_path)

				-- Read magic number.
				mo_file.read_integer
				if mo_file.last_integer = 0xde120495 then
					is_big_endian := True
				elseif mo_file.last_integer = 0x950412de then
					is_little_endian := True
				end
				if is_valid then
					-- Read mo file version.
					mo_file.read_integer
					version := mo_file.last_integer
					-- Read number of strings.
					mo_file.read_integer
					string_count := mo_file.last_integer
					-- Read offset of original strings' table.
					mo_file.read_integer
					original_table_offset := mo_file.last_integer
					-- Read offset of translated strings' table.
					mo_file.read_integer
					translated_table_offset := mo_file.last_integer
					-- Read size of hashing table.
					mo_file.read_integer
					hash_table_size := mo_file.last_integer
					-- Read offset of hashing table.
					mo_file.read_integer
					hash_table_offset := mo_file.last_integer
					extract_plural_informations
				end
			end
		ensure
			mo_file_open: file_exists implies mo_file.is_open_read
		end

feature -- Status report
	valid_index(a_index: INTEGER): BOOLEAN is
			-- Is the index in valid range?
		do
			Result := (a_index >= 0) and (a_index <= string_count)
		end

feature -- Status setting
	close_file is
			-- Close mo_file.
		do
			mo_file.close
		ensure
			mo_file.is_closed
		end

feature -- File information
	plural_forms: INTEGER
			-- Number of plural forms

	plural_form_identifier: STRING_32
		-- Identifier of the plural form function

	is_big_endian,
	is_little_endian: BOOLEAN

	version: INTEGER
		-- Version of the mo file

	string_count: INTEGER
		-- Number of strings in the file

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
			mo_file.read_integer_32
			string_length := mo_file.last_integer_32
			mo_file.read_integer_32
			string_offset := mo_file.last_integer_32
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
			mo_file.read_integer_32
			string_length := mo_file.last_integer_32
			mo_file.read_integer_32
			string_offset := mo_file.last_integer_32
			mo_file.go(string_offset)
			mo_file.read_stream(string_length)
			create Result.make_from_string(mo_file.last_string)
		ensure
			result_exists: Result /= Void
		end

	get_originals(i_th: INTEGER): LIST[STRING_32] is
			-- get `i_th' original string in the file
		require
			valid_index: valid_index(i_th)
			correct_file: file_exists and then is_valid
		do
			Result := extract_string(original_table_offset, i_th).split('%U')
		ensure
			result_exists: Result /= Void
		end

	get_translateds(i_th: INTEGER): LIST[STRING_32] is
			-- What's the `i-th' translated string?
		require
			valid_index: valid_index(i_th)
			correct_file: file_exists and is_valid
		do
			Result := extract_string(translated_table_offset, i_th).split('%U')
		ensure
			result_exists: Result /= Void
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
		do
			mo_file.go(a_offset + (a_number - 1) * 8)
			mo_file.read_integer_32
			string_length := mo_file.last_integer_32
			mo_file.read_integer_32
			string_offset := mo_file.last_integer_32
			mo_file.go(string_offset)
			mo_file.read_stream(string_length)
			create Result.make_from_string(mo_file.last_string)
		ensure
			result_exists : Result /= Void
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

end -- class I18N_MO_PARSER
