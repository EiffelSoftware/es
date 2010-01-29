note
	description: "Summary description for {MUSICIAN}."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "P(x, {age:a}) = P$PERSON(x,{age:a})"
	sl_predicate: "M(x, {age:a;pfm:p}) = P$MUSICIAN(x,{age:a}) * x.<MUSICIAN.my_performances> |-> p"
	sl_predicate: "RestMtoP(x, {pfm:p}) = x.<MUSICIAN.my_performances> |-> p"
	js_logic: "musician.logic"
	js_abstraction: "musician.abs"

class
	MUSICIAN

inherit
	PERSON
		redefine init end

create
	init

feature

	init (a: INTEGER; p: INTEGER; dummy: INTEGER)
		require else
			--SL-- True
		do
			Precursor {PERSON} (a, 1, 2)
			my_performances := p
		ensure then
			--SL-- M$(Current,{age:a;pfm:p})
		end

	performances: INTEGER
		require
			--SL-- M$(Current,{age:_a;pfm:_p})
		do
			Result := my_performances
		ensure
			--SL-- M$(Current,{age:_a;pfm:_p}) * Result = _p
		end

	perform
		require
			--SL-- M$(Current,{age:_a;pfm:_p})
		do
			my_performances := my_performances + 1
		ensure
			--SL-- M$(Current,{age:_a;pfm:builtin_plus(_p,1)})
		end

	my_performances: INTEGER

end
