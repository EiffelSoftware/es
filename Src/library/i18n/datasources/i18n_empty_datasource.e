indexing
	description: "Empty datasource used for internationalization purposes."
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_EMPTY_DATASOURCE

inherit
	I18N_DATASOURCE

create {I18N_DATASOURCE_FACTORY}

	make_empty

feature -- Initialization

	make_empty is
			-- Creation procedure.
		do
			make
			initialize
		end

feature -- Status setting

	initialize is
			-- Initialize the datasource.
		do
			-- Do nothing
			is_ready := true
		end

	open is
			-- Open the datasource.
		do
			-- Do nothing
			is_open := true
		end

	close is
			-- Close the datasource.
		do
			-- Do nothing
			is_open := false
		end

feature -- Basic operations

	get_original (i_th: INTEGER): LIST[STRING_32] is
			-- What's the `i_th' original string?
		do
			-- Do nothing.
		end

	get_translated (i_th: INTEGER): LIST[STRING_32] is
			-- What's the `i_th' translated string?
		do
			-- Do nothing.
		end

invariant

	string_count = 0
	plural_forms = 2
	plural_form_identifier.is_equal("n != 1;")
	retrieval_method = retrieve_by_string

end
