note
	description: "Summary description for {PLAN_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAN_STATE

create
	make

feature
	make
		do
			create predicates.make (10)
			create functions.make (10)
		end

	add_function_simple (name: STRING; val: ANY)
		do
			add_function (create {CONST_EXPR}.make_const (name)
			             ,create {CONST_EXPR}.make_const (val.out)
			             )
		end

	add_predicate_simple (name: STRING; bool: BOOLEAN)
		do
			if bool then
				add_predicate (create {CONST_EXPR}.make_const (name))
			end
		end

	add_predicate (pred: EXPR)
		do
			predicates.extend (pred)
		end

	add_function (func: EXPR; val: EXPR)
		do
			functions.extend (create {BIN_EXPR}.make_bin ("=", func, val))
		end

	predicates: ARRAYED_LIST [EXPR]
	functions: ARRAYED_LIST [EXPR]

end
