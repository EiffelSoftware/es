note
	description: "Summary description for {STUDENT}."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "P(x, {age:a}) = P$PERSON(x,{age:a})"
	sl_predicate: "S(x, {age:a;exm:e}) = P$STUDENT(x,{age:a}) * x.<STUDENT.my_exams> |-> e"
	sl_predicate: "RestStoP(x, {exm:e}) = x.<STUDENT.my_exams> |-> e"
	js_logic: "student.logic"
	js_abstraction: "student.abs"

class
	STUDENT

inherit
	PERSON
		redefine init end

create
	init

feature

	init (a: INTEGER; e: INTEGER; dummy: INTEGER)
		require else
			--SL-- True
		do
			Precursor {PERSON} (a, 1, 2)
			my_exams := e
		ensure then
			--SL-- S$(Current,{age:a;exm:e})
		end

	exams: INTEGER
		require
			--SL-- S$(Current,{age:_a;exm:_e})
		do
			Result := my_exams
		ensure
			--SL-- S$(Current,{age:_a;exm:_e}) * Result = _e
		end

	take_exam
		require
			--SL-- S$(Current,{age:_a;exm:_e})
		do
			my_exams := my_exams + 1
		ensure
			--SL-- S$(Current,{age:_a;exm:builtin_plus(_e,1)})
		end

	my_exams: INTEGER

end
