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

create
	make

feature

	make (a_string : STRING_32) is
			--
		require
			a_string_exists: a_string /= Void
		do
			name := a_string
		end



feature  -- Informations
	name : STRING_32

feature	 -- Comparison

	is_equal (other: like Current): BOOLEAN is
			--
		do
			Result := name.is_equal (other.name)
		end

invariant
	name_exists: name /= Void
end
