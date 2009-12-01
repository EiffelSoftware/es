note
	description: "Summary description for {AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I

inherit
    AFX_SHARED_QUERY_STATE_OUTLINE_MANAGER

    HASHABLE

feature -- status report

	id: INTEGER
			-- id of this extractor
		deferred
		end

	hash_code: INTEGER
			-- <Precursor>
		do
		    Result := id
		end

feature -- operation

	extract_boolean_class_outline (a_class: CLASS_C): AFX_BOOLEAN_STATE_OUTLINE
			-- extract the outline for a class
		require
		    a_class_registered: State_outline_manager.is_registered (a_class.class_id)
		local
			l_outline: AFX_QUERY_STATE_OUTLINE
			l_manager: like State_outline_manager
			l_id: INTEGER
			l_exp: AFX_EXPRESSION
			l_pre_exp: DS_HASH_SET [AFX_PREDICATE_EXPRESSION]
		do
		    l_id := a_class.class_id
		    l_manager := State_outline_manager
		    check l_manager /= Void end
		    l_outline := l_manager.item (l_id)
		    check l_outline /= Void end

		    create Result.make_for_class (a_class, Current)
		    from l_outline.start
		    until l_outline.after
		    loop
		        l_exp := l_outline.item_for_iteration

		        	-- construct predicates for expressions
		        if attached {AFX_AST_EXPRESSION} l_exp as ll_exp then
    		        if ll_exp.is_predicate then
    		            l_pre_exp := extract_boolean_outline (ll_exp)
    		        elseif ll_exp.type /= Void and then ll_exp.type.is_integer then
    	            	l_pre_exp := extract_integer_outline (ll_exp)
    		        end
    		    else
    		        check False end
		        end

		        	-- add predicates to boolean class outline
            	l_pre_exp.do_all (agent(an_exp: AFX_PREDICATE_EXPRESSION; an_outline: AFX_BOOLEAN_STATE_OUTLINE)
            			do an_outline.force (an_exp) end (?, Result))

		        l_outline.forth
		    end
		end

	extract_integer_outline (an_integer_expression: AFX_AST_EXPRESSION): DS_HASH_SET [AFX_PREDICATE_EXPRESSION]
			-- convert an `INTEGER' expression into predicate expression
		require
		    integer_expression: an_integer_expression.type.is_integer
		deferred
		end

feature{NONE} -- implementation

	extract_boolean_outline (an_boolean_expression: AFX_AST_EXPRESSION): DS_HASH_SET [AFX_PREDICATE_EXPRESSION]
			-- <Precursor>
		local
		    l_agents: DS_ARRAYED_LIST [PREDICATE[AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I, TUPLE[INTEGER]]]
		    l_exp: AFX_PREDICATE_EXPRESSION
		do
		    create Result.make (1)
	        create l_exp.make_with_ast_expression (an_boolean_expression, agent is_boolean_true, " = True")
	        Result.put (l_exp)
		end

	is_boolean_true (a_bool: BOOLEAN): BOOLEAN
			-- is boolean true
		do
		    Result := a_bool
		end

--	last_outline: AFX_STATE_OUTLINE
--			-- last extracted outline
--		deferred
--		end

--	extract_string_outline (an_string_expression: AFX_AST_EXPRESSION): DS_HASH_SET [AFX_PREDICATE_EXPRESSION]
--			-- convert a `STRING' expression into predicate expression
--		require
--		    string_expression: attached {STRING} an_string_expression.type
--		deferred
--		ensure
--		    all_expressions_boolean: Result.for_all (agent (an_exp: AFX_EXPRESSION): BOOLEAN do Result := an_exp.is_predicate end)
--		end

end
