class
	CAT_INHERIT_FROM_ANY_2

-- Should not violate the inherit from any rule.
inherit
	CAT_INHERIT_FROM_ANY_1
		undefine
			out
		end
	ANY

feature {NONE} -- Test

	dummy4 (a1: INTEGER) : INTEGER
	do
		Result := a1 + 50
	end

end
