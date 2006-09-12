indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALE_ID

	inherit
		ANY
	redefine
		is_equal
	end


feature  -- Informations
	name : STRING_32

feature	 -- Comparison

	is_equal (other: like Current): BOOLEAN is
			--
		do
			Result := name.is_equal (other.name)
		end


end
