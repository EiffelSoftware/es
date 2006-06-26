indexing
	description: "Abstract datasource for internationalization purposes."
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_DATASOURCE

feature {NONE} -- Initialization

	make is
			-- Initialization procedure
		do
			-- See class invariants
			string_count := 0
			plural_forms := 2
			plural_form_identifier := "n != 1;"
			retrieval_method := retrieve_by_string -- Object-oriented
		end
		
feature -- Source information

	string_count: INTEGER
			-- How many string are there in this source?

	plural_forms: INTEGER
			-- Number of plural forms

	plural_form_identifier: STRING_32
			-- Identifier of the plural form function

	retrieval_method: INTEGER
			-- Method to use to retrieve strings
			-- retrieve_by_type: first all originals, then all translateds
			--   (to preserve spatial locality, i.e. in files)
			-- retrieve_by_string: in order, original and translated, then next string
			--   (to be more object oriented, used i.e. in databases)

	retrieve_by_type, retrieve_by_string: INTEGER is unique
			-- Defines the retrieval methods

feature -- Status setting

	initialize is
			-- Check the datasource.
		deferred
		end

	open is
			-- Open and prepare the datasource.
		require
			is_ready
		deferred
		ensure
			is_open and then is_ready
		end

	close is
			-- Clean up and close the datasource.
		require
			is_open
		deferred
		ensure
			is_closed
		end

feature -- Status report

	valid_index (a_index: INTEGER): BOOLEAN is
			-- Is the index in valid range?
		do
			Result := (a_index >= 1) and (a_index <= string_count)
		end

	is_ready: BOOLEAN
			-- Is the datasource valid and ready to load the strings?

	is_open: BOOLEAN
			-- Is the datasource open?

	is_closed: BOOLEAN is
			-- Is the datasource closed?
		do
			Result := not is_open
		end

feature -- Basic operations

	get_original (i_th: INTEGER): LIST[STRING_32] is
			-- What's the `i_th' original string?
		require
			valid_index: valid_index(i_th)
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_translated (i_th: INTEGER): LIST[STRING_32] is
			-- What's the `i_th' translated string?
		require
			valid_index: valid_index(i_th)
		deferred
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Implementation

invariant

	valid_plural_forms: plural_forms >= 1 and plural_forms <= 4
	valid_plural_form_identifier: plural_form_identifier /= Void and then not plural_form_identifier.is_empty
	is_open = not is_closed

end
