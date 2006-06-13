indexing
	description: "Datastructure for storing original and translated string for localization purposes."
	status: "NOTE: This class is NOT production ready, we reccommend that you don't use it!"
	author: "Originally created by Martino Trosi, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_DATASTRUCTURE

create {I18N_LOCALIZATOR}
	make_with_file

feature {NONE} -- Initialization
	make_with_file(a_path: STRING) is
			-- Initialize `Current'.
		require
			valid_path: a_path /= Void
			not_empty_path: not a_path.is_empty
		do
			create i18n_mo_parser.make_with_path(a_path)
			if i18n_mo_parser.file_exists and then i18n_mo_parser.is_valid then
				populate_array
				populate_hash_table
				i18n_mo_parser.close_file
			end
			create i18n_plural_forms.make_with_identifier (i18n_mo_parser.plural_forms, i18n_mo_parser.plural_form_identifier)
		end

feature {NONE} -- Miscellaneous
    hash_string(a_string: STRING_32): INTEGER is
			-- What is the hash of a_string?
		require
			valid_string: a_string /= Void
		local
			position: INTEGER
			l_result, g: NATURAL_32
		do
			from
				position := 1
			invariant
				position >= 1
				position <= a_string.count + 1
			variant
				a_string.count + 1 - position
			until
				position > a_string.count
			loop
				l_result := l_result |<< 4
				l_result := l_result + a_string.code(position) -- for eiffel 5.7.x
				--l_result := l_result + a_string.item_code(position).as_natural_32 --for eiffel 5.6
				g := l_result & ({NATURAL_32} 0xf |<< 28)
				if g /= 0 then
					l_result := l_result.bit_xor(g |>> 24)
					l_result := l_result.bit_xor(g)
				end
				position := position + 1
			end
			Result := l_result.as_integer_32
		end

feature {NONE} -- Basic operations
	take_from_hash(a_hash, i_th: INTEGER): STRING_32 is
			-- Which string is the translation of the a_hash-hashed one?
		do
			-- Simply get it from the hash table.
			Result := hash_table.item(a_hash).get_translated(i_th)
		end

	search(a_string: STRING_32): STRING_32 is
			-- What is the translation of a_string?
			-- actually not required (hashing strings on load if no hash-table found
		obsolete
			"Actually hashing all the strings on load."
		require
			valid_string: a_string /= Void
		do
			-- binary search
		end

feature -- Translation
	translate(a_string: TUPLE[STRING_GENERAL, STRING_GENERAL]; i_th: INTEGER): STRING_32 is
			-- Can you give me the translation?
			-- aka interface to the TRANSLATOR class
		require
			valid_string: a_string /= Void
		local
			l_hash: INTEGER
				-- Temporary hash
			l_plural: INTEGER
				-- Plural form
			temp_string: STRING_GENERAL
				-- Temporary string
			l_string: STRING_32
				-- STRING_32 representation
		do
			temp_string ?= a_string.item(1)
			if temp_string /= Void then
				if temp_string.is_equal("") then
					Result := ""
				else
					l_string := temp_string.as_string_32
					l_hash := hash_string(l_string)
					l_plural := i18n_plural_forms.get_plural_form(i_th)
					if hash_table.has(l_hash) then
						-- The string is into the hashing table.
						Result := take_from_hash(l_hash, l_plural)
					else
						-- No string found, serve the argument.
						if i_th /= 1 then
							temp_string ?= a_string.item(2)
							if temp_string /= Void then
								Result := temp_string.as_string_32
							end
						else
							Result := l_string
						end
					end
				end
			end
			if Result = Void then
				Result := ""
			end
		end

feature {NONE} -- Implementation
	hash_table: HASH_TABLE[I18N_STRING, INTEGER]
		-- Table with all the strings

	array: ARRAY[I18N_STRING]
		-- Where all the strings are stored

	i18n_mo_parser: I18N_MO_PARSER
		-- Reference to the parser

	i18n_plural_forms: I18N_PLURAL_FORMS
		-- Reference to the plural form resolver

	populate_hash_table is
			-- Populates the hash table.
		local
			i: INTEGER
				-- Iterator
		do
			create hash_table.make(i18n_mo_parser.string_count)
			from -- spatial locality
				i := 1
			invariant
				i >= 1
				i <= i18n_mo_parser.string_count + 1
			variant
				i18n_mo_parser.string_count + 1 - i
			until
				i > i18n_mo_parser.string_count
			loop
				array.item(i).set_hash(hash_string(array.item(i).originals.i_th(1)))
				hash_table.put(array.item(i), array.item(i).hash)
				i := i + 1
			end
		end

	populate_array is
			-- Populates the array.
		local
			i: INTEGER
				-- Iterator
			temp_string: I18N_STRING
				-- Temporary string
		do
			create array.make(1, i18n_mo_parser.string_count)
			from -- spatial locality
				i := 1
			invariant
				i >= 1
				i <= i18n_mo_parser.string_count + 1
			variant
				i18n_mo_parser.string_count + 1 - i
			until
				i > i18n_mo_parser.string_count
			loop
				create temp_string.make_with_id(i)
				temp_string.set_plural_forms(i18n_mo_parser.plural_forms)
				temp_string.set_originals(i18n_mo_parser.get_originals(i))
				array.put(temp_string, i)
				i := i + 1
			end
			from -- spatial locality
				i := 1
			invariant
				i >= 1
				i <= i18n_mo_parser.string_count + 1
			variant
				i18n_mo_parser.string_count + 1 - i
			until
				i > i18n_mo_parser.string_count
			loop
				array.item(i).set_translateds(i18n_mo_parser.get_translateds(i))
				i := i + 1
			end
		end

invariant
	valid_array: array /= Void
	valid_hash_table: hash_table /= Void
	valid_mo_parser: i18n_mo_parser /= Void
	valid_plural_forms: i18n_plural_forms /= Void

end
