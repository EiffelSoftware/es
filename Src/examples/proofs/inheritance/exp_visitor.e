deferred class
	EXP_VISITOR

feature

	process_constant (a_constant: !CONSTANT)
		deferred
		end

	process_plus (a_plus: !PLUS)
		deferred
		end

	process_minus (a_minus: !MINUS)
		require
			a_minus /= a_minus.exp
		deferred
		end

	sum: INTEGER

end
