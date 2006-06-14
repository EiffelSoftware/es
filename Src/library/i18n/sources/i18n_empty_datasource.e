indexing
	description: "Empty datasource used for internationalization purposes."
	status: "NOTE: This class is NOT production ready, we reccommend that you don't use it!"
	author: "Originally created by Martino Trosi, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_EMPTY_DATASOURCE

inherit
	I18N_DATASOURCE

create {I18N_DATASOURCE_FACTORY}
	make

feature {NONE} -- Initialization
	make is
			-- Initialization procedure
		do
			string_count := 0
			plural_forms := 2
			plural_form_identifier := "n != 1;"
		end


feature -- Status setting
	close is
		do
			-- Do nothing
			is_open := false
		end

	open is
		do
			-- Do nothing
			is_open := true
		end

feature -- Basic operations
	get_originals(i_th: INTEGER): LIST[STRING_32] is
			-- What's the `i_th' original string?
		do
			-- Do nothing.
		end

	get_translateds(i_th: INTEGER): LIST[STRING_32] is
			-- What's the `i_th' translated string?
		do
			-- Do nothing.
		end

invariant
	invariant_clause: True -- Your invariant here

end
