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
		do
			if is_pure (a_feature) then
				last_frame_condition := "Heap == old(Heap)"
			else
				modified_attributes.wipe_out
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
						last_frame_condition.append (" && ($o != Current || $f != " + modified_attributes.item_for_iteration + ")")
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
			l_boogie_name: STRING
		do
				-- TODO: why go over feature name and not feature id?
			l_feature := system.class_of_id (a_node.written_in).feature_of_name_id (a_node.attribute_name_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

				-- Record attribute for frame condition
			l_boogie_name := name_generator.attribute_name (l_attached_feature)
			modified_attributes.extend (l_boogie_name)
		end

	process_feature_b (a_node: FEATURE_B)
			-- <Precursor>
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
		do
				-- TODO: why go over feature name and not feature id?
			l_feature := system.class_of_id (a_node.written_in).feature_of_name_id (a_node.feature_name_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

			process_feature_postcondition (l_attached_feature)
		end

	process_nested_b (a_node: NESTED_B)
			-- <Precursor>
		do
			-- Ignore nested calls for the moment
		end

feature {NONE} -- Implementation

	modified_attributes: LINKED_LIST [STRING]
			-- List of modified attributes


-- TODO: move someplace else and improve
	is_pure (a_feature: !FEATURE_I): BOOLEAN
			-- Is `a_feature' a pure feature?
		local
			l_indexing_clause: INDEXING_CLAUSE_AS
			l_index: INDEX_AS
			l_bool: BOOL_AS
			l_found: BOOLEAN
		do
			Result := feature_list.features_used_in_contracts.has (a_feature)
			if not Result then
				l_indexing_clause := a_feature.written_class.ast.feature_with_name (a_feature.feature_name_id).indexes
				if l_indexing_clause /= Void then
					from
						l_indexing_clause.start
					until
						l_indexing_clause.after or l_found
					loop
						l_index := l_indexing_clause.item
						if l_index.tag.name.as_lower.is_equal ("pure") then
							l_found := True
							l_bool ?= l_index.index_list.first
							if l_bool /= Void then
								Result := l_bool.value
							end
						end
						l_indexing_clause.forth
					end
				end
			end
		end

end
