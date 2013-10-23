class L_GENERIC_USE

feature

	use
		local
			l_generic: L_GENERIC [ANY, L_CONSTRAINT]
			l_any: ANY
			l_constraint: L_CONSTRAINT
		do
			l_generic.g_function (l_any)
			l_generic.h_function (l_constraint)
		end


end
