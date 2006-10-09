indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	DICTIONARY_TEST
inherit
	SHARED_I18N_PLURAL_TOOLS
create
	make

feature -- Initialization

	make(t:I18N_DICTIONARY; plural_form,datalength,seed:INTEGER) is
			-- Creation procedure.
		do

			data_generation(t,datalength,seed)
			data_query(t,datalength,seed)
			data_get(t,datalength,seed)
		end


feature	-- Data generation

	data_generation(t:I18N_DICTIONARY; datalength,seed:INTEGER) is
			-- generate array of `I18N_DICTIONARY_ENTRY' and fill it in `t'
			-- fill 't' with datalength of `I18N_DICTIONARY_ENTRY'
		local
			entry:I18N_DICTIONARY_ENTRY
			random:RANDOM
			i:INTEGER
			singular:STRING_GENERAL
			translated_singular, original_plural: STRING_GENERAL
			plural_translation_0: STRING_GENERAL
			plural_translation_1: STRING_GENERAL
			plural_translation_2: STRING_GENERAL
			plural_translation_3: STRING_GENERAL

			file: PLAIN_TEXT_FILE
		do
			create random.set_seed (seed)
			create file.make_create_read_write ("C:\i18n_SVN\Src\library\i18n\test_files\data_file")
			from
				i:=1
				random.start
			until
				i>datalength
			loop
				--generate a `entry' for its first three items
				singular:=random.item.out
				random.forth
				translated_singular:=random.item.out
				random.forth
				original_plural:=random.item.out
				create entry.make_with_plural (singular, translated_singular, original_plural)

				--fill a `entry' with plural translations
				-- are added by hand!

				random.forth
				plural_translation_0:=random.item.out
				random.forth
				plural_translation_1:=random.item.out
				random.forth
				plural_translation_2:=random.item.out
				random.forth
				plural_translation_3:=random.item.out

				entry.plural_translations.enter (plural_translation_0, 0)
				entry.plural_translations.enter (plural_translation_1, 1)
				entry.plural_translations.enter (plural_translation_2, 2)
				entry.plural_translations.enter (plural_translation_3, 3)


				--put `entry' in datastructure
				t.extend (entry)

				-- fill the `file' with the entry
				file.put_string ("entry ")
				file.put_integer (i)
				file.put_string (": %N")
				file.put_string ("original_singular: ")
				file.put_string (entry.original_singular.to_string_8)
				file.put_new_line
				file.put_string ("original_plural: ")
				file.put_string (entry.original_plural.to_string_8)
				file.put_new_line
				file.put_string ("singular_translation: ")
				file.put_string(entry.singular_translation.to_string_8)
				file.put_new_line
				file.put_string("plural_translations: (0) ")
				file.put_string (entry.plural_translations.item (0))
				file.put_string(" (1) ")
				file.put_string (entry.plural_translations.item (1))
				file.put_string(" (2) ")
				file.put_string (entry.plural_translations.item (2))
				file.put_string(" (3) ")
				file.put_string (entry.plural_translations.item (3))
				file.put_new_line

				-- to continue the loop
				i:=i+1
				random.forth
			end
			io.put_string ("data generation is finished")
			io.put_new_line
			file.close
		end


data_query(t:I18N_DICTIONARY; datalength,seed:INTEGER) is
				-- check all query functions in `I18N_DICTIONARY': `has, has_plural'
				-- check all data for every function
				-- use `random' with same `seed'  to check whether they are in `t', one could also use a `linked_list'
				-- to store the data in `data_generation' then use it here to check
				-- use `random' with another `seed' to check whether they are not in `t'
				-- the data_file could also be used, not try it yet
		local
			i,j: INTEGER
			singular: STRING_GENERAL
			translated_singular, original_plural: STRING_GENERAL
			random: RANDOM
			output_file: PLAIN_TEXT_FILE
		do
			-- query with its existent elems
			create random.set_seed (seed)
			create output_file.make_create_read_write ("C:\i18n_SVN\Src\library\i18n\test_files\query_yes_file")
			from
				i:=1
				random.start
			until
				i > datalength
			loop
				singular:=random.item.out
				random.forth
				translated_singular:=random.item.out
				random.forth
				original_plural:=random.item.out
				output_file.put_string ("query ")
				output_file.put_integer (i)
				output_file.put_string (": ")
				output_file.put_new_line
				if t.has (singular) then
					output_file.put_string ("data structure has(")
					output_file.put_string (singular.to_string_8)
					output_file.put_string (")")
					output_file.put_new_line
				else
					output_file.put_string ("data structure do not has(")
					output_file.put_string (singular.to_string_8)
					output_file.put_string (")")
					output_file.put_new_line
				end

				-- i think plural_number could be 0,1,2,3
				-- or 1 2 3 4, i do not know, try them all
				from
					j:=0
				until
					j>10
				loop
					if t.has_plural (singular,original_plural, j.as_integer_32) then
						output_file.put_string ("data structure has_plural with plural_number: ")
						output_file.put_integer (j)
						output_file.put_new_line
					else
						output_file.put_string ("data structure do not has_plural with plural_number: ")
						output_file.put_integer (j)
						output_file.put_new_line
					end
					j:=j+1
				end

				-- to skip the four elements in plural translations
				random.forth
				random.forth
				random.forth
				random.forth

				-- to continue the loop
				random.forth
				i:=i+1
			end
			output_file.close

			-- query with its non-existent elems

			create random.set_seed (seed+1)
			create output_file.make_create_read_write ("C:\i18n_SVN\Src\library\i18n\test_files\query_non_file")
			from
				i:=1
				random.start
			until
				i > datalength
			loop
				singular:=random.item.out
				random.forth
				translated_singular:=random.item.out
				random.forth
				original_plural:=random.item.out
				output_file.put_string ("query ")
				output_file.put_integer (i)
				output_file.put_string (": ")
			--	output_file.put_string ("query "+i.out+": %N")
				output_file.put_new_line
				if t.has (singular) then
					output_file.put_string ("data structure has(")
					output_file.put_string (singular.to_string_8)
					output_file.put_string (")")
					output_file.put_new_line
				else
					output_file.put_string ("data structure do not has(")
					output_file.put_string (singular.to_string_8)
					output_file.put_string (")")
					output_file.put_new_line
				end

				-- i think `plural_number' could be 0,1,2,3
				-- or 1 2 3 4, i do not know, try them all
				-- `plural_number'>=0

				from
					j:=0
				until
					j>10
				loop
					if t.has_plural (singular,original_plural, j.as_integer_32) then
						output_file.put_string ("data structure has_plural with plural_number: ")
						output_file.put_integer (j)
						output_file.put_new_line
					else
						output_file.put_string ("data structure do not has_plural with plural_number: ")
						output_file.put_integer (j)
						output_file.put_new_line
					end
					j:=j+1
				end

			-- to continue the loop
				random.forth
				i:=i+1
			end
			output_file.close
			io.put_string ("data query is finished%N")
		end

feature -- Data access

	data_get(t:I18N_DICTIONARY; datalength,seed:INTEGER) is
				-- check data access functions in `I18N_DICTIONARY': `get_plural, get_sigular'
				-- use 'random' with same `seed' to get them out
				-- use 'random'  with another `seed' get nothing out
				-- again `linked_list' to store the data in `data_generation' could be comfortable
				-- the data_file could also be used, not try it yet
		local
			i,j: INTEGER
			singular: STRING_GENERAL
			translated_singular, original_plural: STRING_GENERAL
			random: RANDOM
			output_file: PLAIN_TEXT_FILE
		do

			-- get data with its existent elems
			create random.set_seed (seed)
			create output_file.make_create_read_write ("C:\i18n_SVN\Src\library\i18n\test_files\get_data_file")
			from
				i:=1
				random.start
			until
				i > datalength
			loop
				singular:=random.item.out
				random.forth
				translated_singular:=random.item.out
				random.forth
				original_plural:=random.item.out
				output_file.put_string ("get data iteration " + i.out + ": " + "%N")

				if t.has (singular) then
					output_file.put_string ("get_singular(" + singular.as_string_8 + "): "+ t.get_singular (singular)+"%N")
				else
					output_file.put_string ("not has(" + singular.as_string_8 + "): "+ "%N")
				end


				-- i think `plural_number' could be 0,1,2,3
				-- or 1 2 3 4, i do not know, try them all
				-- actually plural_number >=0
				from
					j:=0
				until
					j>10
				loop
					if t.has_plural (singular,original_plural, j.as_integer_32) then
						output_file.put_string ("get_plural (" + singular.as_string_8 + "," + original_plural.as_string_8 + "," + j.out +"): "
						+ t.get_plural (singular, original_plural, j.as_integer_32)+"%N")

					else

						output_file.put_string (" not has_plural (" + singular.as_string_8 + "," + original_plural.as_string_8 + "," + j.out +") %N "
					)

					end
					j:=j+1
				end

				-- to skip the four elements in plural translations
				random.forth
				random.forth
				random.forth
				random.forth

				-- to continue the loop
				random.forth
				i:=i+1
			end
			output_file.close

			-- get data  with its non-existent elems
			-- actually we could only get data with its existence

			create random.set_seed (seed+1)
			create output_file.make_create_read_write ("C:\i18n_SVN\Src\library\i18n\test_files\get_data_non_file")
			from
				i:=1
				random.start
			until
				i > datalength
			loop
				singular:=random.item.out
				random.forth
				translated_singular:=random.item.out
				random.forth
				original_plural:=random.item.out
				output_file.put_string ("get_data_iteration " + i.out + ": " + "%N")


				if t.has (singular) then
					output_file.put_string ("get_singular(" + singular.as_string_8 + "): "+ t.get_singular (singular)+"%N")
				else
					output_file.put_string (" not has_singular(" + singular.as_string_8 + ") %N ")
				end

				-- i think `plural_number' could be 0,1,2,3
				-- or 1 2 3 4, i do not know, try them all
				-- actually plural_number >=0
				from
					j:=0
				until
					j>10
				loop
					if t.has_plural (singular,original_plural, j.as_integer_32) then
						output_file.put_string ("get_plural (" + singular.as_string_8 + "," + original_plural.as_string_8 + "," + j.out +"): "
						+ t.get_plural (singular, original_plural, j.as_integer_32)+"%N")

					else

						output_file.put_string (" not has_plural (" + singular.as_string_8 + "," + original_plural.as_string_8 + "," + j.out +")%N")

					end
					j:=j+1
				end

			-- to continue the loop
				random.forth
				i:=i+1
			end
			output_file.close
			io.put_string ("data_get is finished")
		end








end -- class ROOT_CLASS
