note
	description: "Summary description for {AFX_QUERY_STATE_OUTLINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_QUERY_STATE_OUTLINE

inherit
    DS_HASH_SET [EPA_EXPRESSION]

    HASHABLE
    	undefine
    	    is_equal,
    	    copy
    	end

create
    make_for_state

feature{NONE} -- Initialization

	make_for_state (a_state: AFX_STATE)
			-- Initialize.
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

feature -- Status report

	class_: CLASS_C
			-- Class which the outline is for.

	hash_code: INTEGER
			-- <Precursor>
		do
		    Result := class_.class_id
		end

	is_for_class (a_class: CLASS_C): BOOLEAN
			-- Is current outline for `a_class'?
		do
		    Result := class_.class_id = a_class.class_id
		ensure
		    definition: Result = (class_.class_id = a_class.class_id)
		end

feature -- Operation

	accommodate (a_state: AFX_STATE)
			-- Accommodate `a_state' into outline.
		require
		    is_for_same_class: is_for_class (a_state.class_)
		    not_chaos: not a_state.is_chaos
		local
		    l_exp: EPA_EXPRESSION
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
