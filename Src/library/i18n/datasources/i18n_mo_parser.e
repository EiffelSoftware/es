indexing
	description: "Parser for accessing MO files."
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_MO_PARSER

inherit
	I18N_DATASOURCE
		rename
			close as close_file
		end

	IMPORTED_UTF8_READER_WRITER

create {I18N_DATASOURCE_FACTORY}

	make_with_path

feature {NONE} -- Initialization

	make_with_path (a_name: STRING) is
			-- Using a_name as the name of the MO file
		require
			valid_name: a_name /= Void
			not_empty_path: not a_name.is_empty
		do
			make

			create mo_file.make(a_name)
			if mo_file.exists then
				initialize
			end

			-- What method should use the datastructure to retrive data?
			retrieval_method := retrieve_by_type -- Preserve spatial locality
		ensure
			mo_file_set: mo_file /= Void
		end

feature -- Status setting

	initialize is
			-- Initialize the parser.
		require else
			not_already_open: is_closed
		local
			t_magic_number : ARRAY[NATURAL_8]
			l_magic_number: INTEGER
		do
			mo_file.open_read
			is_big_endian_file := False
			is_little_endian_file := False
			if mo_file.is_open_read then
				--is_open := true
				-- Read magic number.
				mo_file.read_integer
				l_magic_number := mo_file.last_integer
				mo_file.go(0)
				-- Read magic number byte-by-byte.
				t_magic_number := get_integer
				if t_magic_number.is_equal (<<0xde,0x12,0x04,0x95>>) then
					is_little_endian_file := True
					if l_magic_number = 0xde120495 then
						is_big_endian_machine := True
					elseif l_magic_number = 0x950412de then
						is_little_endian_machine := True
					end
				elseif t_magic_number.is_equal (<<0x95,0x04,0x12,0xde>>) then
					is_big_endian_file := True
					if l_magic_number = 0xde120495 then
						is_little_endian_machine := True
					elseif l_magic_number = 0x950412de then
						is_big_endian_machine := True
					end
				end
				if is_valid then
					is_ready := true
				else
					close_file
				end
			end
		end

	open is
			-- Open datasource.
		do
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
			is_open := True
		end

	close_file is
			-- Close mo_file.
		do
			mo_file.close
			is_open := not mo_file.is_closed

			-- Prevent datastructures from reloading this source.
			is_ready := false
		end

feature -- File information

	using_hash_table: BOOLEAN is
			-- Are we using an hash table?
		obsolete
			"We are not interested in the datastructure, we'll not use the built-in one."
		require
			correct_file: is_open
		do
			Result := (hash_table_size > 0)
		end

	original_system_information: STRING_32 is
			-- Which original system information is attached to the mo file?
		obsolete
			"Should get this informations from the datastructure."
		require
			correct_file: is_open
		do
			Result := extract_string(original_table_offset, 1)
		ensure
			result_exists : Result /= Void
		end

	translated_system_information : STRING_32 is
			-- Which translated system information is attached to the mo file?
		obsolete
			"Should get this informations from the datastructure."
		require
			correct_file: is_open
		do
			Result := extract_string(translated_table_offset, 1)
		ensure
			result_exists : Result /= Void
		end

feature -- Basic operation

	get_original (i_th: INTEGER): LIST[STRING_32] is
			-- get `i_th' original string in the file
		require else
			correct_file: is_open
		do
			Result := extract_string(original_table_offset, i_th).split('%U')
		end

	get_translated (i_th: INTEGER): LIST[STRING_32] is
			-- What's the `i-th' translated string?
		require else
			correct_file: is_open
		do
			Result := extract_string(translated_table_offset, i_th).split('%U')
		end

	get_hash (i_th: INTEGER): INTEGER is
			-- What's the hash of the i-th original string?
			-- Actually not required, all the strings are hashed on load by the datastructure.
		obsolete
			"The datastructure will decide if it needs hashing or not. We'll not use the built-in hash table."
		require
			valid_index(i_th)
			correct_file: is_open
		do

		end

feature --Errors

	is_valid: BOOLEAN is
			-- is the file valid?
		do
			Result := is_big_endian_file xor is_little_endian_file
		end

	file_exists: BOOLEAN is
			-- Does the file exist?
		obsolete
			"Not used, use mo_file.exists instead."
		do
			Result := mo_file.exists
		end

feature {NONE} -- Implementation (parameters)

	is_big_endian_file,
	is_little_endian_file: BOOLEAN
		-- File endianness

	is_big_endian_machine,
	is_little_endian_machine: BOOLEAN
		-- Machine endianness

	version: INTEGER
		-- Version of the mo file

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

feature {NONE} -- Implementation (helpers)

	extract_string (a_offset, a_number: INTEGER): STRING_32 is
			-- Which is the a_number-th string into the table at a_offset?
		require
			correct_file: mo_file.is_open_read and then is_valid
			valid_offset: (a_offset = translated_table_offset) or (a_offset = original_table_offset)
			valid_index: valid_index(a_number) -- defined in the abstract datasource
		local
			string_length,
			string_offset: INTEGER
		do
			mo_file.go(a_offset + (a_number - 1) * 8)
			string_length := read_integer
			string_offset := read_integer
			mo_file.go(string_offset)
			Result := utf8_rw.file_read_string_32_with_length (mo_file, string_length)
		ensure
			result_exists : Result /= Void
		end

	read_integer: INTEGER is
			-- read an integer from the current
			-- position in the mo file, taking care of the endianness of the file
		require
			file_open: mo_file.is_open_read
		do
			if is_little_endian_file = is_little_endian_machine then
				Result := read_integer_same_endianness
			else
				Result := read_integer_opposite_endianness
			end
		end

	read_integer_same_endianness: INTEGER is
			-- Reading an integer on the same architecture where the MO file was created
		require
			file_open: mo_file.is_open_read
		do
			mo_file.read_integer
			Result := mo_file.last_integer
		end

	read_integer_opposite_endianness: INTEGER is
			-- Reading an integer on the opposite architecture of which where the MO file was created
		require
			file_open: mo_file.is_open_read
		local
			b0, b1, b2, b3 : NATURAL_32
			t_array : ARRAY[NATURAL_8]
		do
			t_array := get_integer
			b0 := t_array.item(1).as_natural_32
			b1 := t_array.item(2).as_natural_32
			b2 := t_array.item(3).as_natural_32
			b3 := t_array.item(4).as_natural_32
			if is_little_endian_file then
				Result := (b0 | (b1 |<< 8) | (b2 |<< 16) | (b3 |<< 24)).as_integer_32
			else
				Result := (b3 | (b2 |<< 8) | (b1 |<< 16) | (b0 |<< 24)).as_integer_32
			end
		end

	get_integer: ARRAY[NATURAL_8] is
			-- read an integer byte to byte
			-- and put them a tuple in the
			-- order they where encountered
			-- it moves the cursor of the file
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
			Result := << b0, b1, b2, b3 >>
		end

	extract_plural_informations is
			-- extract from the mo file
			-- the informations abount the plural forms
		require
			correct_file: mo_file.is_open_read and then is_valid
		local
			t_list : LIST[STRING_32]
			t_string : STRING_32
			index : INTEGER
			char0: WIDE_CHARACTER
			code0: INTEGER -- used to get an integer
		do
			char0 := '0'
			code0 := char0.code
			t_list := get_translated(1).i_th(1).split('%N')
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

invariant

	valid_mo_file: mo_file /= Void
	big_xor_little_endian: (mo_file.exists and is_valid) implies (is_little_endian_file xor is_big_endian_file)
	never_open_if_not_valid: is_open implies (mo_file.is_open_read and then is_valid)
	retrieval_method = retrieve_by_type

end -- class I18N_MO_PARSER
