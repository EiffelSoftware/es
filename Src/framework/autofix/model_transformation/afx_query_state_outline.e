note
	description: "Summary description for {AFX_QUERY_STATE_OUTLINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_QUERY_STATE_OUTLINE

inherit
    DS_HASH_SET [AFX_EXPRESSION]

    HASHABLE
    	undefine
    	    is_equal,
    	    copy
    	end

create
    make_for_state

feature{AFX_STATE_OUTLINE_MANAGER} -- initialization

--	make_for_class (n: INTEGER; a_class: like class_)
--			-- initialize
--		do
--		    make (n)
--		    class_ := a_class
--		end

	make_for_state (a_state: AFX_STATE)
			-- initialize
		require
		    not_chaos: not a_state.is_chaos
		do
		    class_ := a_state.class_
		    make (a_state.count)
		    set_equality_tester (create {AFX_EXPRESSION_EQUALITY_TESTER})

		    from a_state.start
		    until a_state.after
		    loop
		        force (a_state.item_for_iteration.expression)
		        a_state.forth
		    end
		ensure
		    class_set: class_ = a_state.class_
		    same_size: count = a_state.count
		end

feature -- status report

--	type: TYPE_A
--			-- the type of objects to which this outline is going to be applied

	class_: CLASS_C
			-- the class to the objects of which the outline will be applied

	hash_code: INTEGER
			-- <Precursor>
		do
		    Result := class_.class_id
		end

	is_for_class (a_class: CLASS_C): BOOLEAN
			-- is current outline for `a_class'?
		do
		    Result := class_.class_id = a_class.class_id
		ensure
		    definition: Result = (class_.class_id = a_class.class_id)
		end

feature -- operation

--	accommodate_predicates (a_list: DS_LINEAR [AFX_EXPRESSION])
--		require
--			all_expressions_boolean: a_list.for_all (agent (an_expression: AFX_EXPRESSION): BOOLEAN do Result := an_expression.is_predicate end)
--		do
--			a_list.do_all (agent (an_expression: AFX_EXPRESSION)
--									do if not has (an_expression) then put (an_expression) end end )
--		end


	accommodate (a_state: AFX_STATE)
			-- adjust the outline to accommodate `a_state'
		require
		    is_for_same_class: is_for_class (a_state.class_)
		    not_chaos: not a_state.is_chaos
		local
		    l_exp: AFX_EXPRESSION
		do
		    from a_state.start
		    until a_state.after
		    loop
		        l_exp := a_state.item_for_iteration.expression

		        if not has (l_exp) then
		            force (l_exp)
		        end
		        a_state.forth
		    end
		end



end
