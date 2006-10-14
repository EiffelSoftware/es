indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_FILE_MANAGER inherit

		I18N_DATASOURCE_MANAGER
		redefine
			make
		end

	create
		make

	feature
		-- Creation
		make (an_uri: STRING_GENERAL) is
			do
				Precursor(an_uri)
				-- Initialize chain-of-responsability
				create {I18N_MO_HANDLER} chain
				-- There is no next element for now
				create directory.make (an_uri.to_string_8)
				populate_file_list
			ensure then
				at_least_one_handler: chain /= Void
				directory_created: directory /= Void
				file_list_created: file_list /= Void
			end


	feature
		-- Access
		get_dictionary(a_locale: I18N_LOCALE_ID): I18N_DICTIONARY is
				-- return appropriate dictionary
				do
					Result := chain.extract_dictionary (file_list.item (a_locale))
				end

		available_locales: LINEAR[I18N_LOCALE_ID] is
				-- return available locales
				do
					create {ARRAYED_LIST[I18N_LOCALE_ID]} Result.make_from_array (locale_list)
				end

	feature {NONE} -- Implementation

		chain: I18N_FILE_HANDLER
		directory: DIRECTORY
		file_list: HASH_TABLE[STRING_8, I18N_LOCALE_ID]
		locale_list: ARRAYED_LIST[I18N_LOCALE_ID]

		populate_file_list is
				--
			require
				directory_not_void: directory /= Void
			local
				temp: LIST[STRING_8]
				locale: I18N_LOCALE_ID
			do
				create file_list.make(16)
				create locale_list.make(16)
				if directory.is_readable then
					directory.open_read
					temp := directory.linear_representation
					from
						temp.start
					until
						temp.after
					loop
						locale := chain.get_file_locale (uri+
														 Operating_environment.directory_separator.out+
														 temp.item)
						if locale /= Void then
							--have we already encountered this locale?
							--policy on duplicate locales: ignore the second one.

							--TODO!!!!!!!!!!
							file_list.put(uri+Operating_environment.directory_separator.out+temp.item,locale)
							if  file_list.inserted then
								locale_list.extend(locale)
							end
						end
						temp.forth
					end
				end
			end



invariant
	--directory /= Void
	--file_list /= Void
	--locale_list /= Void
end
