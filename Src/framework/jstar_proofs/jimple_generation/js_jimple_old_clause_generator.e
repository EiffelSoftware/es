indexing
	description: "Summary description for {JS_JIMPLE_OLD_CLAUSE_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_JIMPLE_OLD_CLAUSE_GENERATOR

inherit
	JS_VISITOR
	redefine process_un_old_b end

create
	make

feature

	make (eg: JS_JIMPLE_EXPRESSION_GENERATOR)
		do
			expression_generator := eg
			create old_expression_side_effects.make
		end

	expression_generator: JS_JIMPLE_EXPRESSION_GENERATOR

	old_expression_side_effects: LINKED_LIST [!JS_OUTPUT_BUFFER]

	old_expression_number: INTEGER

	process_un_old_b (a_node: UN_OLD_B)
		local
			l_side_effect: !JS_OUTPUT_BUFFER
		do
			a_node.expr.process (expression_generator)

			l_side_effect := expression_generator.side_effect
			old_expression_number := old_expression_number + 1
			l_side_effect.put_line ("$old" + old_expression_number.out + " = " + expression_generator.expression_string + ";")
			old_expression_side_effects.extend (l_side_effect)

			-- Add $old_whatever and its type as a local
			expression_generator.temporaries.extend (["$old" + old_expression_number.out, type_of_old_expression (expression_generator.expression_string, expression_generator.temporaries)])

			expression_generator.reset_expression_and_target_and_new_side_effect
		end

feature

	type_of_old_expression (a_result_var: STRING; a_temporaries: LIST [TUPLE [name: STRING; type: STRING]]): STRING
		local
			found: BOOLEAN
			temp: TUPLE [name: STRING; type: STRING]
		do
			from
				a_temporaries.start
			until
				a_temporaries.off or found
			loop
				temp := a_temporaries.item
				if temp.name.is_equal (a_result_var) then
					Result := temp.type
					found := True
				end
				a_temporaries.forth
			end
		end

end
