indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_GENERATOR

inherit {NONE}

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize generator.
		do
			create output_buffer.make

			create attribute_writer
			create constant_writer
			create signature_writer.make
			create implementation_writer.make
		end

feature -- Access

	output_buffer: !EP_OUTPUT_BUFFER
			-- Output buffer to store generated code

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
			put_comment_line ("Feature " + a_feature.feature_name + " from class " + a_feature.written_class.name_in_upper)
			put_comment_line ("--------------------------------------")
			put_new_line

			if a_feature.is_attribute then
					-- Generate field name, function and axiom
				attribute_writer.write_attribute (a_feature)

					-- Generate signature
				signature_writer.write_attribute_signature (a_feature)
			elseif a_feature.is_constant then
					-- Generate function and axiom
				constant_writer.write_constant (a_feature)
			else
				if a_feature.type.is_void then
						-- It's a query, so generate functional representation
					-- TODO
				end

					-- Generate signature
				signature_writer.write_feature_signature (a_feature)

					-- Generate implementation
					-- TODO: make this check look nicer
				if verify_value_in_indexing (a_feature.written_class.ast.feature_with_name (a_feature.feature_name_id).indexes) then
					implementation_writer.write_feature_implementation (a_feature)
				else
					put_comment_line ("Implementation ignored due to indexing clause")
				end
			end
			put_new_line

			feature_list.mark_feature_generated (a_feature)
		ensure
			feature_not_needed: not feature_list.features_needed.has (a_feature)
			feature_generated: feature_list.features_generated.has (a_feature)
		end

	process_creation_routine (a_feature: !FEATURE_I)
			-- Generate code for creation routine `a_feature'.
		do
			put_comment_line ("Creation routine " + a_feature.feature_name + " from class " + a_feature.written_class.name_in_upper)
			put_comment_line ("--------------------------------------")
			put_new_line

				-- Generate signature
			signature_writer.write_creation_routine_signature (a_feature)
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
				l_attached_feature ?= l_feature
				check l_feature /= Void end

				process_creation_routine (l_attached_feature)

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
				l_attached_feature ?= l_feature
				check l_feature /= Void end

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
