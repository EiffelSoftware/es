indexing
	description:
		"[
			Class which traverses a byte tree and marks all classes which occur in a contract as probably pure.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_PURE_MARKER

inherit

	EP_VISITOR
		redefine
			process_feature_b,
			process_external_b
		end

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	SHARED_SERVER
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize object.
		do

		end

feature -- Basic operations

	traverse_class (a_class: !CLASS_C)
			-- Traverse all features of class `a_class'.
		require
			has_feature_table: a_class.has_feature_table
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
		do
			from
				a_class.feature_table.start
			until
				a_class.feature_table.after
			loop
				l_feature := a_class.feature_table.item_for_iteration
				check l_feature /= Void end
				l_attached_feature := l_feature

					-- Only write features which are written in that class
				if l_feature.written_in = a_class.class_id then
					traverse_feature (l_attached_feature)
				end

				a_class.feature_table.forth
			end
		end

	traverse_feature (a_feature: !FEATURE_I)
			-- Traverse contract of `a_feature'.
		local
			l_byte_code: BYTE_CODE
		do
			if byte_server.has (a_feature.code_id) then
				l_byte_code := byte_server.item (a_feature.code_id)
				check l_byte_code /= Void end

				Context.clear_feature_data
				Context.clear_class_type_data
	-- TODO: types can be empty
				Context.init (a_feature.written_class.types.first)
				Context.set_current_feature (a_feature)
				Context.set_byte_code (l_byte_code)

				safe_process (l_byte_code.precondition)
				safe_process (l_byte_code.postcondition)

				Context.inherited_assertion.wipe_out
				if a_feature.assert_id_set /= Void then
					l_byte_code.formulate_inherited_assertions (a_feature.assert_id_set)
					process_inherited_assertions (Context.inherited_assertion)
				end
			end
		end

feature {NONE} -- Visitor

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

			feature_list.record_feature_used_in_contract (l_attached_feature)
		end

	process_external_b (a_node: EXTERNAL_B)
			-- <Precursor>
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
		do
			-- TODO: unify with `process_feature_b'
				-- TODO: why go over feature name and not feature id?
			l_feature := system.class_of_id (a_node.written_in).feature_of_name_id (a_node.feature_name_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

			feature_list.record_feature_used_in_contract (l_attached_feature)
		end

feature {NONE} -- Implementation

	process_inherited_assertions (a_list: INHERITED_ASSERTION)
			-- Process inherited assertions
		require
			a_list_not_void: a_list /= Void
		local
			l_last_class_id, l_current_class_id: INTEGER
		do
			from
				a_list.precondition_start
			until
				a_list.precondition_after
			loop
				safe_process (a_list.precondition_list.item_for_iteration)
				a_list.precondition_forth
			end

			from
				a_list.postcondition_start
			until
				a_list.postcondition_after
			loop
				safe_process (a_list.postcondition_list.item_for_iteration)
				a_list.postcondition_forth
			end
		end

end
