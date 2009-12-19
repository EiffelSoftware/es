note
	description:
			"[
				All extractors should be registered in shared `AFX_BOOLEAN_STATE_OUTLINE_MANAGER' object.
			]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I

inherit
    AFX_SHARED_QUERY_STATE_OUTLINE_MANAGER

    HASHABLE

feature -- Status report

	id: INTEGER
			-- Id of this extractor.
		deferred
		end

	hash_code: INTEGER
			-- <Precursor>
		do
		    Result := id
		end

feature -- Operation

	extract_boolean_class_outline (a_class: CLASS_C): detachable AFX_BOOLEAN_STATE_OUTLINE
			-- Extract the boolean outline for `a_class'.
		local
			l_outline: AFX_QUERY_STATE_OUTLINE
			l_manager: like State_outline_manager
			l_class_id: INTEGER
			l_exp: AFX_EXPRESSION
			l_pre_exp: DS_HASH_SET [AFX_PREDICATE_EXPRESSION]
		do
		    l_manager := State_outline_manager
		    if l_manager /= Void then
    		    l_class_id := a_class.class_id
    		    l_outline := l_manager.value (l_class_id)
    		    if l_outline /= Void then
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
        		else
        		    -- no boolean class outline available
    		    end
		    end
		end

	predicator_from_string (a_predicator_string: STRING): detachable PREDICATE[ANY, TUPLE[ANY]]
			-- Predicator from `a_predicator_string'.
		do
		    Result := predicator_from_string_in_array (a_predicator_string, boolean_predicator_and_string)
		end

feature{NONE} -- Implementation

	extract_integer_outline (a_integer_expression: AFX_AST_EXPRESSION): DS_HASH_SET [AFX_PREDICATE_EXPRESSION]
			-- Extract outline from `a_integer_expression'.
		require
		    integer_expression: a_integer_expression.type.is_integer
		deferred
		end

	extract_boolean_outline (a_boolean_expression: AFX_AST_EXPRESSION): DS_HASH_SET [AFX_PREDICATE_EXPRESSION]
			-- Extract outline from `a_boolean_expression'.
		local
		    l_agents: DS_ARRAYED_LIST [PREDICATE[AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I, TUPLE[INTEGER]]]
		    l_exp: AFX_PREDICATE_EXPRESSION
		do
		    create Result.make (1)
	        create l_exp.make_with_ast_expression (a_boolean_expression, agent is_boolean_true, "")
	        Result.put (l_exp)
		end

	predicator_from_string_in_array (a_predicator_string: STRING; a_array: ARRAY[ TUPLE[predicator_string: STRING; predicator: PREDICATE[ANY, TUPLE[ANY]]]])
					: PREDICATE[ANY, TUPLE[ANY]]
			-- Predicator from string in `a_array'.
		local
		    l_index: INTEGER
		do
		    from l_index := a_array.lower
		    until l_index > a_array.upper or Result /= Void
		    loop
		        if a_predicator_string ~ a_array.at (l_index).predicator_string then
		            Result := a_array.at (l_index).predicator
		        end

		        l_index := l_index + 1
		    end
		end

feature{AFX_PREDICATE_EXPRESSION} -- Predicator feature

	boolean_predicator_and_string: ARRAY[ TUPLE[predicator_string: STRING; predicator: PREDICATE[ANY, TUPLE[ANY]]]]
			-- Boolean predicator and string array.
		once
		    Result := << ["", agent is_boolean_true] >>
		end

	is_boolean_true (a_bool: BOOLEAN): BOOLEAN
			-- Is `a_bool' true?
		do
		    Result := a_bool
		end

end
