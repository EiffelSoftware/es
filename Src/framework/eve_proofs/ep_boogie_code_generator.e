indexing
	description:
		"[
			Boogie code generation.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_BOOGIE_CODE_GENERATOR

inherit

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	SHARED_EP_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize generator.
		do
			create output_buffer.make
			is_generating_implementation := True

			create attribute_writer
			create constant_writer
			create signature_writer.make
			create function_writer.make
			create implementation_writer.make
		end

feature -- Access

	output_buffer: !EP_OUTPUT_BUFFER
			-- Output buffer to store generated code

feature -- Status report

	is_generating_implementation: BOOLEAN
			-- Is implementation for features generated?

feature -- Status setting

	generate_implementation
			-- Generate implementation for processed features.
		do
			is_generating_implementation := True
		ensure
			is_generating_implementation: is_generating_implementation
		end

	omit_implementation
			-- Omit implementation for processed features.
		do
			is_generating_implementation := False
		ensure
			not_is_generating_implementation: not is_generating_implementation
		end

feature -- Basic operations

	reset
			-- Reset code generator.
		do
			output_buffer.reset
			environment.set_output_buffer (output_buffer)
		end

	process_class (a_class: !CLASS_C)
			-- Generate code for `a_class'.
		do
				-- Inheritance relation
			-- TODO

				-- Creation routines
			if a_class.creators /= Void then
				process_creation_routines (a_class)
			end

				-- Normal features
			if a_class.has_feature_table then
				process_features (a_class)
			end
		end

	process_feature (a_feature: !FEATURE_I)
			-- Generate code for `a_feature'.
		do
			ep_context.set_current_class (a_feature.written_class)
			ep_context.set_current_feature (a_feature)
			ep_context.set_location (a_feature.body.start_location)

			put_comment_line ("Feature " + a_feature.feature_name + " from class " + a_feature.written_class.name_in_upper)
			put_comment_line ("--------------------------------------")
			put_new_line

			if a_feature.is_attribute then
					-- Generate field name
				attribute_writer.write_attribute (a_feature)

			elseif a_feature.is_constant then
					-- Generate function and axiom
				constant_writer.write_constant (a_feature)

			else
				if a_feature.has_return_value and then feature_list.is_pure (a_feature) then
						-- It's a pure function, so generate functional representation
					function_writer.write_functional_representation (a_feature)
				end

					-- Generate signature
				signature_writer.write_feature_signature (a_feature)

					-- Generate implementation
				if is_generating_implementation then
					if feature_list.is_creation_routine_already_generated (a_feature) then
						put_comment_line ("Implementation already done for feature as creation routine")
					elseif is_feature_proof_done (a_feature) then
						implementation_writer.write_feature_implementation (a_feature, False)
					else
						event_handler.add_proof_skipped_event (a_feature.written_class, a_feature)
						put_comment_line ("Implementation ignored (proof skipped)")
					end
				end
			end
			put_new_line

			feature_list.mark_feature_generated (a_feature)
		ensure
			feature_not_needed: not feature_list.features_needed.has (a_feature)
			feature_generated: feature_list.features_generated.has (a_feature)
		end

	process_creation_routine (a_feature: !FEATURE_I)
			-- Generate code for creation routine `a_feature' for creation of class `a_class'.
		do
			ep_context.set_current_class (a_feature.written_class)
			ep_context.set_current_feature (a_feature)
			ep_context.set_location (a_feature.body.start_location)

			put_comment_line ("Creation routine " + a_feature.feature_name + " from class " + a_feature.written_class.name_in_upper)
			put_comment_line ("--------------------------------------")
			put_new_line

				-- Generate signature
			signature_writer.write_creation_routine_signature (a_feature)

				-- Generate implementation
			if is_generating_implementation then
				if is_feature_proof_done (a_feature) then
					implementation_writer.write_feature_implementation (a_feature, True)
				else
					event_handler.add_proof_skipped_event (a_feature.written_class, a_feature)
					put_comment_line ("Implementation ignored (proof skipped)")
				end
			end

			put_new_line

			feature_list.mark_creation_routine_as_generated (a_feature)
		ensure
			feature_not_needed: not feature_list.creation_routines_needed.has (a_feature)
			feature_generated: feature_list.creation_routines_generated.has (a_feature)
		end

feature {NONE} -- Implementation

	attribute_writer: !EP_ATTRIBUTE_WRITER
			-- Writer to produce code for attributes

	constant_writer: !EP_CONSTANT_WRITER
			-- Writer to procude code for constants

	signature_writer: !EP_SIGNATURE_WRITER
			-- Writer to procduce feature signatures

	function_writer: !EP_FUNCTION_WRITER
			-- Writer to produce functional feature representation

	implementation_writer: !EP_IMPLEMENTATION_WRITER
			-- Writer to procduce feature implementations

	process_creation_routines (a_class: !CLASS_C)
			-- Process creation routines of class `a_class'.
		require
			creators_not_void: a_class.creators /= Void
		local
			l_creator_name: STRING
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
		do
			from
				a_class.creators.start
			until
				a_class.creators.after
			loop
				l_creator_name := a_class.creators.key_for_iteration

				l_feature := a_class.feature_named (l_creator_name)
				check l_feature /= Void end
				l_attached_feature := l_feature

					-- Check if creation routine is not yet generated. This can happen if a subclass
					-- uses the same feature as a creation routine as the parent.
				if not feature_list.is_creation_routine_already_generated (l_attached_feature) then
					process_creation_routine (l_attached_feature)
				end

				a_class.creators.forth
			end
		end

	process_features (a_class: !CLASS_C)
			-- Process features of class `a_class'.
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
					process_feature (l_attached_feature)
				else
					-- commented out as this gives to much unnecessary output
					--put_comment_line ("ignored " + l_feature.feature_name)
				end

				a_class.feature_table.forth
			end
		end

end
