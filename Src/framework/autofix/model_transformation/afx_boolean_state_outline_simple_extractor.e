note
	description: "Summary description for {AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR

inherit
	AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
		redefine
		    predicator_from_string
		end

create
    default_create

feature -- Statur report

	id: INTEGER = 1
			-- <Precursor>

feature -- Operation

	predicator_from_string (a_predicator_string: STRING): detachable PREDICATE[ANY, TUPLE[ANY]]
			-- <Precursor>
		local
		    l_predicate: PREDICATE[ANY, TUPLE[ANY]]
		do
		    Result := Precursor (a_predicator_string)
		    if Result = Void then
		        Result := predicator_from_string_in_array (a_predicator_string, integer_predicator_and_string)
		    end
		end

feature{NONE} -- Implementation

	extract_integer_outline (a_integer_expression: AFX_AST_EXPRESSION): DS_HASH_SET [AFX_PREDICATE_EXPRESSION]
			-- <Precursor>
		local
		    l_agents: DS_ARRAYED_LIST [PREDICATE[AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I, TUPLE[INTEGER]]]
		    l_exp: AFX_PREDICATE_EXPRESSION
		    l_index: INTEGER
		do
		    create Result.make (3)

		    from l_index := integer_predicator_and_string.lower
		    until l_index > integer_predicator_and_string.upper
		    loop
		        Result.force (
		        		create {AFX_PREDICATE_EXPRESSION}.make_with_ast_expression (
		        				a_integer_expression,
		        				(integer_predicator_and_string @ l_index).predicator,
					        	(integer_predicator_and_string @ l_index).predicator_string))

		        l_index := l_index + 1
		    end
		end



--	        create l_exp.make_with_ast_expression (a_integer_expression, agent is_integer_negative, " < 0")
--	        Result.put (l_exp)
--	        create l_exp.make_with_ast_expression (a_integer_expression, agent is_integer_zero, " = 0")
--	        Result.put (l_exp)
--	        create l_exp.make_with_ast_expression (a_integer_expression, agent is_integer_positive, " > 0")
--	        Result.put (l_exp)

feature{AFX_PREDICATE_EXPRESSION} -- Predicator feature

	integer_predicator_and_string: ARRAY[ TUPLE[predicator_string: STRING; predicator: PREDICATE[ANY, TUPLE[ANY]]]]
			-- Integer predicator and string array.
		once
			Result := <<[" < 0", agent is_integer_negative],
						[" = 0", agent is_integer_zero],
						[" > 0", agent is_integer_positive] >>
		end

	is_integer_negative (a_int: INTEGER): BOOLEAN
			-- Is `a_int' negative?
		do
		    Result := a_int < 0
		end

	is_integer_zero (a_int: INTEGER): BOOLEAN
			-- Is `a_int' 0?
		do
		    Result := a_int = 0
		end

	is_integer_positive (a_int: INTEGER): BOOLEAN
			-- Is `a_int' positive?
		do
		    Result := a_int > 0
		end

end
