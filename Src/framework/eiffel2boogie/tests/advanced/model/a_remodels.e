note
	-- a replaces x, y is old and b is new
	model: a, yy, b

class
	A_REMODELS

inherit
	A_MODELS
		rename
			x as xx,
			y as yy
		redefine
			foo
		end


feature
	a: BOOLEAN
		note
			replaces: xx
		attribute
		end

	b: BOOLEAN

	foo
		do
			xx := 1
			z := 1
			yy := 1
			a := True
			b := True -- Bad
		end

	bad1
		require
			modify_model (["xx", "closed"], Current) -- Bad: xx is not a model
		do
		end

invariant
	xx_definition: xx = if a then 1 else 0 end
end
