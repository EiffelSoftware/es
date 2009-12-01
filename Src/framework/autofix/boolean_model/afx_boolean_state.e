note
	description: "Summary description for {AFX_BOOLEAN_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE

inherit
    AFX_BIT_VECTOR

	AFX_HASH_CALCULATOR
    	undefine is_equal, copy	end

    AFX_EXPRESSION_VALUE_VISITOR
    	undefine is_equal, copy end

	AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_FACTORY
    	undefine is_equal, copy end

create
    make_for_class

feature -- initialize

	make_for_class (a_class: like class_)
			-- initialize
		local
		    l_extractor: AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR
		    l_outline: AFX_BOOLEAN_STATE_OUTLINE
		    l_size: INTEGER
		do
			l_extractor := get_simple_extractor
			l_outline := boolean_state_outline_manager.boolean_class_outline (a_class, l_extractor)
			check l_outline /= Void and then l_outline.class_.class_id = a_class.class_id end
			boolean_state_outline := l_outline

			l_size := boolean_state_outline.count
			create properties_true.make (l_size)
			create properties_false.make (l_size)
			create properties_random.make (l_size)
		end

feature -- access

	query_state: detachable AFX_STATE
			-- original query-based state

	boolean_state_outline: AFX_BOOLEAN_STATE_OUTLINE
			-- boolean outline related with this state

	properties_true: AFX_BIT_VECTOR assign set_properties_true
			-- properties evaluated 'True' on this state

	properties_false: AFX_BIT_VECTOR assign set_properties_false
			-- properties evaluated 'False' on this state

	properties_random: AFX_BIT_VECTOR assign set_properties_random
			-- properties with random value on this state
			-- possibly due to the missing of corresponding query value or propagation of inaccuracy

feature -- status report

	class_: CLASS_C
			-- target class of this boolean state
		do
		    Result := boolean_state_outline.class_
		end

	extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
			-- extractor used to extract this boolean state
		do
		    Result := boolean_state_outline.extractor
		end

	is_comparable_state (a_state: like Current): BOOLEAN
			-- is `Current' comparable with `a_state'?
		do
		    Result := Current.boolean_state_outline = a_state.boolean_state_outline
		end

	is_query_state_available: BOOLEAN
			-- is the original query state available?
		do
		    Result := query_state /= Void
		end

	is_chaos: BOOLEAN
			-- is this state standing for a 'chaos'?
		require
		    is_query_state_available: is_query_state_available
		do
		    if attached query_state as l_state then
		        Result := l_state.is_chaos
		    end
		end

	is_conforming_to (a_condition: like Current): BOOLEAN
			-- does `Current' satisfying the requirement of 'a_condition'?
		local
		do
		    	-- if the `properties_true' and `properties_false' of current states are
		    	-- super sets of those of `a_condition', return `True'
		    Result := a_condition.properties_true.is_subset_of (properties_true)
		    		and then a_condition.properties_false.is_subset_of (properties_false)
		end

	is_suitable_as_source (a_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY): BOOLEAN
			-- is current state suitable to be used as the source of `a_summary', i.e. satisfying the 'pre-*' requirements of `a_summary'
		require
		    same_class: class_.class_id = a_summary.class_.class_id
		local
			l_set, l_cleared: AFX_BIT_VECTOR
		do
		    Result := a_summary.pre_true.is_subset_of (properties_true)
		    		and then a_summary.pre_false.is_subset_of (properties_false)
		end

feature -- setters

	set_properties_true (a_vector: like properties_true)
			-- set `properties_true'
		do
		    properties_true := a_vector
		end

	set_properties_false (a_vector: like properties_false)
			-- set `properties_false'
		do
		    properties_false := a_vector
		end

	set_properties_random (a_vector: like properties_random)
			-- set `properties_random'
		do
		    properties_random := a_vector
		end

feature -- state transition

	properties_negated_true (a_dest: like Current): AFX_BIT_VECTOR
			-- properties negated to be `True', during transition from `Current' to `a_dest'
		require
		    is_comparable: is_comparable_state (a_dest)
		    non_chaotic: not is_chaos and not a_dest.is_chaos
		local
		    l_vector: AFX_BIT_VECTOR
		do
		    	-- properties from `False' to `True'
		    l_vector := properties_false.bit_and (a_dest.properties_true)
		    Result := l_vector
		end

	properties_negated_false (a_dest: like Current): AFX_BIT_VECTOR
			-- properties negated to be `False', during transition from `Current' to `a_dest'
		require
		    is_comparable: is_comparable_state (a_dest)
		    non_chaotic: not is_chaos and not a_dest.is_chaos
		local
		    l_vector: AFX_BIT_VECTOR
		do
		    	-- properties from `True' to `False'
		    l_vector := properties_true.bit_and (a_dest.properties_false)
		    Result := l_vector
		end

	properties_unchanged_false (a_dest: like Current): AFX_BIT_VECTOR
			-- properties remained `False', during transition from `Current' to `a_dest'
		require
		    is_comparable: is_comparable_state (a_dest)
		    non_chaotic: not is_chaos and not a_dest.is_chaos
		local
		    l_vector: AFX_BIT_VECTOR
		do
		    	-- properties remained `False'
		    l_vector := properties_false.bit_and (a_dest.properties_false)
		    Result := l_vector
		end

	properties_unchanged_true (a_dest: like Current): AFX_BIT_VECTOR
			-- properties remained `True', during transition from `Current' to `a_dest'
		require
		    is_comparable: is_comparable_state (a_dest)
		    non_chaotic: not is_chaos and not a_dest.is_chaos
		local
		    l_vector: AFX_BIT_VECTOR
		do
		    	-- properties remained `True'
		    l_vector := properties_true.bit_and (a_dest.properties_true)
		    Result := l_vector
		end

feature -- construction

	interpretate (a_state: AFX_STATE)
			-- put `a_state' into boolean encoding
		require
		    same_class: class_.class_id = a_state.class_.class_id
		local
		    l_outline: like boolean_state_outline
		    l_predicate: AFX_PREDICATE_EXPRESSION
		    l_exp: AFX_EXPRESSION
		    l_val: AFX_EXPRESSION_VALUE
		    l_table: DS_HASH_TABLE[AFX_EXPRESSION_VALUE, AFX_EXPRESSION]
		    l_index: INTEGER
		do
		    query_state := a_state

		    if not is_chaos then

    		    	-- put each pair of value and expression from `a_state' into hashtable
    		    create l_table.make (a_state.count)
    		    l_table.set_key_equality_tester (create {AFX_EXPRESSION_EQUALITY_TESTER})
    		    l_table.set_equality_tester (create {AFX_EXPRESSION_VALUE_EQUALITY_TESTER})
    		    a_state.do_all (agent (an_equation: AFX_EQUATION; a_table: DS_HASH_TABLE[AFX_EXPRESSION_VALUE, AFX_EXPRESSION])
    		    		do
    		    			a_table.force (an_equation.value, an_equation.expression)
    		    		end (?, l_table))

    				-- interpretate object state according to each boolean outline predicate
    		    l_outline := boolean_state_outline
    		    from
    		    	l_index := 0
    		    	l_outline.start
    		    until
    		    	l_outline.after
    		    loop
    		        l_predicate := l_outline.item_for_iteration
    		        l_exp := l_predicate.expression

        		    if attached l_table.item (l_exp) as l_value then
    		        		-- prepare for visiting
        		        last_property := l_predicate
        		        last_property_index := l_index

        		        	-- start visitor processing to evaluate the values of properties
        		        l_value.process (Current)

        		        last_property := Void
        		    else
        		        	-- value is missing in current query state, mark it as ''random''
        		        properties_random.set_bit (l_index)
        		    end

    				l_index := l_index + 1
    		        l_outline.forth
    		    end
		    end
		ensure
		    is_ready: is_query_state_available
		end


feature{NONE} -- visitor features

	last_property: detachable AFX_PREDICATE_EXPRESSION
			-- last unprocessed predicate

	last_property_index: INTEGER
			-- index of last unprocessed predicate in the boolean outline

	process_boolean_value (a_value: AFX_BOOLEAN_VALUE)
			-- Process `a_value'.
		local
			l_property: like last_property
			l_bool: BOOLEAN
		do
		    check last_property /= Void and then last_property.expression.is_predicate end

			l_property := last_property
			l_bool := l_property.predicator.item([a_value.item])
			if l_bool then
			    properties_true.set_bit (last_property_index)
			else
			    properties_false.set_bit (last_property_index)
			end
		end

	process_random_boolean_value (a_value: AFX_RANDOM_BOOLEAN_VALUE)
			-- Process `a_value'.
		do
		    check last_property /= Void and then last_property.expression.is_predicate end

			properties_random.set_bit (last_property_index)
		end

	process_integer_value (a_value: AFX_INTEGER_VALUE)
			-- Process `a_value'.
		local
			l_property: like last_property
			l_bool: BOOLEAN
		do
		    check last_property /= Void and then last_property.expression.is_predicate end

			l_property := last_property
			l_bool := l_property.predicator.item([a_value.item])
			if l_bool then
			    properties_true.set_bit (last_property_index)
			else
			    properties_false.set_bit (last_property_index)
			end
		end

	process_random_integer_value (a_value: AFX_RANDOM_INTEGER_VALUE)
			-- Process `a_value'.
		do
		    check last_property /= Void and then last_property.expression.is_predicate end

			properties_random.set_bit (last_property_index)
		end

	process_nonsensical_value (a_value: AFX_NONSENSICAL_VALUE)
			-- Process `a_value'.
		do
		    check last_property /= Void and then last_property.expression.is_predicate end

			properties_random.set_bit (last_property_index)
		end

	process_void_value (a_value: AFX_VOID_VALUE)
			-- Process `a_value'.
		do
				-- should not happen, we have filtered out the queries returning reference values.
		end

	process_any_value (a_value: AFX_ANY_VALUE)
			-- <Precursor>
		do
		end

feature{NONE} -- implementation

	key_to_hash: DS_LINEAR[INTEGER]
			-- <Precursor>
		local
		    l_size: INTEGER
		    l_index: INTEGER
		    l_list: DS_ARRAYED_LIST[INTEGER]
		    l_storage: like storage
		do
		    if count \\ 32 = 0 then
		        l_size := count // 32
		    else
		        l_size := count // 32 + 1
		    end

		    create l_list.make (l_size)
		    l_storage := storage
			from l_index := 0
			until l_index = l_size
			loop
				l_list.force_last (l_storage.item (l_index).as_integer_32)

				l_index := l_index + 1
			end

			Result := l_list
		end

invariant
    properties_vectors_no_intersection:
    		properties_true.bit_and (properties_false).count_of_set_bits = 0
    			and then properties_false.bit_and (properties_random).count_of_set_bits = 0
    			and then properties_true.bit_and (properties_random).count_of_set_bits = 0

    same_class: query_state /= Void implies query_state.class_.class_id = boolean_state_outline.class_.class_id

end
