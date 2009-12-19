note
	description: "Summary description for {AFX_STATE_TRANSITION_MODEL_SERIALIZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_TRANSITION_MODEL_SERIALIZER

inherit
    EXCEPTIONS

    SHARED_WORKBENCH
    	undefine is_equal, copy end

    AFX_SHARED_BOOLEAN_STATE_OUTLINE_MANAGER
    	undefine is_equal, copy end

    AFX_UTILITY
    	undefine is_equal, copy end

    SHARED_TYPES

    KL_SHARED_STRING_EQUALITY_TESTER

create
    default_create

feature -- Access

	is_successful: BOOLEAN
			-- Is last operation successful?

	error_message: STRING
			-- Error message, if not `is_successful'.

feature -- Serialization

	save_summary_manager (a_manager: AFX_FORWARD_STATE_TRANSITION_MODEL;
					a_file: KL_TEXT_OUTPUT_FILE)
			-- Save `a_manager' into `a_file'.
		local
		    l_string: STRING
		do
		    save_xml_header (a_file)

		    	-- start of root node
		    l_string := "<"
		    l_string.append (xml_forward_state_transition_model_name)
		    l_string.append (">%N")
		    a_file.put_string (l_string)

		    save_class_outline_collection_from_extractor (a_manager,
		    		{AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR},
		    		a_file)

		    save_class_summary_collection (a_manager, a_file)

		    	-- end of root node
		    l_string := "</"
		    l_string.append (xml_forward_state_transition_model_name)
		    l_string.append (">%N")
		    a_file.put_string (l_string)
		end

	save_postcondition_guided_summary_manager (a_manager: AFX_BACKWARD_STATE_TRANSITION_MODEL;
					a_file: KL_TEXT_OUTPUT_FILE)
			-- Save `a_manager' into `a_file'.
		local
		    l_string: STRING
		do
		    save_xml_header (a_file)

		    	-- start of root node
		    l_string := "<"
		    l_string.append (xml_backward_state_transition_model_name)
		    l_string.append (">%N")
		    a_file.put_string (l_string)

		    save_class_outline_collection_from_extractor (a_manager,
		    		{AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR},
		    		a_file)

		    save_class_summary_categorized_collection (a_manager,
		    		{AFX_BOOLEAN_STATE_OUTLINE_SIMPLE_EXTRACTOR},
		    		a_file)

		    	-- end of root node
		    l_string := "</"
		    l_string.append (xml_backward_state_transition_model_name)
		    l_string.append (">%N")
		    a_file.put_string (l_string)
		end


feature -- Deserialization

	load_summary_manager (a_document: XM_DOCUMENT; a_manager: AFX_FORWARD_STATE_TRANSITION_MODEL)
			-- Load information from `a_element' into `a_manager'
		local
		    l_root_element: XM_ELEMENT
		do
		    if not a_document.has_element_by_name (xml_forward_state_transition_model_name) then
			    raise ("Missing summary root.")
		    else
		        l_root_element := a_document.element_by_name (xml_forward_state_transition_model_name)
		        if not l_root_element.has_element_by_name (xml_class_outline_collection_name) or else
		        		not l_root_element.has_element_by_name (xml_class_summary_collection_name) then
		        	raise ("Bad summary structure")
		        else
		            load_class_outline_collection (l_root_element.element_by_name (xml_class_outline_collection_name),
		            		a_manager.boolean_state_outline_manager)
		            load_class_summary_collection (l_root_element.element_by_name (xml_class_summary_collection_name),
		            		a_manager)
		        end
		    end
		end

	load_postcondition_guided_summary_manager (a_document: XM_DOCUMENT; a_manager: AFX_BACKWARD_STATE_TRANSITION_MODEL)
			-- Load information from `a_element' into `a_manager'
		local
		    l_root_element: XM_ELEMENT
		do
		    if not a_document.has_element_by_name (xml_backward_state_transition_model_name) then
			    raise ("Missing summary root.")
		    else
		        l_root_element := a_document.element_by_name (xml_backward_state_transition_model_name)
		        if not l_root_element.has_element_by_name (xml_class_outline_collection_name) or else
		        		not l_root_element.has_element_by_name (xml_class_summary_categorized_collection_name) then
		        	raise ("Bad summary structure")
		        else
		            load_class_outline_collection (l_root_element.element_by_name (xml_class_outline_collection_name),
		            		a_manager.boolean_state_outline_manager)
		            load_class_summary_categorized_collection (l_root_element.element_by_name (xml_class_summary_categorized_collection_name),
		            		a_manager)
		        end
		    end
		end

feature{NONE} -- Serialization implementation

	save_xml_header (a_file: KL_TEXT_OUTPUT_FILE)
			-- Save the standard xml header into `a_file'
		do
			a_file.put_string (xml_head_string)
		end

	save_class_outline_collection_from_extractor (a_manager: AFX_STATE_TRANSITION_MODEL_I;
					a_extractor_type: TYPE[AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I];
					a_file: KL_TEXT_OUTPUT_FILE)
			-- Save class outlines in `a_manager', extracted using `a_extractor_type',
			-- 		into `a_file'.
		local
		    l_string: STRING
		    l_outline_manager: AFX_BOOLEAN_STATE_OUTLINE_MANAGER
		    l_outline: AFX_BOOLEAN_STATE_OUTLINE
		    l_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
		do
		    l_extractor := extractor_in_manager (a_manager, a_extractor_type)
		    l_outline_manager := a_manager.boolean_state_outline_manager

		    if not (l_extractor /= Void and then (attached l_outline_manager.value (l_extractor) as lt_outline_table)) then
		        error_message := "Unregistered extractor type."
		        raise (error_message)
		    else
    		    l_string := "<"
    		    l_string.append (xml_class_outline_collection_name)
    		    l_string.append (" extractor_id = %"")
    		    l_string.append (l_extractor.id.out)
    		    l_string.append ("%">%N")
    		    a_file.put_string (l_string)

        	    from lt_outline_table.start
        	    until lt_outline_table.after
        	    loop
        	        l_outline := lt_outline_table.item_for_iteration
        	        save_class_outline (l_outline, a_file)
        	        lt_outline_table.forth
        	    end

    		    l_string := "</"
    		    l_string.append (xml_class_outline_collection_name)
    		    l_string.append (">%N")

    		    a_file.put_string (l_string)
		    end
		end

	save_class_outline (a_outline: AFX_BOOLEAN_STATE_OUTLINE; a_file: KL_TEXT_OUTPUT_FILE)
			-- Save `a_outline' into `a_file'.
		local
		    l_string: STRING
		    l_predicate: AFX_PREDICATE_EXPRESSION
		do
			l_string := "<"
			l_string.append (xml_class_outline_name)
			l_string.append (" name = %"")
			l_string.append (a_outline.class_.name)
			l_string.append ("%">%N")

			from a_outline.start
			until a_outline.after
			loop
			    l_predicate := a_outline.item_for_iteration
			    l_string.append (once "<")
			    l_string.append (xml_property_name)
			    l_string.append (" name = %"")
			    l_string.append (l_predicate.to_xml_string)
			    l_string.append ("%"/>%N")
			    a_outline.forth
			end

			l_string.append (once "</")
			l_string.append (xml_class_outline_name)
			l_string.append (once ">%N")

			a_file.put_string (l_string)
		end

	save_class_summary_collection (a_class_summary_collection: AFX_FORWARD_STATE_TRANSITION_MODEL;
					a_file: KL_TEXT_OUTPUT_FILE)
			-- Save `a_transition_summary' into `a_file'
		local
		    l_string: STRING
		    l_system: SYSTEM_I
		    l_class_id, l_feature_id: INTEGER
		    l_class: CLASS_C
		    l_feature: FEATURE_I
		    l_class_name, l_feature_name: STRING
		    l_table: DS_HASH_TABLE[AFX_STATE_TRANSITION_SUMMARY, INTEGER]
		    l_summary: AFX_STATE_TRANSITION_SUMMARY
		do
		    l_string := "<"
		    l_string.append (xml_class_summary_collection_name)
		    l_string.append (once ">%N")
		    a_file.put_string (l_string)

--		    l_system := autofix_config.eiffel_system
			l_system := System
		    from a_class_summary_collection.start
		    until a_class_summary_collection.after
		    loop
		        l_table := a_class_summary_collection.item_for_iteration
		        l_class_id := a_class_summary_collection.key_for_iteration

		        l_class := l_system.class_of_id (l_class_id)
		        l_class_name := l_class.name

		        l_string := "<"
		        l_string.append (xml_class_summary_name)
		        l_string.append (" name = %"")
		        l_string.append (l_class_name)
		        l_string.append (once "%">%N")
		        a_file.put_string (l_string)

		        from l_table.start
		        until l_table.after
		        loop
		            l_summary := l_table.item_for_iteration
		            save_boolean_model_state_transition_summary (l_summary, a_file)
		            l_table.forth
		        end

		        l_string := "</"
		        l_string.append (xml_class_summary_name)
		        l_string.append (once ">%N")
		        a_file.put_string (l_string)

		        a_class_summary_collection.forth
		    end

			l_string := "</"
			l_string.append (xml_class_summary_collection_name)
		    l_string.append (once ">%N")
		    a_file.put_string (l_string)
		end

	save_class_summary_categorized_collection (a_manager: AFX_BACKWARD_STATE_TRANSITION_MODEL;
					a_extractor_type: TYPE[AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I];
					a_file: KL_TEXT_OUTPUT_FILE)
			-- Save the transition summaries into `a_file'
		local
		    l_system: SYSTEM_I
		    l_outline_manager: AFX_BOOLEAN_STATE_OUTLINE_MANAGER
		    l_string: STRING
		    l_class_id, l_property_index: INTEGER
		    l_class: CLASS_C
		    l_class_name: STRING
		    l_class_mutation_summary: DS_HASH_TABLE [ TUPLE [true_summary, false_summary: AFX_FORWARD_STATE_TRANSITION_MODEL], INTEGER]
		    l_true_summary, l_false_summary: AFX_FORWARD_STATE_TRANSITION_MODEL
		    l_outline: AFX_BOOLEAN_STATE_OUTLINE
		    l_predicate: AFX_PREDICATE_EXPRESSION
		do
		    l_system := System
		    l_outline_manager := a_manager.boolean_state_outline_manager

			l_string := "<"
			l_string.append (xml_class_summary_categorized_collection_name)
			l_string.append (">%N")
			a_file.put_string (l_string)

			from a_manager.start
			until a_manager.after
			loop
			    l_class_mutation_summary := a_manager.item_for_iteration
			    l_class_id := a_manager.key_for_iteration

				l_class := l_system.class_of_id (l_class_id)
			    l_class_name := l_class.name

			    l_string := "<"
			    l_string.append (xml_class_category_name)
			    l_string.append (" name = %"")
			    l_string.append (l_class_name)
			    l_string.append ("%">%N")
			    a_file.put_string (l_string)

			    from l_class_mutation_summary.start
			    until l_class_mutation_summary.after
			    loop
			        l_true_summary := l_class_mutation_summary.item_for_iteration.true_summary
			        l_false_summary := l_class_mutation_summary.item_for_iteration.false_summary
			        l_property_index := l_class_mutation_summary.key_for_iteration

					l_outline := l_outline_manager.boolean_class_outline (l_class)
					l_predicate := l_outline.predicate_at_position (l_property_index)

						-- "True" mutators
					l_string := "<"
					l_string.append (xml_property_category_name)
					l_string.append (" name = %"")
					l_string.append (l_predicate.to_xml_string)
					l_string.append ("%" set_to = %"True%">%N")
					a_file.put_string (l_string)

					save_class_summary_collection (l_true_summary, a_file)
--					l_true_summary.save_transition_summary (a_file)

					l_string := "</"
					l_string.append (xml_property_category_name)
					l_string.append (">%N")
					a_file.put_string (l_string)

						-- "False" mutators
					l_string := "<"
					l_string.append (xml_property_category_name)
					l_string.append (" name = %"")
					l_string.append (l_predicate.to_xml_string)
					l_string.append ("%" set_to = %"False%">%N")
					a_file.put_string (l_string)

					save_class_summary_collection (l_false_summary, a_file)
--					l_false_summary.save_transition_summary (a_file)

					l_string := "</"
					l_string.append (xml_property_category_name)
					l_string.append (">%N")
					a_file.put_string (l_string)

			        l_class_mutation_summary.forth
			    end

			    l_string := "</"
			    l_string.append (xml_class_category_name)
			    l_string.append (">%N")
			    a_file.put_string (l_string)
			    a_manager.forth
			end

			l_string := "</"
			l_string.append (xml_class_summary_categorized_collection_name)
			l_string.append (">%N")
			a_file.put_string (l_string)
		end

	save_boolean_model_state_transition_summary (a_summary: AFX_STATE_TRANSITION_SUMMARY;
				a_file: KL_TEXT_OUTPUT_FILE)
			-- Save `a_summary' into `a_file'.
			-- Fixme: Selection should be in a separator class
		local
		    l_class: CLASS_C
		    l_creators: HASH_TABLE [EXPORT_I, STRING]
		    l_feature: FEATURE_I
		    l_feature_name: STRING
		    l_string: STRING
		    l_state_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		do
		    l_class := a_summary.class_
		    l_feature := a_summary.feature_
		    check l_class /= Void and then l_feature /= Void end
		    l_creators := l_class.creators
		    l_feature_name := l_feature.feature_name

   		    if not (l_creators /= Void and then l_creators.has (l_feature_name)) and then l_feature.type = void_type then
    		    l_string := "<"
    		    l_string.append (xml_feature_summary_name)
    		    l_string.append (" name = %"")
    		    l_string.append (l_feature_name)
    		    l_string.append ("%">%N")
    		    a_file.put_string (l_string)

    		    from a_summary.start
    		    until a_summary.after
    		    loop
    		        l_state_summary := a_summary.item_for_iteration
    		        save_boolean_state_transition_summary (l_state_summary, a_file)
    		        a_summary.forth
    		    end

    		    l_string := "</"
    		    l_string.append (xml_feature_summary_name)
    		    l_string.append (once ">%N")
    		    a_file.put_string (l_string)
    		end
		end

	save_boolean_state_transition_summary (a_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY;
					a_file: KL_TEXT_OUTPUT_FILE)
			-- Save the summary into `a_file'.
		local
		    l_class_name: STRING
		    l_string: STRING
		    l_state_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		    l_outline: AFX_BOOLEAN_STATE_OUTLINE
		do
		    l_class_name := a_summary.class_.name
		    l_outline := a_summary.boolean_state_outline

		    l_string := "<"
		    l_string.append (xml_operand_summary_name)
		    l_string.append (" class = %"")
		    l_string.append (l_class_name)
		    l_string.append ("%" is_source_chaos = %"")
		    l_string.append (a_summary.is_source_chaos.out)
		    l_string.append ("%">%N")
		    a_file.put_string (l_string)

			save_transition_invariant (a_file, l_outline, a_summary.pre_true, "pre_true")
			save_transition_invariant (a_file, l_outline, a_summary.pre_false, "pre_false")
			save_transition_invariant (a_file, l_outline, a_summary.post_set_true, "post_set_true")
			save_transition_invariant (a_file, l_outline, a_summary.post_set_false, "post_set_false")
			save_transition_invariant (a_file, l_outline, a_summary.post_unchanged, "post_unchanged")
			save_transition_invariant (a_file, l_outline, a_summary.post_negated, "post_negated")

		    l_string := "</"
		    l_string.append (xml_operand_summary_name)
		    l_string.append (once ">%N")
		    a_file.put_string (l_string)
		end

	save_transition_invariant (a_file: KL_TEXT_OUTPUT_FILE; a_outline: AFX_BOOLEAN_STATE_OUTLINE;
					a_bit_vector: AFX_BIT_VECTOR; a_node_name: STRING)
			-- Save transition invariants into `a_file'.
			-- The type of invariant is specified by `a_node_name'.
		local
		    l_predicate: AFX_PREDICATE_EXPRESSION
		    l_index: INTEGER
		    l_string: STRING
		do
		    l_string := "<"
		    l_string.append (xml_invariant_name)
		    l_string.append (once " name = %"")
		    l_string.append (a_node_name)
		    l_string.append (once "%">%N")

		    from
		    	l_index := 0
		    	a_outline.start
		    until a_outline.after
		    loop
		        if a_bit_vector.is_bit_set (l_index) then
    		        l_predicate := a_outline.item_for_iteration

		            l_string.append (once "<")
		            l_string.append (xml_property_name)
		            l_string.append (" name = %"")
		            l_string.append (l_predicate.to_xml_string)
		            l_string.append ("%"/>%N")
		        end

		        l_index := l_index + 1
		        a_outline.forth
		    end

		    l_string.append (once "</")
		    l_string.append (xml_invariant_name)
		    l_string.append (once ">%N")

		    a_file.put_string (l_string)
		end

	extractor_in_manager (a_manager: AFX_STATE_TRANSITION_MODEL_I;
					a_extractor_type: TYPE[AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I]): detachable AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
			-- Extractor of type `a_extractor_type' in `a_manager'
		local
		    l_outline_manager: AFX_BOOLEAN_STATE_OUTLINE_MANAGER
			l_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
		do
		    l_outline_manager := a_manager.boolean_state_outline_manager
		    from l_outline_manager.start
		    until l_outline_manager.after or not (l_extractor = Void)
		    loop
		        if attached a_extractor_type.attempt (l_outline_manager.key_for_iteration) as lt_extractor then
		            l_extractor := lt_extractor
		        end
		        l_outline_manager.forth
		    end
		    Result := l_extractor
		end

feature{NONE} -- Deserialization mplementation

	load_class_outline_collection (a_element: XM_ELEMENT; a_manager: AFX_BOOLEAN_STATE_OUTLINE_MANAGER)
			-- Load class outline collection from `a_element'.
		require
		    node_name: a_element.name ~ xml_class_outline_collection_name
		local
		    l_extractor_id: INTEGER
		    l_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
		do
		    if not a_element.has_attribute_by_name ("extractor_id") then
		        error_message := "Missing %"extractor_id%""
		        raise (error_message)
		    else
		        l_extractor_id := a_element.attribute_by_name ("extractor_id").value.to_integer
		        l_extractor := a_manager.extractor_of_id (l_extractor_id)
		        a_manager.set_effective_extractor (l_extractor)

    			from a_element.start
    			until a_element.after
    			loop
    			    if attached {XM_ELEMENT} a_element.item_for_iteration as lt_element then
        			    check lt_element.name ~ xml_class_outline_name end
        			    load_class_outline (lt_element, a_manager, l_extractor)
    			    end
    			    a_element.forth
    			end
		    end
		end

	load_class_outline (a_element: XM_ELEMENT;
					a_manager: AFX_BOOLEAN_STATE_OUTLINE_MANAGER;
					a_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I)
			-- Load class outline.
		require
		    node_name: a_element.name ~ xml_class_outline_name
		local
		    l_outline_table: DS_HASH_TABLE [AFX_BOOLEAN_STATE_OUTLINE, INTEGER]
		    l_class_name, l_property_name: STRING
		    l_class: CLASS_C
		    l_class_id: INTEGER
		    l_system: SYSTEM_I
		    l_predicate: AFX_PREDICATE_EXPRESSION
		    l_outline: AFX_BOOLEAN_STATE_OUTLINE
		do
			l_outline_table := a_manager.value (a_extractor)
			check l_outline_table /= Void end

			if not a_element.has_attribute_by_name ("name") then
			    error_message := "Missing class outline class name."
			    raise (error_message)
			else
			    l_class_name := a_element.attribute_by_name ("name").value
			    l_class := first_class_starts_with_name (l_class_name)
			    if l_class /= Void then
    			    check l_class /= Void end
    			    l_class_id := l_class.class_id
    			    create l_outline.make_for_class (l_class, a_extractor)

        			from a_element.start
        			until a_element.after
        			loop
        			    if attached {XM_ELEMENT} a_element.item_for_iteration as lt_element then
        			        check lt_element.name ~ xml_property_name end
        			        if not lt_element.has_attribute_by_name ("name") then
        			            error_message := "Missing class outline property name."
        			            raise (error_message)
        			        else
        			            l_property_name := lt_element.attribute_by_name ("name").value
        			            create l_predicate.make_from_xml_string (l_property_name, l_class)
    							l_outline.force (l_predicate)
        			        end
        			    end
        			    a_element.forth
        			end

        			l_outline_table.force (l_outline, l_class_id)
        		else
        		    -- class not in current system, skip the node
        		end
			end
		end

	load_class_summary_collection (a_element: XM_ELEMENT; a_manager: AFX_FORWARD_STATE_TRANSITION_MODEL)
			-- Process class summary collection at `a_element'.
		require
		    node_name: a_element.name ~ xml_class_summary_collection_name
		do
			from a_element.start
			until a_element.after
			loop
			    if attached {XM_ELEMENT} a_element.item_for_iteration as lt_element then
    			    check lt_element.name ~ xml_class_summary_name end
    			    load_class_summary (lt_element, a_manager)
			    end

			    a_element.forth
			end
		end

	load_class_summary_categorized_collection (a_element: XM_ELEMENT; a_manager: AFX_BACKWARD_STATE_TRANSITION_MODEL)
			-- Load information from `a_element' into `a_manager'
		require
		    node_name: a_element.name ~ xml_class_summary_categorized_collection_name
		    outline_extractor_ready: a_manager.boolean_state_outline_manager /= Void
		local
		    l_class_id: INTEGER
		    l_summary, l_last_summary: AFX_FORWARD_STATE_TRANSITION_MODEL
		    l_class_mutation_summary: DS_HASH_TABLE [TUPLE [true_summary: AFX_FORWARD_STATE_TRANSITION_MODEL; false_summary: AFX_FORWARD_STATE_TRANSITION_MODEL], INTEGER_32]
			l_class_name, l_property_name, l_last_property_name: STRING
			l_property_index: INTEGER
			l_property_value, l_last_property_value: BOOLEAN
			l_outline: AFX_BOOLEAN_STATE_OUTLINE
			l_element: XM_ELEMENT
		do
			from a_element.start
			until a_element.after
			loop
			    if attached {XM_ELEMENT} a_element.item_for_iteration as lt_element then
			        check lt_element.name ~ xml_class_category_name end

			        if not lt_element.has_attribute_by_name ("name") then
			            raise ("Missing mutation class name.")
			        end

			        l_class_name := lt_element.attribute_by_name ("name").value
			        if attached first_class_starts_with_name (l_class_name) as lt_class then
        			    create l_class_mutation_summary.make_default
			            l_outline := boolean_state_outline_manager.boolean_class_outline (lt_class)

			            from lt_element.start
			            until lt_element.after
			            loop
			                if attached {XM_ELEMENT} lt_element.item_for_iteration as lt_element2 then
			                    check lt_element2.name ~ xml_property_category_name end
			                    if not lt_element2.has_attribute_by_name ("name") or else not lt_element2.has_attribute_by_name ("set_to") then
			                        raise ("Missing property category attribute.")
			                    end
			                    if not lt_element2.has_element_by_name (xml_class_summary_collection_name) then
			                        raise ("Missing class summary collection.")
			                    end

			                    l_element := lt_element2.element_by_name (xml_class_summary_collection_name)
			                    l_property_name := lt_element2.attribute_by_name ("name").value
			                    l_property_value := lt_element2.attribute_by_name ("set_to").value.to_boolean
								create l_summary.make_default
			                    if l_property_value then
			                        check l_last_property_name = Void and not l_last_property_value end
			                        load_class_summary_collection (l_element, l_summary)
			                        l_last_property_name := l_property_name
			                        l_last_property_value := l_property_value
			                        l_last_summary := l_summary
			                    else
			                        check l_last_property_name ~ l_property_name and l_last_property_value end
			                        load_class_summary_collection (l_element, l_summary)

										-- the property name read here has been converted back to common characters, i.e. not &lt; or &gt;
									l_property_index := l_outline.index_from_string (l_property_name, False)
									check l_property_index /= -1 end
									l_class_mutation_summary.force ([l_last_summary, l_summary], l_property_index)

			                        l_last_property_name := Void
			                        l_last_property_value := l_property_value
			                    end
			                end
			                lt_element.forth
			            end
			            a_manager.force (l_class_mutation_summary, lt_class.class_id)
			        else
			            -- skip class not in the system
			        end
			    end
			    a_element.forth
			end
		end

	load_class_summary (a_element: XM_ELEMENT; a_manager: AFX_FORWARD_STATE_TRANSITION_MODEL)
			-- Load class summary.
		require
		    node_name: a_element.name ~ xml_class_summary_name
		local
		    l_class_name: STRING
		do
		    if not a_element.has_attribute_by_name ("name") then
		        raise ("Missing class summary class name.")
		    else
		        l_class_name := a_element.attribute_by_name ("name").value
		        if attached first_class_starts_with_name (l_class_name) as lt_class then
    		    	from a_element.start
    		    	until a_element.after
    		    	loop
    		    	    if attached {XM_ELEMENT} a_element.item_for_iteration as lt_element then
           		            check lt_element.name ~ xml_feature_summary_name end
           		            load_boolean_model_state_transition_summary (lt_element, a_manager, lt_class)
    		    	    end
    		    	    a_element.forth
    		    	end
		        else
		            -- skip class not in the system
		        end
		    end
		end

	load_boolean_model_state_transition_summary (a_element: XM_ELEMENT;
					a_manager: AFX_FORWARD_STATE_TRANSITION_MODEL;
					a_class: CLASS_C)
			-- Load boolean model state transition summary.
		require
		    node_name: a_element.name ~ xml_feature_summary_name
		local
		    l_feature: FEATURE_I
		    l_class_id, l_feature_id: INTEGER
		    l_feature_name: STRING
		    l_element: XM_ELEMENT
		    l_model_summary: AFX_STATE_TRANSITION_SUMMARY
		    l_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		    l_summary_table: DS_HASH_TABLE[AFX_STATE_TRANSITION_SUMMARY, INTEGER]
		do
		    if not a_element.has_attribute_by_name ("name") then
		        raise ("Missing class summary feature name.")
		    else
		        l_feature_name := a_element.attribute_by_name ("name").value
		        l_feature := a_class.feature_named (l_feature_name)

		        create l_model_summary.make_default
		        l_model_summary.set_class (a_class)
		        l_model_summary.set_feature (l_feature)

		        is_all_operand_class_present := True
		        from a_element.start
		        until a_element.after or not is_all_operand_class_present
		        loop
		            if attached {XM_ELEMENT} a_element.item_for_iteration as lt_element then
    		            check lt_element.name ~ xml_operand_summary_name end
    		            load_boolean_state_transition_summary (lt_element, l_model_summary)
		            end

		            a_element.forth
		        end

		        	-- insert new loaded summary into manager
		        if is_all_operand_class_present then
    		        if attached a_manager.value (a_class.class_id) as lt_summary_table then
    		            lt_summary_table.force (l_model_summary, l_feature.feature_id)
    		        else
        		        create l_summary_table.make_default
        		        l_summary_table.force (l_model_summary, l_feature.feature_id)
    			        a_manager.force (l_summary_table, a_class.class_id)
    		        end
		        end
		    end
		end

	load_boolean_state_transition_summary (a_element: XM_ELEMENT; a_summary: AFX_STATE_TRANSITION_SUMMARY)
		require
		    node_name: a_element.name ~ xml_operand_summary_name
		local
		    l_element: XM_ELEMENT
		    l_class_name: STRING
		    l_elements: DS_LIST[XM_ELEMENT]
		    l_is_source_chaos: BOOLEAN
		    l_summary: AFX_BOOLEAN_STATE_TRANSITION_SUMMARY
		    l_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
		    l_outline: AFX_BOOLEAN_STATE_OUTLINE
		    l_pre_true, l_pre_false, l_post_true, l_post_false, l_post_negated, l_post_unchanged: AFX_BIT_VECTOR
		do
		    if not a_element.has_attribute_by_name ("class") or else not a_element.has_attribute_by_name ("is_source_chaos") then
		        error_message := "Missing boolean state transition attribute(s)."
		        raise (error_message)
		    else
		        l_is_source_chaos := a_element.attribute_by_name ("is_source_chaos").value.to_boolean
		        l_class_name := a_element.attribute_by_name ("class").value
		        if attached first_class_starts_with_name (l_class_name) as lt_class then
    	    	    l_outline := boolean_state_outline_manager.boolean_class_outline (lt_class)
    		        create l_summary.make_with_outline (l_outline)
    		        l_summary.set_source_chaos (l_is_source_chaos)

    	    	    l_elements := a_element.elements
    	    	    check l_elements.count = 6 end
    	    	    l_elements.start
   	    	        load_transition_invariant (l_elements.item_for_iteration, l_outline, l_summary.pre_true)
       	    	    l_elements.forth

	    	        load_transition_invariant (l_elements.item_for_iteration, l_outline, l_summary.pre_false)
    	    	    l_elements.forth

	    	        load_transition_invariant (l_elements.item_for_iteration, l_outline, l_summary.post_set_true)
    	    	    l_elements.forth

	    	        load_transition_invariant (l_elements.item_for_iteration, l_outline, l_summary.post_set_false)
    	    	    l_elements.forth

	    	        load_transition_invariant (l_elements.item_for_iteration, l_outline, l_summary.post_unchanged)
    	    	    l_elements.forth

	    	        load_transition_invariant (l_elements.item_for_iteration, l_outline, l_summary.post_negated)
    	    	    l_elements.forth

    				a_summary.force_last (l_summary)
				else
				    is_all_operand_class_present := False
				    -- operand class not in system, skip the feature call.
		        end

		    end
		end

	load_transition_invariant (a_element: XM_ELEMENT; a_outline: AFX_BOOLEAN_STATE_OUTLINE; a_vector: AFX_BIT_VECTOR)
			-- Load transition invariant.
		require
		    node_name: a_element.name ~ xml_invariant_name
		local
		    l_element: XM_ELEMENT
		    l_predicate_str: STRING
		    l_index: INTEGER
		    l_vector: AFX_BIT_VECTOR
		    l_str_set: DS_HASH_SET[STRING]
		    l_predicate: AFX_PREDICATE_EXPRESSION
		do
		    create l_str_set.make (a_outline.count)
		    l_str_set.set_equality_tester (string_equality_tester)

		    	-- collect all the predicate strings at this state
		    from a_element.start
		    until a_element.after
		    loop
		        if attached {XM_ELEMENT} a_element.item_for_iteration as lt_element then
    		        check lt_element.name ~ xml_property_name end
    		        if not lt_element.has_attribute_by_name ("name") then
    		            raise ("Missing property name.")
    		        else
    		            l_predicate_str := lt_element.attribute_by_name ("name").value
    		            l_str_set.force (l_predicate_str)
    		        end
		        end
		        a_element.forth
		    end

		    	-- set the corresponding bits in result bit vector
		    from
		        l_index := 0
		        a_outline.start
		    until
		        a_outline.after
		    loop
		        l_predicate := a_outline.item_for_iteration

		        if l_str_set.has (l_predicate.to_string) then
		            a_vector.set_bit (l_index)
		        end
		        l_index := l_index + 1
		        a_outline.forth
		    end
		end

feature{NONE} -- Implementation

	is_all_operand_class_present: BOOLEAN

feature{NONE} -- XML constants

	xml_head_string: STRING = "<?xml version=%"1.0%" encoding=%"ISO-8859-1%"?>%N%N"

	xml_backward_state_transition_model_name: STRING = "backward_state_transition_model"

	xml_forward_state_transition_model_name: STRING = "forward_state_transition_model"

	xml_class_outline_collection_name: STRING = "cls_otln_col"

	xml_class_outline_name: STRING = "cls_otln"

	xml_property_name: STRING = "pro"

	xml_class_summary_categorized_collection_name: STRING = "cls_sum_cat_col"

	xml_class_category_name: STRING = "cls_cat"

	xml_property_category_name: STRING = "pro_cat"

	xml_class_summary_collection_name: STRING = "cls_sum_col"

	xml_class_summary_name: STRING = "cls_sum"

	xml_feature_summary_name: STRING = "feat_sum"

	xml_operand_summary_name: STRING = "op_sum"

	xml_invariant_name: STRING = "inv"

end
