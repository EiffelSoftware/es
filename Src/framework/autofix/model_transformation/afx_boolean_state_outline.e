note
	description: "Summary description for {AFX_BOOLEAN_STATE_OUTLINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE_OUTLINE

inherit
    DS_HASH_SET [AFX_PREDICATE_EXPRESSION]
    	redefine
    		default_capacity
    	end

    HASHABLE
    	undefine
    	    is_equal,
    	    copy
    	end

create
    make_for_class

feature -- Initialize

	make_for_class (a_class: like class_; an_extractor: like extractor)
			-- Initialize.
		do
			make_default
		    class_ := a_class
			extractor := an_extractor
		end

feature -- Access

	class_: CLASS_C
			-- Class of the outline.

	extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
			-- Extractor.

feature -- Status report

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

feature -- Query

	predicate_at_position (a_index: INTEGER): AFX_PREDICATE_EXPRESSION
			-- The `a_index'-th predicate expression.
		require
		    index_in_range: 0 <= a_index and a_index < count
		local
		    l_index: INTEGER
		do
		    from
		    	l_index := 0
		    	start
		    until after or Result /= Void
		    loop
		        if l_index = a_index then
		            Result := item_for_iteration
		        end
		    	l_index := l_index + 1
		    	forth
		    end
		end

	index_from_string (a_string: STRING; a_is_xml: BOOLEAN): INTEGER
			-- Index in the outline according to its string representation.
			-- `a_is_xml' indicates whether `a_string' is an xml string.
			-- Result -1 implies no predicate was found.
		local
			l_index: INTEGER
			l_predicate: AFX_PREDICATE_EXPRESSION
		do
		    Result := -1

		    from
		        l_index := 0
		        start
		    until
		        after or Result /= -1
		    loop

		        if not a_is_xml and then a_string ~ item_for_iteration.to_string then
		            Result := l_index
		        elseif a_is_xml and then a_string ~ item_for_iteration.to_xml_string then
		            Result := l_index
		        end

		        l_index := l_index + 1
		        forth
		    end
		end

	query_predicate_indexes (a_exp_set: DS_HASH_SET[EPA_AST_EXPRESSION]): DS_HASH_SET[INTEGER]
			-- Query the indexes of expressions in the boolean representation.
			-- NOTE: only boolean queries supported now.
		require
		    all_expression_predicates: a_exp_set.for_all (agent {EPA_AST_EXPRESSION}.is_predicate)
		local
		    l_ok: BOOLEAN
		    l_exp: EPA_AST_EXPRESSION
		    l_index, l_count: INTEGER
		    l_set: DS_HASH_SET[INTEGER]
		do
		    create l_set.make_default

		    l_count := count
		    l_ok := True
		    from
		        l_index := 0
		        start
		    until
		        after or not l_ok
		    loop
		        l_exp := item_for_iteration.expression
		        if a_exp_set.has (l_exp) then
		            l_set.force (l_index)
		        else
		        		-- Abort: expression not in the boolean outline
		            l_ok := False
		        end
		        l_index := l_index + 1
		        forth
		    end

		    if not l_ok then
		        l_set.wipe_out
		    end
		    Result := l_set
		end

end
