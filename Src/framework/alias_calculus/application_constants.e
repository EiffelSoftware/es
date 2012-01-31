note
	description: "Auxiliary declarations for building programs."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_CONSTANTS

feature -- Program variables

	a: VARIABLE
			-- Variable "a".
		once create {VARIABLE} Result.make ("a") end

	b: VARIABLE
			-- Variable "b".
		once create {VARIABLE} Result.make ("b") end

	c: VARIABLE
			-- Variable "c".
		once create {VARIABLE} Result.make ("c") end

	d: VARIABLE
			-- Variable "d".
		once create {VARIABLE} Result.make ("d") end

	ee: VARIABLE
			-- Variable "e".
		once create {VARIABLE} Result.make ("e") end

	ff: VARIABLE
			-- Variable "f".
		once create {VARIABLE} Result.make ("f") end

	gg: VARIABLE
			-- Variable "g".
		once create {VARIABLE} Result.make ("g") end

	hh: VARIABLE
			-- Variable "h".
		once create {VARIABLE} Result.make ("h") end

	ii: VARIABLE
			-- Variable "i".
		once create {VARIABLE} Result.make ("i") end

	mm: VARIABLE
			-- Variable "m".
		once create {VARIABLE} Result.make ("m") end


	nn: VARIABLE
			-- Variable "n".
		once create {VARIABLE} Result.make ("n") end

	next: VARIABLE
			-- Variable "next".
		once create {VARIABLE} Result.make ("next") end

	oo: VARIABLE
			-- Variable "o".
		once create {VARIABLE} Result.make ("o") end

	pp: VARIABLE
			-- Variable "pp".
		once create {VARIABLE} Result.make ("p") end

	qq: VARIABLE
			-- Variable "q".
		once create {VARIABLE} Result.make ("q") end

	rr: VARIABLE
			-- Variable "r".

		once create {VARIABLE} Result.make ("o") end

	u: VARIABLE
			-- Variable "u".
		once create {VARIABLE} Result.make ("u") end

	x: VARIABLE
			-- Variable "x".
		once create {VARIABLE} Result.make ("x") end

	q_client: VARIABLE
			-- Variable "q_client".
		once create {VARIABLE} Result.make ("q_client") end

	v: VARIABLE
			-- Variable "v".
		once create {VARIABLE} Result.make ("v") end

	y: VARIABLE
			-- Variable "y".
		once create {VARIABLE} Result.make ("y") end

	z: VARIABLE
			-- Variable "z".
		once create {VARIABLE} Result.make ("z") end

--	z: VARIABLE
--			-- Variable "z".
--		once create {VARIABLE} Result.make ("z") end

feature -- Negated variables

	xprime: VARIABLE
			-- Inverse of variable "x".
		once Result := x.inverse end

	q_client_prime: VARIABLE
			-- Inverse of variable "q_client".
		once Result := q_client.inverse end


feature -- Multidot expressions


	x_a: MULTIDOT
			-- Multidot "x.a".
		once create {MULTIDOT} Result.make_from_two_variables (x, a) end

	x_next: MULTIDOT
			-- Multidot "x.next".
		once create {MULTIDOT} Result.make_from_two_variables (x, next) end

	a_f: MULTIDOT
			-- Multidot "a.f".
		once create {MULTIDOT} Result.make_from_two_variables (a, ff) end

	xprime_a: MULTIDOT
			-- Multidot "x'.a".
		once create {MULTIDOT} Result.make_from_two_variables (xprime, a) end

	xprime_f: MULTIDOT
			-- Multidot "x'.f".
		once create {MULTIDOT} Result.make_from_two_variables (xprime, ff) end

	q_client_prime_f: MULTIDOT
			-- Multidot "x'.f".
		once create {MULTIDOT} Result.make_from_two_variables (q_client_prime, ff) end

feature -- Variables specific to the list example

	el: VARIABLE
			-- Variable "el".
		once create {VARIABLE} Result.make ("el") end

	extend_client: VARIABLE
			-- Variable "extend_client".
		once create {VARIABLE} Result.make ("extend_client") end

	first1: VARIABLE
			-- Variable "first".
		once create {VARIABLE} Result.make ("first") end

	last1: VARIABLE
			-- Variable "last".
		once create {VARIABLE} Result.make ("last") end

	item1: VARIABLE
			-- Variable "item".
		once create {VARIABLE} Result.make ("item") end

	new: VARIABLE
			-- Variable "new".
		once create {VARIABLE} Result.make ("new") end

	right1: VARIABLE
			-- Variable "right".
		once create {VARIABLE} Result.make ("right") end



feature -- Negated variables specific to the list example

	extend_client_prime: VARIABLE
			-- Inverse of variable "extend_client".
		once Result := extend_client.inverse end

	last_prime: VARIABLE
			-- Inverse of variable "last".
		once Result := last1.inverse end

	new_prime: VARIABLE
			-- Inverse of variable "new".
		once Result := new.inverse end

feature -- Expressions specific to the list example

	extend_client_prime_el: MULTIDOT
			-- Multidot "extend_client'.el".
		once create {MULTIDOT} Result.make_from_two_variables (extend_client_prime, el) end

	f_right: MULTIDOT
			-- Multidot "f.right".
		once create {MULTIDOT} Result.make_from_two_variables (ff, right1) end

	g_right: MULTIDOT
			-- Multidot "f.right".
		once create {MULTIDOT} Result.make_from_two_variables (gg, right1) end

	last_right: MULTIDOT
			-- Multidot "last.right".
		once create {MULTIDOT} Result.make_from_two_variables (last1, right1) end

	last_prime_new: MULTIDOT
			-- Multidot "last'.right".
		once create {MULTIDOT} Result.make_from_two_variables (last_prime, new) end

	new_prime_a: MULTIDOT
			-- Multidot "new'.a".
		once create {MULTIDOT} Result.make_from_two_variables (new_prime, a) end

	x_first: MULTIDOT
			-- Multidot "x.first".
		once create {MULTIDOT} Result.make_from_two_variables (x, first1) end

	y_first: MULTIDOT
			-- Multidot "y.first".
		once create {MULTIDOT} Result.make_from_two_variables (y, first1) end

feature -- Variables and expressions specific to the deadlock example

	p1: VARIABLE
			-- Attribute "p1" in MEAL.
		once create {VARIABLE} Result.make ("p1") end

	p2: VARIABLE
			-- Attribute "p2" in MEAL.
		once create {VARIABLE} Result.make ("p2") end

	f1: VARIABLE
			-- Attribute "f1" in MEAL.
		once create {VARIABLE} Result.make ("f1") end

	f2: VARIABLE
			-- Attribute "f2 in MEAL.
		once create {VARIABLE} Result.make ("f2") end

	cx: VARIABLE
			-- Argument "cx" to `go_correct' in MEAL.
		once create {VARIABLE} Result.make ("cx") end

	cy: VARIABLE
			-- Argument "cy" to `go_correct' in MEAL.
		once create {VARIABLE} Result.make ("cy") end

	wx: VARIABLE
			-- Argument "wx" to `go_wrong' in MEAL.
		once create {VARIABLE} Result.make ("wx") end

	wy: VARIABLE
			-- Argument "wy" to `go_wrong' in MEAL.
		once create {VARIABLE} Result.make ("wy") end

	left: VARIABLE
			-- Attribute "left" in PHILOSOPHER.
		once create {VARIABLE} Result.make ("left") end

	right: VARIABLE
			-- Attribute "right" in PHILOSOPHER.
		once create {VARIABLE} Result.make ("right") end

	pmx: VARIABLE
			-- Argument "pmx" to `make' in PHILOSOPHER.
		once create {VARIABLE} Result.make ("pmx") end

	pmy: VARIABLE
			-- Argument "pmy" to `make' in PHILOSOPHER.
		once create {VARIABLE} Result.make ("pmy") end

	tz: VARIABLE
			-- Argument "tz" to `pick_in_turn' in PHILOSOPHER.
		once create {VARIABLE} Result.make ("tz") end

	pmc: VARIABLE
			-- Target of `make' of PHILOSOPHER.
		once create {VARIABLE} Result.make ("pmc") end

	pma1: VARIABLE
			-- First actual argument of `make' of PHILOSOPHER.
		once create {VARIABLE} Result.make ("pma1") end

	pma2: VARIABLE
			-- Second actual argument of `make' of PHILOSOPHER.
		once create {VARIABLE} Result.make ("pma2") end



feature -- Negated variables specific to the deadlock example

	p1_prime: VARIABLE
			-- Inverse of variable "p1".
		once Result := p1.inverse end


	p2_prime: VARIABLE
			-- Inverse of variable "p2".
		once Result := p2.inverse end


	cx_prime: VARIABLE
			-- Inverse of variable "cx".
		once Result := cx.inverse end

	cy_prime: VARIABLE
			-- Inverse of variable "cy".
		once Result := cy.inverse end

	pmc_prime: VARIABLE
			-- Inverse of variable "pmc".
		once Result := pmc.inverse end

feature -- Expressions specific to the deadlock example

	pmc_prime_actual1: MULTIDOT
			-- Multidot "pmc_prime.actuall".
		once create {MULTIDOT} Result.make_from_two_variables (pmc_prime, pma1) end

	pmc_prime_actual2: MULTIDOT
			-- Multidot "pmc_prime.actual2".
		once create {MULTIDOT} Result.make_from_two_variables (pmc_prime, pma2) end

	p1_prime_actual1: MULTIDOT
			-- Multidot "p1.actuall".
		once create {MULTIDOT} Result.make_from_two_variables (p1_prime, pma1) end

	p1_prime_actual2: MULTIDOT
			-- Multidot "p1.actual2".
		once create {MULTIDOT} Result.make_from_two_variables (p1_prime, pma2) end

	p2_prime_actual1: MULTIDOT
			-- Multidot "p2.actuall".
		once create {MULTIDOT} Result.make_from_two_variables (p2_prime, pma1) end

	p2_prime_actual2: MULTIDOT
			-- Multidot "p2.actual2".
		once create {MULTIDOT} Result.make_from_two_variables (p2_prime, pma2) end


feature -- Handling target calls

	target: VARIABLE
			-- Target of qualified calls.
		once create {VARIABLE} Result.make ("target") end

	target_prime: VARIABLE
			-- Inverse of  "target".
		once Result := target.inverse end

	target_prime_f: MULTIDOT
			-- Multidot "target'.f".
		once create {MULTIDOT} Result.make_from_two_variables (target_prime, ff) end
feature -- Miscellaneous constants



end
