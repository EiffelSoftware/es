indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_FRAME_EXTRACTOR

inherit

	EP_VISITOR
		redefine
			process_argument_b,
			process_attribute_b,
			process_feature_b,
			process_nested_b,
			process_result_b,
			process_un_old_b
		end

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

create
	make,
	make_with_name_mapper

feature {NONE} -- Initialization

	make
			-- Initialize frame extractor.
		do
			create last_frame_condition.make_empty
			create modified_attributes.make
			create visited_features.make
			create {EP_NORMAL_NAME_MAPPER} name_mapper.make
		end

	make_with_name_mapper (a_name_mapper: !EP_NAME_MAPPER)
			-- Initialize frame extractor using name mapper `a_name_mapper'.
		do
			create last_frame_condition.make_empty
			create modified_attributes.make
			create visited_features.make
			name_mapper := a_name_mapper
		ensure
			name_mapper_set: name_mapper = a_name_mapper
		end

feature -- Access

	last_frame_condition: STRING
			-- Last built frame condition

	name_mapper: !EP_NAME_MAPPER
			-- Name mapper used to resolve names

feature -- Basic operations

	build_frame_condition (a_feature: !FEATURE_I)
			-- Build frame condition for feature `a_feature'.
		local
			l_item: TUPLE [target: STRING; field: STRING]
		do
			if feature_list.is_pure (a_feature) then
				last_frame_condition := "Heap == old(Heap)"
			else
				visited_features.wipe_out
				modified_attributes.wipe_out
				target := name_mapper.current_name
				process_feature_postcondition (a_feature)
				if modified_attributes.is_empty then
					last_frame_condition := "true"
				else
					last_frame_condition := "(forall<alpha> $o: ref, $f: Field alpha :: { Heap[$o, $f] } $o != Void && IsAllocated(old(Heap), $o)"
					from
						modified_attributes.start
					until
						modified_attributes.after
					loop
						l_item := modified_attributes.item_for_iteration

							-- TODO: refactor
						if l_item.field.is_equal ("$agent$") then
							last_frame_condition.append (" && (!agent.modifies(" + l_item.target + ", $o, $f))")
						else
							last_frame_condition.append (" && (!($o == " + l_item.target + " && $f == " + l_item.field + "))")
						end

						modified_attributes.forth
					end
					last_frame_condition.append (" ==> (old(Heap)[$o, $f] == Heap[$o, $f]))")
				end
			end
		ensure
			frame_condition_built: not last_frame_condition.is_empty
		end

	build_agent_frame_condition (a_feature: !FEATURE_I)
			-- TODO
		local
			l_item: TUPLE [target: STRING; field: STRING]
		do
			if feature_list.is_pure (a_feature) then
				last_frame_condition := "false"
			else
				modified_attributes.wipe_out
				visited_features.wipe_out
				target := name_mapper.target_name
				process_feature_postcondition (a_feature)
				if modified_attributes.is_empty then
					last_frame_condition := "(true"
				else
					last_frame_condition := "(false"
				end
				from
					modified_attributes.start
				until
					modified_attributes.after
				loop
					l_item := modified_attributes.item_for_iteration

						-- TODO: refactor
					if l_item.field.is_equal ("$agent$") then
							-- TODO: what to do here?
					else
						last_frame_condition.append (" || ($o == " + l_item.target + " && $f == " + l_item.field + ")")
					end

					modified_attributes.forth
				end
				last_frame_condition.append (")")
			end
		end

feature {NONE} -- Visitors

	process_feature_postcondition (a_feature: !FEATURE_I)
			-- Process postcondition of `a_feature'.
		local
			l_byte_code: BYTE_CODE
			l_previous_byte_code: BYTE_CODE
			l_previous_feature: FEATURE_I
			l_previous_class_type: CLASS_TYPE
			l_list: LIST [ASSERTION_BYTE_CODE]
		do
			current_feature := a_feature
			visited_features.extend (current_feature.rout_id_set.first)
			if byte_server.has (a_feature.code_id) then
				l_byte_code := byte_server.item (a_feature.code_id)

					-- Save byte context
				l_previous_byte_code := Context.byte_code
				l_previous_feature := Context.current_feature
				l_previous_class_type := Context.class_type
					-- Set up byte context
				Context.clear_feature_data
				Context.clear_class_type_data
				if not current_feature.written_class.is_generic then
					Context.init (a_feature.written_class.types.first)
				end
				Context.set_current_feature (a_feature)
				Context.set_byte_code (l_byte_code)

					-- Immediate postcondition
				if l_byte_code.postcondition /= Void then
					l_byte_code.postcondition.process (Current)
				end

					-- Inherited postconditions
				Context.inherited_assertion.wipe_out
				if a_feature.assert_id_set /= Void then
					l_byte_code.formulate_inherited_assertions (a_feature.assert_id_set)
					from
						l_list := Context.inherited_assertion.postcondition_list
						l_list.start
					until
						l_list.after
					loop
						l_list.item.process (Current)
						l_list.forth
					end
				end

					-- Restore byte context
				Context.clear_feature_data
				Context.clear_class_type_data
				if l_previous_class_type /= Void then
					Context.init (l_previous_class_type)
				end
				if l_previous_feature /= Void then
					Context.set_current_feature (l_previous_feature)
				end
				if l_previous_byte_code /= Void then
					Context.set_byte_code (l_previous_byte_code)
				end
			end
		end

	process_argument_b (a_node: ARGUMENT_B)
			-- <Precursor>
		do
			if in_target then
				target := name_generator.argument_name (current_feature.arguments.item_name (a_node.position))
			end
		end

	process_attribute_b (a_node: ATTRIBUTE_B)
			-- <Precursor>
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			l_target, l_boogie_name: STRING
		do
				-- TODO: why go over feature name and not feature id?
			l_feature := system.class_of_id (a_node.written_in).feature_of_name_id (a_node.attribute_name_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

			l_boogie_name := name_generator.attribute_name (l_attached_feature)

			if in_target then
					-- Follow target
				if in_old then
						-- Use old handler and name mapper
					target := "old(Heap)[" + target + ", " + l_boogie_name + "]"
				else
						-- Use old handler and name mapper
					target := "Heap[" + target + ", " + l_boogie_name + "]"
				end
			else
					-- Record attribute for frame condition
				create l_target.make_from_string (target)
				modified_attributes.extend ([l_target, l_boogie_name])
			end

		end

	process_feature_b (a_node: FEATURE_B)
			-- <Precursor>
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			l_current_feature: !FEATURE_I
		do
				-- TODO: make this nice
			if a_node.feature_name.is_equal ("postcondition") then
					-- Add agent frame condition

				modified_attributes.extend ([target, "$agent$"])

				Precursor {EP_VISITOR} (a_node)
			else
					-- TODO: why go over feature name and not feature id?
				l_feature := system.class_of_id (a_node.written_in).feature_of_name_id (a_node.feature_name_id)
				check l_feature /= Void end
				l_attached_feature := l_feature

					-- Only visit every feature once to rule out recursive calls
					-- TODO: Only features in the same class are visited. make a context switch and follow others too
				if
					current_feature.written_class.conform_to (l_attached_feature.written_class) and then
					not visited_features.has (l_attached_feature.rout_id_set.first)
				then
					l_current_feature := current_feature
					process_feature_postcondition (l_attached_feature)
					current_feature := l_current_feature
				end
			end
		end

	process_nested_b (a_node: NESTED_B)
			-- <Precursor>
		local
			l_target: BYTE_NODE
			l_last_target, l_field: STRING
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
		do
			create l_last_target.make_from_string (target)

			in_target := True
			a_node.target.process (Current)
			in_target := False

			a_node.message.process (Current)

			target := l_last_target
		end

	process_result_b (a_node: RESULT_B)
			-- <Precursor>
		do
--			target := name_mapper.result_name
		end

	process_un_old_b (a_node: UN_OLD_B)
			-- <Precursor>
		local
			l_last_target, l_field: STRING
		do
			in_old := True
			a_node.expr.process (Current)
			in_old := False
		end

feature {NONE} -- Implementation

	visited_features: LINKED_LIST [INTEGER]
			-- List of routine ids of visited features

	modified_attributes: LINKED_LIST [TUPLE [target: STRING; field: STRING]]
			-- List of modified attributes

	target: STRING
			-- Current target

	current_feature: !FEATURE_I
			-- Current processed feature

	in_old: BOOLEAN
			-- TODO

	in_target: BOOLEAN
			-- TODO

	in_message: BOOLEAN
			-- TODO

end
