class
	CAT_INHERIT_FROM_ANY_1

-- Violates the inherit from any rule.
inherit
	ANY

feature {NONE} -- Test

	dummy (a1: INTEGER) : INTEGER
	do
		Result := a1 + 50
	end

end
