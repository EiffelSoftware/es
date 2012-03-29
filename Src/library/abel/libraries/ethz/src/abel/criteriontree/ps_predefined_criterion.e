note
	description: "A criterion to filter objects according to some predefined operations on attributes."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_PREDEFINED_CRITERION

inherit
	PS_CRITERION
	PS_PREDEFINED_OPERATORS

inherit {NONE}
	REFACTORING_HELPER

create make

feature -- Check

	is_satisfied_by (object: ANY): BOOLEAN
			-- Does `object' satisfy the criteria in Current?
		local
			attribute_is_present: BOOLEAN
			index: INTEGER
			loop_var: INTEGER
			intern: INTERNAL
			field_value: detachable ANY
		do
				-- find out the value of the attribute using reflection
			create intern
			from
				loop_var := intern.field_count (object)
				attribute_is_present := false
			until
				loop_var < 1 or attribute_is_present
			loop
				if attribute_name.is_case_insensitive_equal (intern.field_name (loop_var, object)) then
					attribute_is_present := true
					index := loop_var
					--print ("attribute name: "+field_name(loop_var,object) + " index: " + index.out + " value: " + (field (index, object)).out)
				end
				loop_var := loop_var - 1
			variant
				loop_var
			end
			field_value := intern.field (index, object)
				-- apparently automatic conversion doesn't work in agents, so we have to do it manually
			if attached {INTEGER_32} field_value as int then
				Result := my_agent.item ([int.to_integer_64])
			elseif attached {INTEGER_16} field_value as int then
				Result := my_agent.item ([int.to_integer_64])
			elseif attached {INTEGER_8} field_value as int then
				Result := my_agent.item ([int.to_integer_64])
				-- Reals
			elseif attached {REAL_32} field_value as real then
				Result := my_agent.item ([real.to_double])
				-- Naturals
			elseif attached {NATURAL_32} field_value as nat then
				Result := my_agent.item ([nat.to_natural_64])
			elseif attached {NATURAL_16} field_value as nat then
				Result := my_agent.item ([nat.to_natural_64])
			elseif attached {NATURAL_8} field_value as nat then
				Result := my_agent.item ([nat.to_natural_64])
			elseif attached {ANY} field_value as field_val then
					-- for the rest we don't need conversions
				Result := my_agent.item ([field_val])
			else
				Result := false
				fixme ("TODO: exception because of void reference")
			end
		end



	can_handle_object (an_object: ANY): BOOLEAN
			-- Can `Current' handle `an_object' in the is_satisfied_by check?
		local
			attribute_is_present: BOOLEAN
			index: INTEGER
			loop_var: INTEGER
			intern: INTERNAL
			field_value: detachable ANY
		do
			-- See if the attribute is actually present in the object and get its value
			create intern
			from
				loop_var := intern.field_count (an_object)
				attribute_is_present := false
			until
				loop_var < 1 or attribute_is_present
			loop
				if attribute_name.is_case_insensitive_equal (intern.field_name (loop_var, an_object)) then
					attribute_is_present := true
					field_value := intern.field (index, an_object)
				end
				loop_var := loop_var - 1
			variant
				loop_var
			end

			-- now see if both types match
			if attribute_is_present and attached field_value as field_val then
				-- One of the combinations has to apply
				Result := 	   (is_string_type(field_val) and is_string_type (value))
							or (is_boolean_type(field_val) and is_boolean_type (value))
							or (is_natural_type(field_val) and is_natural_type (value))
							or (is_integer_type(field_val) and is_integer_type (value))
							or (is_real_type(field_val) and is_real_type (value))

				fixme ("TODO: Fix an error in here: When creating objects with INTERNAL.new_instance, even expanded types like integers seem to be initialized as Void. This means we somehow have to check differently...")
			else
				Result:=False
			end

			fixme ("don't forget to delete this line when error above is fixed")	Result:= attribute_is_present

		end

feature -- Miscellaneous

	has_agent_criterion:BOOLEAN = False
			-- Is there an agent criterion in the criterion tree?

	accept (a_visitor: PS_CRITERION_VISITOR[ANY]) :ANY
			-- Call visit_predefined on `a_visitor'
		do
			Result:=a_visitor.visit_predefined (Current)
		end

feature --Access

	attribute_name: STRING
			-- The attribute on which the criteria shall operate on.

	operator: STRING
			-- The operator. Must be an operation defined in PS_PREDEFINED_OPERATORS

	value: ANY
			-- The value to check for

	my_agent: PREDICATE [ANY, TUPLE [ANY]]
			-- The agent is used if the predefined queries cannot be executed by the database backend

feature -- Predefined Operators

	string8_op (s1, s2: READABLE_STRING_8): BOOLEAN
		do
			if operator.is_case_insensitive_equal (equals) then
				Result := s2.is_case_insensitive_equal (s1)
			else
				check operator.is_case_insensitive_equal (like_string) then
					fixme ("TODO: pattern matching")
					Result := false
				end
			-- Other operators are not possible due to the invariant
			end
		end

	string32_op (s1, s2: READABLE_STRING_32): BOOLEAN
		do
			fixme ("TODO")
			Result := true
		end

	real_op (r1, r2: REAL_64): BOOLEAN
		do
			fixme ("TODO")
			Result := true
		end

	integer_op (i1, i2: INTEGER_64): BOOLEAN
		do
			if operator.is_case_insensitive_equal (equals) then
				Result := i1 = i2
			elseif operator.is_case_insensitive_equal (less_equal) then
				Result := i1 <= i2
			elseif operator.is_case_insensitive_equal (less) then
				Result := i1 < i2
			elseif operator.is_case_insensitive_equal (greater_equal) then
				Result := i1 >= i2
			else
				check operator.is_case_insensitive_equal (greater) then
					Result := i1 > i2
				end
				-- Other operators are not possible due to the invariant
			end
		end

	natural_op (n1, n2: NATURAL_64): BOOLEAN
		do
			fixme ("TODO")
			Result := true
		end

	boolean_op (b1, b2: BOOLEAN): BOOLEAN
		do
			fixme ("TODO")
			Result := true
		end

feature {NONE} -- Creation

	make (attr, op: STRING; val: ANY)
		require
			correct_operator_and_value: is_valid_combination (op, val)
		do
			attribute_name := attr
			operator := op
			value := val
		-- Initialize the agent. This is kind of ugly, but I think there's no other way if we want to support all the basic types
		-- Strings
			if attached {READABLE_STRING_8} value as str then
				my_agent := agent string8_op(?, str);
			elseif attached {READABLE_STRING_32} value as str then
				my_agent := agent string32_op(?, str);
		-- Booleans
			elseif attached {BOOLEAN} value as bool then
				my_agent := agent boolean_op(?, bool);
		-- Integers
			elseif attached {INTEGER_64} value as int then
				my_agent := agent integer_op(?, int)
			elseif attached {INTEGER_32} value as int then
				my_agent := agent integer_op(?, int)
			elseif attached {INTEGER_16} value as int then
				my_agent := agent integer_op(?, int)
			elseif attached {INTEGER_8} value as int then
				my_agent := agent integer_op(?, int)
		-- Reals
			elseif attached {REAL_64} value as real then
				my_agent := agent real_op(?, real)
			elseif attached {REAL_32} value as real then
				my_agent := agent real_op(?, real)
		-- Naturals
			elseif attached {NATURAL_64} value as nat then
				my_agent := agent natural_op(?, nat)
			elseif attached {NATURAL_32} value as nat then
				my_agent := agent natural_op(?, nat)
			elseif attached {NATURAL_16} value as nat then
				my_agent := agent natural_op(?, nat)
			else
				check attached {NATURAL_8} value as nat then
					my_agent := agent natural_op(?, nat)
				end
				-- There should not be any other type according to the precondition
			end
		end


invariant
	operator_and_value_match: is_valid_combination (operator, value)

end
