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
			process_attribute_b,
			process_feature_b,
			process_nested_b
		end

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize frame extractor.
		do
			create last_frame_condition.make_empty
			create modified_attributes.make
		end

feature -- Access

	last_frame_condition: STRING
			-- Last built frame condition

feature -- Basic operations

	build_frame_condition (a_feature: !FEATURE_I)
			-- Build frame condition for feature `a_feature'.
		local
			l_item: TUPLE [target: STRING; field: STRING]
		do
			if feature_list.is_pure (a_feature) then
				last_frame_condition := "Heap == old(Heap)"
			else
				modified_attributes.wipe_out
				target := "Current"
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
						last_frame_condition.append (" && ($o != " + l_item.target + " || $f != " + l_item.field + ")")
						modified_attributes.forth
					end
					last_frame_condition.append (" ==> (old(Heap)[$o, $f] == Heap[$o, $f]))")
				end
			end
		ensure
			frame_condition_built: not last_frame_condition.is_empty
		end

feature {NONE} -- Visitors

	process_feature_postcondition (a_feature: !FEATURE_I)
			-- Process postcondition of `a_feature'.
		local
			l_byte_code: BYTE_CODE
			l_previous_byte_code: BYTE_CODE
			l_previous_feature: FEATURE_I
		do
			current_feature := a_feature
			if byte_server.has (a_feature.code_id) then
				l_byte_code := byte_server.item (a_feature.code_id)

					-- Save byte context
				l_previous_byte_code := Context.byte_code
				l_previous_feature := Context.current_feature
					-- Set up byte context
				Context.clear_feature_data
				Context.clear_class_type_data
-- TODO: types can be empty
				Context.init (a_feature.written_class.types.first)
				Context.set_current_feature (a_feature)
				Context.set_byte_code (l_byte_code)

-- TODO: follow inherited assertions
				if l_byte_code.postcondition /= Void then
					l_byte_code.postcondition.process (Current)
				end

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

				-- Record attribute for frame condition
			l_boogie_name := name_generator.attribute_name (l_attached_feature)
			create l_target.make_from_string (target)
			modified_attributes.extend ([l_target, l_boogie_name])
		end

	process_feature_b (a_node: FEATURE_B)
			-- <Precursor>
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			l_current_feature: !FEATURE_I
		do
				-- TODO: why go over feature name and not feature id?
			l_feature := system.class_of_id (a_node.written_in).feature_of_name_id (a_node.feature_name_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

			l_current_feature := current_feature
			process_feature_postcondition (l_attached_feature)
			current_feature := l_current_feature
		end

	process_nested_b (a_node: NESTED_B)
			-- <Precursor>
		local
			l_last_target: STRING
		do
			create l_last_target.make_from_string (target)

			-- TODO: follow nested calls, i.e. set the new target object and follow the feature call
			-- Problem: all the field accesses in the nested calls have to be transformed to the current context

			if {l_argument_b: ARGUMENT_B} a_node.target then
				-- TODO ...
			elseif {l_attribute_b: ATTRIBUTE_B} a_node.target then
				-- TODO ...
			elseif {l_result_b: RESULT_B} a_node.target then
				target := "Result"
				-- TODO ...
			end

			target := l_last_target
		end

feature {NONE} -- Implementation

	modified_attributes: LINKED_LIST [TUPLE [target: STRING; field: STRING]]
			-- List of modified attributes

	target: STRING
			-- Current target

	current_feature: !FEATURE_I
			-- Current processed feature

end
