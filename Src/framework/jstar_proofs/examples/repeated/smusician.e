note
	description: "A student musician."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "P(x, {age:a}) = P$PERSON(x,{age:a})"
	sl_predicate: "S(x, {age:a;exm:e}) = S$STUDENT(x,{age:a;exm:e})"
	sl_predicate: "M(x, {age:a;pfm:p}) = M$MUSICIAN(x,{age:a;pfm:p})"
	sl_predicate: "SM(x, {age:a;exm:e;pfm:p}) = P$PERSON(x,{age:a}) * RestStoP$STUDENT(x,{exm:e}) * RestMtoP$MUSICIAN(x,{pfm:p})"
	sl_predicate: "RestStoP(x, {exm:e}) = RestStoP$STUDENT(x,{exm:e})"
	sl_predicate: "RestMtoP(x, {pfm:p}) = RestMtoP$MUSICIAN(x,{pfm:p})"
	sl_predicate: "RestSMtoS(x, {pfm:p}) = RestMtoP$MUSICIAN(x,{pfm:p})"
	sl_predicate: "RestSMtoM(x, {exm:e}) = RestStoP$STUDENT(x,{exm:e})"
	js_logic: "smusician.logic"
	js_abstraction: "smusician.abs"

class
	SMUSICIAN

inherit
	STUDENT
		redefine init end

	MUSICIAN
		redefine init end

feature

	init (a: INTEGER; e: INTEGER; p: INTEGER)
		require else
			--SL-- True
		do
			Precursor {STUDENT} (a, e, 34)
			Precursor {MUSICIAN} (a, p, 34)
		ensure then
			--SL-- SM$(Current,{age:a;exm:e;pfm:p})
		end

	do_exam_performance
		require
			--SLS-- SM(Current,{age:_a;exm:_e;pfm:_p})
		do
			take_exam
			perform
		ensure
			--SLS-- SM(Current,{age:_a;exm:builtin_plus(_e,1);pfm:builtin_plus(_p,1)})
		end

end
