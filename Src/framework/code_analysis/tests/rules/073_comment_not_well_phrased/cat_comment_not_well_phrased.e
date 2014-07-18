class
	CAT_COMMENT_NOT_WELL_PHRASED

feature {NONE} -- Test

	-- Violates the comment not well phrased rule.
	bad_comments (a1: BOOLEAN; a2, a3: INTEGER)
		local
			a: INTEGER
		do
			-- checks if a1 true
			if a1 then
				-- a1 is true
				a := a2
			else
				-- a1 is false
				a := a3
			end
		end

end
