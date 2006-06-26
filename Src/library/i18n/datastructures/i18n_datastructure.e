indexing
	description: "Datastructure for storing original and translated string for localization purposes."
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_DATASTRUCTURE

feature {I18N_DATASTRUCTURE_FACTORY} -- Initialization

	make is
			-- Initialize `Current'.
		local
			datasource_factory: I18N_DATASOURCE_FACTORY
				-- Temporary factory
		do
			create datasource_factory.make
			i18n_datasource := datasource_factory.last_datasource
			create base_array.make(1, i18n_datasource.string_count)
			create i18n_plural_forms.make_with_identifier(i18n_datasource.plural_forms, i18n_datasource.plural_form_identifier)
			initialize
		ensure
			base_array /= Void
			i18n_datasource /= Void
			i18n_plural_forms /= Void
		end

	make_with_datasource (a_datasource: I18N_DATASOURCE) is
			-- Initialize `Current'.
		require
			valid_datasource: a_datasource /= Void and then a_datasource.is_ready
		do
			make
			load(a_datasource)
		ensure
			base_array /= Void
			i18n_datasource /= Void
			i18n_plural_forms /= Void
		end

feature -- Loading

	load (a_datasource: I18N_DATASOURCE) is
			-- Load this datasource.
		require
			valid_datasource: a_datasource /= Void and then a_datasource.is_ready
		do
			i18n_datasource := a_datasource
			if not i18n_datasource.is_open then
				i18n_datasource.open
				populate_array
				i18n_datasource.close
				initialize
			end
			create i18n_plural_forms.make_with_identifier (i18n_datasource.plural_forms, i18n_datasource.plural_form_identifier)
		ensure
			base_array_set: base_array /= Void and then base_array.count = i18n_datasource.string_count
			datasource_set: i18n_datasource = a_datasource
			i18n_plural_forms_set: i18n_plural_forms /= Void
		end


feature {NONE} -- Basic operations

	initialize is
			-- Initialize this datastructure.
		deferred
		end

	search (a_string: STRING_32; i_th: INTEGER): STRING_32 is
			-- What is the translation of a_string?
		require
			valid_string: a_string /= Void
		deferred
		end

feature -- Translation

	translate (a_singular, a_plural: STRING_GENERAL; a_num: INTEGER): STRING_32 is
			-- Can you give me the translation?
			-- aka interface to the LOCALIZATOR class
		require
			valid_singular: a_singular /= Void
			valid_plural: a_plural /= Void
		local
			l_plural_form: INTEGER
				-- Plural form
			l_string: STRING_32
				-- STRING_32 representation
		do
			if a_singular.is_equal("") then
				Result := ""
			else
				l_string := a_singular.as_string_32
				l_plural_form := i18n_plural_forms.get_plural_form(a_num)
				Result := search(l_string, l_plural_form)
				if Result = Void then
					if a_num /= 1 then
						Result := a_plural.as_string_32
					else
						Result := l_string
					end
				end
			end
		end

feature {NONE} -- Loading

	populate_array is
			-- Populates the array.
		do
			create base_array.make(1, i18n_datasource.string_count)
			if i18n_datasource.retrieval_method = i18n_datasource.retrieve_by_type then
				populate_array_by_type
			else
				populate_array_by_string
			end
		ensure
			base_array /= Void
		end

	populate_array_by_string is
			-- Populates the array by string.
			-- More object oriented, used for example for databases.
		require
			base_array /= Void
		local
			i: INTEGER
				-- Iterator
			temp_string: I18N_STRING
				-- Temporary string
		do
			from -- spatial locality
				i := 1
			invariant
				i >= 1
				i <= i18n_datasource.string_count + 1
			variant
				i18n_datasource.string_count + 1 - i
			until
				i > i18n_datasource.string_count
			loop
				create temp_string.make_with_id(i)
				temp_string.set_plural_forms(i18n_datasource.plural_forms)
				temp_string.set_original(i18n_datasource.get_original(i))
				temp_string.set_translated(i18n_datasource.get_translated(i))
				base_array.put(temp_string, i)
				i := i + 1
			end
		end

	populate_array_by_type is
			-- Populates the array by type.
			-- First all originals and then all translateds for spatial locality.
		require
			base_array /= Void
		local
			i: INTEGER
				-- Iterator
			temp_string: I18N_STRING
				-- Temporary string
		do
			from -- spatial locality
				i := 1
			invariant
				i >= 1
				i <= i18n_datasource.string_count + 1
			variant
				i18n_datasource.string_count + 1 - i
			until
				i > i18n_datasource.string_count
			loop
				create temp_string.make_with_id(i)
				temp_string.set_plural_forms(i18n_datasource.plural_forms)
				temp_string.set_original(i18n_datasource.get_original(i))
				base_array.put(temp_string, i)
				i := i + 1
			end
			from -- spatial locality
				i := 1
			invariant
				i >= 1
				i <= base_array.count + 1
			variant
				base_array.count + 1 - i
			until
				i > base_array.count
			loop
				base_array.item(i).set_translated(i18n_datasource.get_translated(base_array.item(i).id))
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	base_array: ARRAY[I18N_STRING]
		-- Where all the strings are stored

	i18n_datasource: I18N_DATASOURCE
		-- Reference to the datasource

	i18n_plural_forms: I18N_PLURAL_FORMS
		-- Reference to the plural form resolver

invariant

	valid_array: base_array /= Void
	valid_datasource: i18n_datasource /= Void
	valid_plural_forms: i18n_plural_forms /= Void

end
