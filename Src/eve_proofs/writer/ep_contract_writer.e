indexing
	description:
		"[
			Boogie code writer used to transform contracts.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_CONTRACT_WRITER

inherit {NONE}

	SHARED_SERVER
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize contract writer.
		do
			create {LINKED_LIST [TUPLE [tag: STRING; expression: !STRING; class_id: INTEGER; line_number: INTEGER]]} preconditions.make
			create {LINKED_LIST [TUPLE [tag: STRING; expression: !STRING; class_id: INTEGER; line_number: INTEGER]]} postconditions.make
			create {LINKED_LIST [TUPLE [tag: STRING; expression: !STRING; class_id: INTEGER; line_number: INTEGER]]} invariants.make
			create full_precondition.make_empty
			create full_postcondition.make_empty
			create frame_expression.make_empty
		end

feature -- Access

	current_feature: FEATURE_I
			-- Feature which is currently being processed

	preconditions: !LIST [TUPLE [tag: STRING; expression: !STRING; class_id: INTEGER; line_number: INTEGER]]
			-- List of generated preconditions

	postconditions: !LIST [TUPLE [tag: STRING; expression: !STRING; class_id: INTEGER; line_number: INTEGER]]
			-- List of generated postconditions

	invariants: !LIST [TUPLE [tag: STRING; expression: !STRING; class_id: INTEGER; line_number: INTEGER]]
			-- List of generated ivariants

	full_precondition: !STRING
			-- Full precondition
			-- Preconditions are combined with conjunctions and disjunctions

	full_postcondition: !STRING
			-- Full postcondition, with con
			-- Postconditions are combined with conjunctions

	expression_writer: EP_EXPRESSION_WRITER
			-- Writer used to generate contracts

	frame_expression: !STRING
			-- Frame expression

feature -- Status report

	has_weakened_preconditions: BOOLEAN
			-- Does feature have weakened its precondition?

feature -- Element change

	set_feature (a_feature: FEATURE_I)
			-- Set `current_feature' to `a_feature'.
		do
			current_feature := a_feature

			if byte_server.has (current_feature.code_id) then
				byte_code := byte_server.item (current_feature.code_id)
			else
				byte_code := Void
			end
		ensure
			current_feature_set: current_feature = a_feature
		end

	set_expression_writer (a_expression_writer: EP_EXPRESSION_WRITER)
			-- Set `expression_writer' to `a_expression_writer'.
		do
			expression_writer := a_expression_writer
		ensure
			expression_writer_set: expression_writer = a_expression_writer
		end

feature -- Basic operations

	reset
			-- Reset contract writer.
		do
			current_feature := Void
			preconditions.wipe_out
			postconditions.wipe_out
			invariants.wipe_out
			create full_precondition.make_empty
			create full_postcondition.make_empty
			has_weakened_preconditions := False
			create frame_expression.make_empty
		ensure
			current_feature_void: current_feature = Void
			preconditions_reset: preconditions.is_empty
			postconditions_reset: postconditions.is_empty
			full_precondition_empty: full_precondition.is_empty
			full_postcondition_empty: full_postcondition.is_empty
		end

	generate_contracts
			-- Generate Boogie code for pre- and postconditions.
		require
			current_feature_set: current_feature /= Void
			expression_writer_set: expression_writer /= Void
		local
			l_previous_byte_code: BYTE_CODE
			l_previous_feature: FEATURE_I
		do
				-- Save byte context
			l_previous_byte_code := Context.byte_code
			l_previous_feature := Context.current_feature
				-- Set up byte context
			Context.clear_feature_data
			Context.clear_class_type_data
			Context.init (current_feature.written_class.types.first)
			Context.set_current_feature (current_feature)

				-- `byte_code' is Void if feature has no body, i.e. no contracts
			if byte_code /= Void then
				Context.set_byte_code (byte_code)

				if byte_code.precondition /= Void then
					process_assertion (byte_code.precondition, preconditions, current_feature.written_class.class_id)
				end
				if byte_code.postcondition /= Void then
					process_assertion (byte_code.postcondition, postconditions, current_feature.written_class.class_id)
				end
			end

			Context.inherited_assertion.wipe_out
			if current_feature.assert_id_set /= Void then
				byte_code.formulate_inherited_assertions (current_feature.assert_id_set)
				process_inherited_assertions (Context.inherited_assertion)
			end

-- TODO: reenable
--			generate_invariants

			generate_full_precondition
			generate_full_postcondition

			generate_frame_condition

				-- Restore byte context
			Context.clear_feature_data
			Context.clear_class_type_data
			if l_previous_feature /= Void then
				Context.init (l_previous_feature.written_class.types.first)
				Context.set_current_feature (l_previous_feature)
			end
			if l_previous_byte_code /= Void then
				Context.set_byte_code (l_previous_byte_code)
			end
		end

feature {NONE} -- Implementation

	byte_code: BYTE_CODE
			-- Byte code of `current_feature'

	process_assertion (a_assertion: ASSERTION_BYTE_CODE; a_list: !LIST [TUPLE [tag: STRING; expression: STRING; class_id: INTEGER]]; a_class_id: INTEGER)
			-- Process `a_assertion' and store result in `a_list'.
		require
			a_assertion_not_void: a_assertion /= Void
			valid_class_id: a_class_id > 0
		local
			l_assert: ASSERT_B
		do
			from
				a_assertion.start
			until
				a_assertion.after
			loop
				l_assert ?= a_assertion.item_for_iteration
				check l_assert /= Void end
				expression_writer.reset
				l_assert.expr.process (expression_writer)

				a_list.extend ([l_assert.tag, expression_writer.expression.string, a_class_id, l_assert.line_number])

				extend_frame_condition (expression_writer)

				a_assertion.forth
			end
		end

	process_inherited_assertions (a_list: INHERITED_ASSERTION)
			-- Process inherited assertions
		require
			a_list_not_void: a_list /= Void
		local
			l_last_class_id, l_current_class_id: INTEGER
		do
			-- TODO: check if implicit precondition "True" is in list if a "require else" occurs without a "require" of the parent feature

				-- Feature has defined new preconditions, but has inherited contracts
			has_weakened_preconditions := not preconditions.is_empty
			from
				a_list.precondition_start
			until
				a_list.precondition_after
			loop
					-- If there are preconditions from two different classes, they have to be weakened
				l_current_class_id := a_list.precondition_types.item_for_iteration.associated_class.class_id
				if l_last_class_id /= 0 and then l_last_class_id /= l_current_class_id then
					has_weakened_preconditions := True
				end
				l_last_class_id := l_current_class_id

				process_assertion (
					a_list.precondition_list.item_for_iteration,
					preconditions,
					l_current_class_id)

				a_list.precondition_forth
			end

			from
				a_list.postcondition_start
			until
				a_list.postcondition_after
			loop
				process_assertion (
					a_list.postcondition_list.item_for_iteration,
					postconditions,
					a_list.postcondition_types.item_for_iteration.associated_class.class_id)

				a_list.postcondition_forth
			end
		end

	generate_full_precondition
			-- Generate `full_precondition' from `preconditions'.
		local
			l_current_class_id: INTEGER
		do
				-- TODO: check if preconditions are really sorted by class id (it should be...)
			create full_precondition.make_empty
			if preconditions.is_empty then
				full_precondition.append ("(true)")
			else
				full_precondition.append ("(((")
				from
					preconditions.start
				until
					preconditions.after
				loop
					if l_current_class_id = 0 then
						l_current_class_id := preconditions.item.class_id
					end

					full_precondition.append (preconditions.item.expression)
					preconditions.forth

					if preconditions.after then
						-- Do nothing
					elseif l_current_class_id /= preconditions.item.class_id then
						full_precondition.append (")) || ((")
						l_current_class_id := preconditions.item.class_id
					else
						full_precondition.append (") && (")
					end
				end
				full_precondition.append (")))")
			end
		end

	generate_full_postcondition
			-- Generate `full_postcondition' from `postconditions'.
		do
			create full_postcondition.make_empty
			if postconditions.is_empty then
				full_postcondition.append ("(true)")
			else
				full_postcondition.append ("((")
				from
					postconditions.start
				until
					postconditions.after
				loop
					full_postcondition.append (postconditions.item.expression)
					postconditions.forth
					if not postconditions.after then
						full_postcondition.append (") && (")
					end
				end
				full_postcondition.append ("))")
			end
		end

	generate_invariants
			-- Generate invariants for current feature.
			-- TODO: this is actually per class, we do too much work here.
		local
			l_classes: FIXED_LIST [CLASS_C]
		do
			process_invariants (current_feature.written_class)
			from
				l_classes := current_feature.written_class.parents_classes
				l_classes.start
			until
				l_classes.after
			loop
				process_invariants (l_classes.item)
				l_classes.forth
			end
		end


	process_invariants (a_class: CLASS_C)
			-- Process invariants of `a_class'.
		require
			a_class_not_void: a_class /= Void
		local
			l_list: BYTE_LIST [BYTE_NODE]
			l_assert: ASSERT_B
		do
			if inv_byte_server.has (a_class.class_id) then
				from
					l_list := inv_byte_server.item (a_class.class_id).byte_list
					l_list.start
				until
					l_list.after
				loop
					l_assert ?= l_list.item
					check l_assert /= Void end
					expression_writer.reset
					l_assert.expr.process (expression_writer)

					invariants.extend ([l_assert.tag, expression_writer.expression.string, a_class.class_id, l_assert.line_number])

					l_list.forth
				end
			end
		end

	extend_frame_condition (a_expression_writer: EP_EXPRESSION_WRITER)
			-- TODO
		do
			from
				a_expression_writer.modified_objects.start
			until
				a_expression_writer.modified_objects.after
			loop
				frame_expression.append (" && $o!=" + a_expression_writer.modified_objects.item)
				a_expression_writer.modified_objects.forth
			end
			from
				a_expression_writer.agents_called.start
			until
				a_expression_writer.agents_called.after
			loop
				frame_expression.append (" && !agent.modifies(" + a_expression_writer.agents_called.item + ", $o, $f)")
				a_expression_writer.agents_called.forth
			end
		end

	generate_frame_condition
			-- TODO
		do
			frame_expression.prepend ("(forall $o: ref, $f: name :: { Heap[$o, $f] } ($o != null && old(Heap)[$o, $allocated]")
			frame_expression.append (") ==> (old(Heap)[$o, $f] == Heap[$o, $f]))")
		end

end
