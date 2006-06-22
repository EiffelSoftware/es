indexing
	description: "Strings used in the interface"
	author: "i18m team"
	date: "$Date$"
	revision: "$Revision$"

class
	NAMES

inherit
	SHARED_I18N_LOCALIZATOR

create
	make

feature -- text

	application: STRING_32 is
		do
			Result := i18n ("Application");
		end
	file: STRING_32 is
		do
			Result := i18n ("File");
		end
	increase: STRING_32 is
		do
			Result := i18n("Increase n");
		end
	decrease: STRING_32 is
		do
			Result := i18n("Decrease n");
		end
	save: STRING_32 is
		do
			Result := i18n("Save");
		end
	simple: STRING_32 is
		do
			Result := i18n ("Simple label");
		end


	now_equal: STRING_32 is
		do
			Result := i18n ("n is now equal $1")
		end

	this_singular_plural (n: INTEGER): STRING_32 is
		do
			Result := i18n_pl ("This is singular","This is plural", n)
		end

	there_are_n_files (n: INTEGER): STRING_32 is
		do
			Result := i18n_pl ("There is 1 file","There are $1 files", n)
		end

	language : STRING_32 is
		do
			Result := i18n ("Select language")
		end

	italian : STRING_32 is
		do
			Result := i18n ("italian")
		end


	arabic : STRING_32 is
		do
			Result := i18n ("arabic")
		end

	greek : STRING_32 is
		do
			Result := i18n ("greek")
		end

	hebrew : STRING_32 is
		do
			Result := i18n ("hebrew")
		end

	japanese : STRING_32 is
		do
			Result := i18n ("japanese")
		end

	russian : STRING_32 is
		do
			Result := i18n ("russian")
		end

	chinese : STRING_32 is
		do
			Result := i18n ("chinese")
		end

	english : STRING_32 is
		do
			Result := i18n ("english")
		end



feature -- creation

	make (a_language: STRING) is
			-- Load translated strings
		local
			l_source_factory: I18N_DATASOURCE_FACTORY
			l_structure_factory: I18N_DATASTRUCTURE_FACTORY
			l_lang: STRING
		do
			l_lang := a_language
			-- check if no language was given and use en as default
			if l_lang = Void or else l_lang.is_empty then
				l_lang := "en"
			end
			create l_source_factory.make

			-- create datasource, where translated strings reside
			l_source_factory.use_mo_file (Operating_environment.current_directory_name_representation
					+ Operating_environment.directory_separator.out + l_lang + ".mo")
			if l_source_factory.last_datasource /= Void then
				i18n_use_datasource(l_source_factory.last_datasource)
			else
				l_source_factory.use_empty_source
				i18n_use_datasource(l_source_factory.last_datasource)
			end

			-- create datastructure, where strings will be loaded
			create l_structure_factory.make
			l_structure_factory.use_hash_table
			if l_structure_factory.last_datastructure /= Void then
				i18n_use_datastructure(l_structure_factory.last_datastructure)
			else
				l_structure_factory.use_dummy
				i18n_use_datastructure(l_structure_factory.last_datastructure)
			end

			-- load strings
			i18n_load

		end


end
