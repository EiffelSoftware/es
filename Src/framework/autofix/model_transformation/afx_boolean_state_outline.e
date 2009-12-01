note
	description: "Summary description for {AFX_BOOLEAN_STATE_OUTLINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE_OUTLINE

inherit
    DS_HASH_SET [AFX_PREDICATE_EXPRESSION]
    	redefine default_capacity end

    HASHABLE
    	undefine
    	    is_equal,
    	    copy
    	end

create
    make_for_class

feature -- initialize

	make_for_class (a_class: like class_; an_extractor: like extractor)
			-- create a boolean state outline for a class
		do
			make_default
		    class_ := a_class
			extractor := an_extractor

			create last_predicate_indexes.make_default
		end

feature -- access

	class_: CLASS_C
			-- related class

	extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
			-- extractor

feature -- status report

	hash_code: INTEGER
			-- <Precursor>
		do
		    Result := class_.class_id
		end

	default_capacity: INTEGER is
			-- <Precursor>
		do
			Result := 25
		end

feature -- boolean outline queries

	get_predicate_indexes (a_exp_set: DS_HASH_SET[AFX_AST_EXPRESSION]): BOOLEAN
			-- query the indexes of expressions in the boolean representation
			-- NOTE: only boolean queries supported now
		require
		    all_expression_predicates: a_exp_set.for_all (agent {AFX_AST_EXPRESSION}.is_predicate)
		local
		    l_ok: BOOLEAN
		    l_exp: AFX_AST_EXPRESSION
		    l_index, l_count: INTEGER
		    l_set: like last_predicate_indexes
		do
		    l_set := last_predicate_indexes
		    l_set.wipe_out

		    l_count := count
		    Result := True
		    from
		        l_index := 0
		        start
		    until
		        after or not Result
		    loop
		        l_exp := item_for_iteration.expression
		        if a_exp_set.has (l_exp) then
		            l_set.force (l_index)
		        else
		        		-- Abort: expression not in the boolean outline
		            Result := False
		        end
		        l_index := l_index + 1
		        forth
		    end
		end

	get_predicate_expression (an_array: DS_LINEAR[INTEGER]): DS_LINEAR[AFX_PREDICATE_EXPRESSION]
			-- get the list of predicate expressions at certain outline position
		require
		    an_array_in_ascendant_order: --
--		    every_integer_in_the_list_is_within_range_of_count_of_boolean_outline: --
		local
			l_index, l_bit_index, l_count, l_count_finished: INTEGER
			l_array: DS_ARRAYED_LIST[AFX_PREDICATE_EXPRESSION]
			l_exp: AFX_PREDICATE_EXPRESSION
		do
		    create l_array.make (an_array.count)
		    from
		    		-- start boolean state outline
		    	start
		    	l_bit_index := 0

		    		-- start the array of expression indexes
		    	an_array.start
		    until
		        an_array.after
		    loop
		        	-- find the predicate expression for current array item
		        from
		        	l_index := an_array.item_for_iteration
		        	check l_index < count end
		        until after or l_bit_index = l_index
		        loop
		            forth
		            l_bit_index := l_bit_index + 1
		        end

		        if l_bit_index = l_index then
		            l_array.force_last (item_for_iteration)
		        else
		            check False end
		        end

		        an_array.forth
		    end
		end

feature -- boolean outline queries implementation

	last_predicate_indexes: DS_HASH_SET[INTEGER]
			-- storage for `get_predicate_indexes'

end
