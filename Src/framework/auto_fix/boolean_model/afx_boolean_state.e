note
	description: "Summary description for {AFX_BOOLEAN_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOLEAN_STATE

inherit

	EPA_HASH_CALCULATOR
    	undefine is_equal, copy	end

    EPA_EXPRESSION_VALUE_VISITOR
    	undefine is_equal, copy end

	AFX_SHARED_BOOLEAN_STATE_OUTLINE_MANAGER

	DEBUG_OUTPUT

	REFACTORING_HELPER

create
    make_for_class

feature -- Initializer

	make_for_class (a_class: like class_)
			-- Initialize
		require
		    class_boolean_outline_registered: boolean_state_outline_manager.boolean_class_outline (a_class) /= Void
		local
		    l_outline: AFX_BOOLEAN_STATE_OUTLINE
		    l_size: INTEGER
		do
			l_outline := get_effective_boolean_outline (a_class)
			boolean_state_outline := l_outline

			l_size := boolean_state_outline.count
			create properties_true.make (l_size)
			create properties_false.make (l_size)
		end

feature -- Access

	query_state: detachable EPA_STATE
			-- Original query-based state.

	boolean_state_outline: detachable AFX_BOOLEAN_STATE_OUTLINE
			-- Boolean outline related with class.

	properties_true: AFX_BIT_VECTOR assign set_properties_true
			-- Properties MAY evaluate 'True' on this state.

	properties_false: AFX_BIT_VECTOR assign set_properties_false
			-- Properties MAY evaluate 'False' on this state.

feature -- Status report

	class_: CLASS_C
			-- Class of this boolean state.
		do
		    Result := boolean_state_outline.class_
		end

	extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
			-- Extractor used to extract this boolean state.
		do
		    Result := boolean_state_outline.extractor
		end

	size, count: INTEGER
			-- Size of boolean state, i.e. count of boolean properties.
		do
		    Result := properties_true.count
		end

	is_query_state_available: BOOLEAN
			-- Is the original query state available?
		do
		    Result := query_state /= Void
		end

	is_chaos: BOOLEAN
			-- Is the state chaos?
		require
		    is_query_state_available: is_query_state_available
		do
		    if attached query_state as l_state then
		        Result := l_state.is_chaos
		    end
		end

feature -- State comparison

	is_comparable_state (a_state: like Current): BOOLEAN
			-- Is `Current' comparable with `a_state'?
		do
		    Result := Current.boolean_state_outline = a_state.boolean_state_outline
		end

	is_conforming_to (a_state: like Current; a_guidance_style: INTEGER): BOOLEAN
			-- Is the state conforming to `a_state', in `a_guidance_style'?
			-- Use different conformance criteria for different model guidance style.
		do
            if a_guidance_style = {AFX_BEHAVIOR_CONSTRUCTOR_CONFIG}.Model_guidance_style_restriced then
                Result := is_satisfactory_to (a_state)
            elseif a_guidance_style = {AFX_BEHAVIOR_CONSTRUCTOR_CONFIG}.Model_guidance_style_relaxed then
                Result := number_of_contradictions_to (a_state) = 0
            elseif a_guidance_style = {AFX_BEHAVIOR_CONSTRUCTOR_CONFIG}.Model_guidance_style_free then
            	Result := True
            end
		end

	is_satisfactory_to (a_condition: like Current): BOOLEAN
			-- Is the state satisfactory to the requirement of 'a_condition'?
			-- All the requirements from `a_condition' SHOULD be satisfied to make the state "satisfactory".
		do
		    Result := a_condition.properties_true.is_subset_of (properties_true)
		    		and then a_condition.properties_false.is_subset_of (properties_false)
		end

	number_of_contradictions_to (a_condition: like Current): INTEGER
			-- Number of contradictory properties between the state and `a_condition'.
			-- The numer is calculated in an optimistic way, such that only properties explictly negated will be counted.
			-- As long as the property is "unknown" in one state, it is not calculated.
		do
		    Result := (a_condition.properties_true & properties_false).count_of_set_bits +
		    			(a_condition.properties_false & properties_true).count_of_set_bits
		end

	distance_between (a_state: like Current): INTEGER
			-- Distance between two states.
			-- Properties with explictly the same values contribute 0;
			-- Properties with explictly the different values are counted 4 for each;
			-- Properties with one "unknown" value contributes 1 for each.
		local
		    properties_unknown_current, properties_unknown_state: like properties_true
		do
		    properties_unknown_current := (properties_true | properties_false).bit_not
		    properties_unknown_state := (a_state.properties_false | a_state.properties_true).bit_not

		    Result := number_of_contradictions_to (a_state) * 4 +
		    			(properties_unknown_current | properties_unknown_state).count_of_set_bits
		end

feature -- Representation

	to_string: STRING
			-- Generate a string representation.
		local
		    l_outline: AFX_BOOLEAN_STATE_OUTLINE
		    l_predicate: AFX_PREDICATE_EXPRESSION
		    l_index: INTEGER
		do
		    Result := ""
		    Result.append (class_.name)
		    Result.append ("%N")
		    if is_chaos then
		        Result.append ("<<chaos>>%N")
		    else
		        l_outline := boolean_state_outline
		        from
		        	l_index := 0
		        	l_outline.start
		        until l_outline.after
		        loop
		            l_predicate := l_outline.item_for_iteration
		            Result.append (l_predicate.to_string)

		            	-- A property is only shown to be True or False if it is only set
		            	-- 		in `properties_true' or `properties_false'
		            if properties_true.is_bit_set (l_index) then
		                if not properties_false.is_bit_set (l_index) then
		                    Result.append (": True%N")
		                else
		                    Result.append (": *%N")
		                end
		            elseif properties_false.is_bit_set (l_index) then
		                Result.append (": False%N")
		            else
		                Result.append (": *%N")
		            end

		            l_index := l_index + 1
		            l_outline.forth
		        end
		    end
		end

	debug_output: STRING
			-- <Precursor>
		do
		    Result := to_string
		end

feature -- Setters

	set_properties_true (a_vector: like properties_true)
			-- Set `properties_true' to be `a_vector'.
		do
		    properties_true := a_vector
		end

	set_properties_false (a_vector: like properties_false)
			-- Set `properties_false' to be `a_vector'
		do
		    properties_false := a_vector
		end

feature -- State comparison

	properties_negated_true (a_dest: like Current): AFX_BIT_VECTOR
			-- Properties negated to be `True', during transition from `Current' to `a_dest'.
		require
		    is_comparable: is_comparable_state (a_dest)
		    non_chaotic: not is_chaos and not a_dest.is_chaos
		do
		    Result := properties_false.bit_and (a_dest.properties_true)
		end

	properties_negated_false (a_dest: like Current): AFX_BIT_VECTOR
			-- Properties negated to be `False', during transition from `Current' to `a_dest'.
		require
		    is_comparable: is_comparable_state (a_dest)
		    non_chaotic: not is_chaos and not a_dest.is_chaos
		do
		    Result := properties_true.bit_and (a_dest.properties_false)
		end

	properties_unchanged_false (a_dest: like Current): AFX_BIT_VECTOR
			-- Properties remained `False', during transition from `Current' to `a_dest'.
		require
		    is_comparable: is_comparable_state (a_dest)
		    non_chaotic: not is_chaos and not a_dest.is_chaos
		do
		    Result := properties_false.bit_and (a_dest.properties_false)
		end

	properties_unchanged_true (a_dest: like Current): AFX_BIT_VECTOR
			-- Properties stayed `True', during transition from `Current' to `a_dest'.
		require
		    is_comparable: is_comparable_state (a_dest)
		    non_chaotic: not is_chaos and not a_dest.is_chaos
		do
		    Result := properties_true.bit_and (a_dest.properties_true)
		end

feature -- Query state interpretation

	interpretate (a_state: EPA_STATE)
			-- Interpretate `a_state' into boolean state.
		require
		    same_class: class_.class_id = a_state.class_.class_id
		local
		    l_outline: like boolean_state_outline
		    l_predicate: AFX_PREDICATE_EXPRESSION
		    l_exp: EPA_EXPRESSION
		    l_table: DS_HASH_TABLE[EPA_EXPRESSION_VALUE, EPA_EXPRESSION]
		    l_index: INTEGER
		do
		    query_state := a_state

		    if not is_chaos then
    		    	-- Put each pair of (value, expression) from `a_state' into hashtable.
    		    create l_table.make (a_state.count)
    		    l_table.set_key_equality_tester (create {EPA_EXPRESSION_EQUALITY_TESTER})
    		    l_table.set_equality_tester (create {EPA_EXPRESSION_VALUE_EQUALITY_TESTER})
    		    a_state.do_all (agent (an_equation: EPA_EQUATION; a_table: DS_HASH_TABLE[EPA_EXPRESSION_VALUE, EPA_EXPRESSION])
    		    		do
    		    			a_table.force (an_equation.value, an_equation.expression)
    		    		end (?, l_table))

    				-- Interpretate object state according to each boolean outline predicate.
    		    l_outline := boolean_state_outline
    		    from
    		    	l_index := 0
    		    	l_outline.start
    		    until
    		    	l_outline.after
    		    loop
    		        l_predicate := l_outline.item_for_iteration
    		        l_exp := l_predicate.expression

        		    if attached l_table.value (l_exp) as l_value then
    		        		-- Prepare the visitor.
        		        last_property := l_predicate
        		        last_property_index := l_index

        		        	-- Evaluate the values of properties.
        		        l_value.process (Current)

        		        last_property := Void
        		    end

    				l_index := l_index + 1
    		        l_outline.forth
    		    end
		    end
		ensure
		    is_ready: is_query_state_available
		end


feature{NONE} -- Visitor

	last_property: detachable AFX_PREDICATE_EXPRESSION
			-- Last unprocessed predicate.

	last_property_index: INTEGER
			-- Index of last unprocessed predicate in the boolean outline.

	process_boolean_value (a_value: EPA_BOOLEAN_VALUE)
			-- Process `a_value'.
		local
			l_property: like last_property
			l_bool: BOOLEAN
		do
		    check last_property /= Void and then last_property.is_predicate end

			l_property := last_property
			l_bool := l_property.predicator.item([a_value.item])
			if l_bool then
			    properties_true.set_bit (last_property_index)
			else
			    properties_false.set_bit (last_property_index)
			end
		end

	process_random_boolean_value (a_value: EPA_RANDOM_BOOLEAN_VALUE)
			-- Process `a_value'.
		do
		    check last_property /= Void and then last_property.is_predicate end
		end

	process_integer_value (a_value: EPA_INTEGER_VALUE)
			-- Process `a_value'.
		local
			l_property: like last_property
			l_bool: BOOLEAN
		do
		    check last_property /= Void and then last_property.is_predicate end

			l_property := last_property
			l_bool := l_property.predicator.item([a_value.item])
			if l_bool then
			    properties_true.set_bit (last_property_index)
			else
			    properties_false.set_bit (last_property_index)
			end
		end

	process_real_value (a_value: EPA_REAL_VALUE)
			-- Process `a_value'.
		do
			to_implement ("To implement. 15.5.2010 Jasonw")
		end

	process_pointer_value (a_value: EPA_POINTER_VALUE)
			-- Process `a_value'.
		do
			to_implement ("To implement. 15.5.200 Jasonw")
		end

	process_random_integer_value (a_value: EPA_RANDOM_INTEGER_VALUE)
			-- Process `a_value'.
		do
		    check last_property /= Void and then last_property.is_predicate end
		end

	process_nonsensical_value (a_value: EPA_NONSENSICAL_VALUE)
			-- Process `a_value'.
		do
		    check last_property /= Void and then last_property.is_predicate end
		end

	process_void_value (a_value: EPA_VOID_VALUE)
			-- Process `a_value'.
		do
			-- should not happen, we have filtered out the queries returning reference values.
		end

	process_any_value (a_value: EPA_ANY_VALUE)
			-- <Precursor>
		do
		end

	process_reference_value (a_value: EPA_REFERENCE_VALUE)
			-- Process `a_value'.
		do
		end

	process_ast_expression_value (a_value: EPA_AST_EXPRESSION_VALUE)
			-- Process `a_value'.
		do
		end

	process_string_value (a_value: EPA_STRING_VALUE)
			-- Process `a_value'
		do
		end

	process_set_value (a_value: EPA_EXPRESSION_SET_VALUE)
			-- Process `a_value'.
		do
		end

	process_numeric_range_value (a_value: EPA_NUMERIC_RANGE_VALUE)
			-- Process `a_value'.
		do
		end

feature{NONE} -- Implementation

	get_effective_boolean_outline (a_class: like class_): AFX_BOOLEAN_STATE_OUTLINE
			-- Get the currently working boolean outline for `a_class'.
		do
			Result := boolean_state_outline_manager.boolean_class_outline (a_class)
		end

	key_to_hash: DS_LINEAR[INTEGER]
			-- <Precursor>
		local
		    l_list: DS_ARRAYED_LIST[INTEGER]
		do
		    create l_list.make (3)
		    l_list.force_last (properties_true.hash_code)
		    l_list.force_last (properties_false.hash_code)
			Result := l_list
		end

end
