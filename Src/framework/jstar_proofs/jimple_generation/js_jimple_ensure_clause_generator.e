indexing
	description: "Summary description for {JS_JIMPLE_ENSURE_CLAUSE_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_JIMPLE_ENSURE_CLAUSE_GENERATOR

inherit
	JS_JIMPLE_EXPRESSION_GENERATOR
	redefine process_un_old_b end

create
	make

feature

	old_expression_number: INTEGER

	process_un_old_b (a_node: UN_OLD_B)
		do
			old_expression_number := old_expression_number + 1
			expression := "$old" + old_expression_number.out
			target := expression
		end

end
