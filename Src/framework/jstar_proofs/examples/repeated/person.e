note
	description: "Persons."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "P(x, {age:a}) = x.<PERSON.my_age> |-> a"
	sl_exports: "[
		P_PERSON_def: P$PERSON(x, {age:a}) <==> x.<PERSON.my_age> |-> a
	where
	]"
	js_logic: "person.logic"
	js_abstraction: "person.abs"

class
	PERSON

create
	init

feature

	init (a: INTEGER; dummy1: INTEGER; dummy2: INTEGER)
		require
			--SL-- True
		do
			my_age := a
		ensure
			--SL-- P$(Current, {age:a})
		end

	age: INTEGER
		require
			--SL-- P$(Current, {age:_a})
		do
			Result := my_age
		ensure
			--SL-- P$(Current, {age:_a}) * Result = _a
		end

	set_age (a: INTEGER)
        	require
        		--SL-- P$(Current, {age:_a})
        	do
            		my_age := a
        	ensure
        		--SL-- P$(Current, {age:a})
        	end

	celebrate_birthday
		require
			--SLS-- P(Current,{age:_a})
		do
			set_age (age + 1)
		ensure
			--SLS-- P(Current,{age:builtin_plus(_a,1)})
		end

	my_age: INTEGER

end
