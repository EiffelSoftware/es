note
	-- a replaces x, y is old and b is new
	model: a, yy, b

class
	A_REMODELS

inherit
	A_MODELS
		rename
			x as xx,
			y as yy,
			bar_ok as bar_not_so_ok
		redefine
			foo,
			suspicious
		end


feature
	a: BOOLEAN
		note
			replaces: xx
		attribute
		end

	b: BOOLEAN

	foo
		require else
			modify_model ("a", Current)
		do
			xx := 1
			z := 1
			yy := 1
			a := True
			b := True -- Bad
		end

	-- bar still fails as before
	-- bar_not_so_ok now fails because its supplier foo now has a bigger frame

	bad1
		require
			modify_model (["z"], Current) -- Bad: z is not a model
		do
		end

	suspicious
		require else
			modify_model ("yy", Current) -- Bad: yy is outside of the parent's frame
		do
		end

invariant
	xx_definition: xx = if a then 1 else 0 end
end
