indexing
	description: "Dummy datastructure, returns what it gets."
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_BYPASS_DATASTRUCTURE

inherit
	I18N_DATASTRUCTURE

create {I18N_DATASTRUCTURE_FACTORY}

	make,
	make_with_datasource

feature {NONE} -- Initialization

	initialize is
			-- Dummy initialization.
		do
			-- Do nothing, we don't store any data.
		end

feature {NONE} -- Basic operations

	search (a_string: STRING_32; i_th: INTEGER): STRING_32 is
			-- Can you please give me back the same string?
		do
			Result := a_string
		ensure then
			Result /= Void and then Result.is_equal(a_string)
		end

invariant

	invariant_clause: True -- Your invariant here

end
