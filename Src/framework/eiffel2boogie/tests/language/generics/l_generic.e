class L_GENERIC [G, H -> L_CONSTRAINT]

feature

	g_attribute: G

	h_attribute: H

	g_function (a_g: G)
		do
			g_attribute := a_g
			g_attribute.do_nothing
		end

	h_function (a_h: H)
		do
			h_attribute := a_h
			h_attribute.func
		end

end
