note
	description: "Summary description for {AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR

inherit
	AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I

create
    default_create

feature -- statur report

	last_outline: AFX_QUERY_STATE_OUTLINE
			-- <Precursor>

	id: INTEGER = 1
			-- <Precursor>

feature{NONE} -- implementation

	extract_integer_outline (an_integer_expression: AFX_AST_EXPRESSION): DS_HASH_SET [AFX_PREDICATE_EXPRESSION]
			-- <Precursor>
		local
		    l_agents: DS_ARRAYED_LIST [PREDICATE[AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I, TUPLE[INTEGER]]]
		    l_exp: AFX_PREDICATE_EXPRESSION
		do
		    create Result.make (3)

	        create l_exp.make_with_ast_expression (an_integer_expression, agent is_integer_negative, " < 0")
	        Result.put (l_exp)
	        create l_exp.make_with_ast_expression (an_integer_expression, agent is_integer_zero, " = 0")
	        Result.put (l_exp)
	        create l_exp.make_with_ast_expression (an_integer_expression, agent is_integer_positive, " > 0")
	        Result.put (l_exp)
		end

	is_integer_negative (an_int: INTEGER): BOOLEAN
			-- is integer negative
		do
		    Result := an_int < 0
		end

	is_integer_zero (an_int: INTEGER): BOOLEAN
			-- is integer zero
		do
		    Result := an_int = 0
		end

	is_integer_positive (an_int: INTEGER): BOOLEAN
			-- is integer positive
		do
		    Result := an_int > 0
		end

--	extract_string_outline (an_string_expression: AFX_AST_EXPRESSION): DS_HASH_SET [AFX_PREDICATE_EXPRESSION]
--			-- <Precursor>
--		local
--		    l_exp: AFX_PREDICATE_EXPRESSION
--		do
--		    create Result.make (1)
--	        create l_exp.make_with_ast_expression (an_integer_expression, agent {STRING}.is_empty)
--	        Result.put (l_exp)
--		end





end
