class
	CAT_INHERIT_FROM_ANY_2

-- Should not violate the inherit from any rule.
inherit
	ANY
	
feature {NONE} -- Test

	dummy (a1: INTEGER) : INTEGER
	do
		Result := a1 + 50
	end

end
