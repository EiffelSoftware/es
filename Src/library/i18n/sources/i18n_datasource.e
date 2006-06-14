indexing
	description: "Abstract datasource for internationalization purposes."
	status: "NOTE: This class is NOT production ready, we reccommend that you don't use it!"
	author: "Originally created by Martino Trosi, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_DATASOURCE

feature -- Source information
	string_count: INTEGER
			-- How many string are there in this source?

	plural_forms: INTEGER
			-- Number of plural forms

	plural_form_identifier: STRING_32
			-- Identifier of the plural form function

feature -- Status setting
	open is
			-- Open and prepare the datasource.
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
	valid_index(a_index: INTEGER): BOOLEAN is
			-- Is the index in valid range?
		do
			Result := (a_index >= 0) and (a_index <= string_count)
		end

	is_ready: BOOLEAN is
			-- Is the datasource ready to load the strings?
		do
			Result := is_open
		end

	is_open: BOOLEAN
			-- Is the datasource open?

	is_closed: BOOLEAN is
			-- Is the datasource closed?
		do
			Result := not is_open
		end

feature -- Basic operations
	get_originals(i_th: INTEGER): LIST[STRING_32] is
			-- What's the `i_th' original string?
		require
			valid_index: valid_index(i_th)
		deferred
		ensure
			result_exists: Result /= Void
		end

	get_translateds(i_th: INTEGER): LIST[STRING_32] is
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
	is_ready implies is_open

end
