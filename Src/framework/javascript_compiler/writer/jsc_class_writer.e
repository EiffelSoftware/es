note
	description : "Translate a class to JavaScript."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_CLASS_WRITER

inherit
	SHARED_WORKBENCH
		export {NONE} all end

	SHARED_JSC_CONTEXT
		export {NONE} all end

	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize object
		do
			create output.make
			create attribute_writer.make
			create signature_writer.make
			create body_writer.make
			create constant_writer.make
			create instruction_writer.make
			reset ("")
		end

feature -- Access

	output: attached JSC_SMART_BUFFER
			-- Generated JavaScript

	dependencies1: attached SET[INTEGER]
			-- Level 1 dependencies

	dependencies2: attached SET[INTEGER]
			-- Level 2 dependencies

	processed_dependencies: attached JSC_BUFFER_DATA
			-- Dependencies as JavaScript
		local
			l_system: SYSTEM_I
			linear: LINEAR[INTEGER]
			l_class: CLASS_C
			l_class_name: STRING
		do
			l_system := system
			check l_system /= Void end

			output.push ("")
				from
					linear := dependencies1.linear_representation
					linear.start
				until
					linear.after
				loop
					l_class := l_system.class_of_id (linear.item)
					check l_class /= Void end

					l_class_name := l_class.name_in_upper
					check l_class_name /= Void end

					output.put_line ("runtime.require1(%"" + l_class_name + "%");")
					linear.forth
				end

				from
					linear := dependencies2.linear_representation
					linear.start
				until
					linear.after
				loop
					l_class := l_system.class_of_id (linear.item)
					check l_class /= Void end

					l_class_name := l_class.name_in_upper
					check l_class_name /= Void end

					output.put_line ("runtime.require2(%"" + l_class_name + "%");")
					linear.forth
				end

				Result := output.data
			output.pop
		end

feature -- Basic opearation

	process_class (a_class: attached CLASS_C)
			-- Translate `a_class' to JavaScript.
		local
			l_class_name: STRING
		do
			l_class_name := a_class.name_in_upper
			check l_class_name /= Void end

			reset ("")
			is_stub := jsc_context.informer.is_stub (a_class.class_id)
			jsc_context.current_class := a_class

			if not is_stub then
				output.put_comment_line ("DO NOT EDIT: This is a generated file for Eiffel class " + l_class_name)
				output.put_new_line
				pre_process_class (a_class)
				output.indent
			end

			process_features(a_class)

			if not is_stub then
				output.unindent
				output.put_line ("});")
			end
		end

feature {NONE} -- Class Processing

	pre_process_parent_inheritance (a_parent: attached PARENT_AS; a_parent_type: attached CL_TYPE_A): JSC_BUFFER_DATA
			-- Process a single parent inheritance clause: `a_parent'
		local
			l_class_type: CLASS_TYPE_AS
			l_class_name_id: ID_AS
			l_parent_name: STRING
			l_class: CLASS_C
			l_class_name: STRING
			l_rename: RENAME_AS
			l_feature_name: FEATURE_NAME
			l_old_feat_name: STRING
			l_new_feat_name: STRING
			l_str_list: attached LINKED_LIST[attached STRING]
		do
			l_class_type := a_parent.type
			check l_class_type /= Void end

			l_class_name_id := l_class_type.class_name
			check l_class_name_id /= Void end

			l_parent_name := l_class_name_id.name
			check l_parent_name /= Void end

			l_class := a_parent_type.associated_class
			--l_class := jsc_context.informer.find_class_named (l_parent_name.as_upper)
			check l_class /= Void end

			l_class := jsc_context.informer.redirect_class (l_class)

			l_class_name := l_class.name_in_upper
			check l_class_name /= Void end

			if not jsc_context.informer.is_fictive_stub (l_class.class_id) and not l_class.is_class_any then
				output.push (output.indentation)
					output.put_new_line
					output.put_indentation
					output.put ("{class_name:%"")
					output.put (l_class_name)
					output.put ("%"")

					create l_str_list.make
					if attached a_parent.renaming as safe_renaming then
						from
							safe_renaming.start
						until
							safe_renaming.after
						loop
							l_rename := safe_renaming.item
							check l_rename /= Void end

							l_feature_name := l_rename.old_name
							check l_feature_name /= Void end

							l_old_feat_name := l_feature_name.visual_name
							check l_old_feat_name /= Void end

							l_feature_name := l_rename.new_name
							check l_feature_name /= Void end

							l_new_feat_name := l_feature_name.visual_name
							check l_new_feat_name /= Void end

							l_str_list.extend ("%"" + l_old_feat_name + "%": %"" + l_new_feat_name + "%"")
							safe_renaming.forth
						end
					end

					output.put (", renaming: {")
					output.put_list (l_str_list, ",")
					output.put ("}")

					create l_str_list.make
					if attached a_parent.redefining as safe_redefining then
						from
							safe_redefining.start
						until
							safe_redefining.after
						loop
							l_feature_name := safe_redefining.item
							check l_feature_name /= Void end

							l_new_feat_name := l_feature_name.visual_name
							check l_new_feat_name /= Void end

							l_str_list.extend ("%"" + l_new_feat_name + "%"")
							safe_redefining.forth
						end
					end

					output.put (", redefining: [")
					output.put_list (l_str_list, ",")
					output.put ("]")
					output.put ("}")
					Result := output.data
				output.pop
			else
				Result := Void
			end
		end

	pre_process_class (a_class: attached CLASS_C)
			-- Generate the class declaration
		local
			l_system: SYSTEM_I
			l_parent: CL_TYPE_A
			l_class_ast: CLASS_AS
			l_class_name: STRING
			l_parents: LINKED_LIST[attached JSC_BUFFER_DATA]
			l_parent2: PARENT_AS
			l_class: CLASS_C
		do
			l_system := system
			check l_system /= Void end

			l_class_name := a_class.name_in_upper
			check l_class_name /= Void end

			output.put_indentation
			output.put ("var ")
			output.put (l_class_name)
			output.put ("= runtime.declare(%"")
			output.put (l_class_name)
			output.put ("%", [")

			output.indent
			output.indent
			output.indent

				-- Add parents as level1 dependencies & remember fictive parents names
			if attached a_class.parents as safe_parents then
				from
					safe_parents.start
				until
					safe_parents.after
				loop
					l_parent := safe_parents.item
					check l_parent /= Void end

					l_class := l_parent.associated_class
					check l_class /= Void end

					l_class := jsc_context.informer.redirect_class (l_class)

					if not jsc_context.informer.is_fictive_stub (l_class.class_id) and not l_class.is_class_any then
						dependencies1.put (l_class.class_id)
					end

					safe_parents.forth
				end
			end

			l_class_ast := a_class.ast
			check l_class_ast /= Void end

				-- Generate inheritance code
			if attached l_class_ast.parents as safe_parents and then
				attached a_class.parents as safe_parents2 then
				from
					create l_parents.make
					safe_parents.start
					safe_parents2.start
				until
					safe_parents.after
				loop
					l_parent2 := safe_parents.item
					check l_parent2 /= Void end

					if attached pre_process_parent_inheritance (l_parent2, safe_parents2.item) as safe_parent then
						l_parents.extend (safe_parent)
					end
					safe_parents.forth
					safe_parents2.forth
				end
				output.put_data_list (l_parents, ", ")
			end

			output.unindent
			output.unindent
			output.unindent
			output.put ("], {")
			output.put_new_line
			output.put_new_line
		end

	generate_invariant (a_class: attached CLASS_C): attached JSC_BUFFER_DATA
			-- Generate the class invariant associated with `a_class'.
		local
			l_invariant_b: INVARIANT_B
			l_list : BYTE_LIST[BYTE_NODE]
			l_assert: ASSERT_B
			l_parent: CL_TYPE_A
			l_class: CLASS_C
		do
			jsc_context.push_locals
			output.push (output.indentation)
				output.put_indentation
				output.put (jsc_context.name_mapper.invariant_name (a_class.class_id))
				output.put (" : function () {")
				output.put_new_line
				output.indent

					if a_class.inv_byte_server.has (a_class.class_id) then
						l_invariant_b := a_class.inv_byte_server.item (a_class.class_id)
						check l_invariant_b /= Void end

						l_list := l_invariant_b.byte_list
						check l_list /= Void end

						from
							l_list.start
						until
							l_list.after
						loop
							l_assert ?= l_list.item
							check l_assert /= Void end

							jsc_context.name_mapper.push_target_current
								instruction_writer.reset (output.indentation)
								instruction_writer.process_assertion (l_assert.expr, "Invariant", l_assert.tag)
								output.put_data (instruction_writer.output.data)
							jsc_context.name_mapper.pop_target

							l_list.forth
						end
					end

					if attached a_class.parents as safe_parents then
						from
							safe_parents.start
						until
							safe_parents.after
						loop
							l_parent := safe_parents.item
							check l_parent /= Void end

							l_class := l_parent.associated_class
							check l_class /= Void end

							l_class := jsc_context.informer.redirect_class (l_class)

							if not jsc_context.informer.is_stub (l_class.class_id) and not l_class.is_class_any then
								output.put_line ("this." + jsc_context.name_mapper.invariant_name (l_class.class_id) + "();")
							end

							safe_parents.forth
						end
					end

				output.unindent
				output.put_indentation
				output.put ("}")
				Result := output.data
			output.pop
			jsc_context.pop_locals
		end

	generate_deferred (a_class: attached CLASS_C): attached JSC_BUFFER_DATA
			-- Generate the array with the deferred features in this `a_class'.
		local
			l_feature_table: FEATURE_TABLE
			l_feature: FEATURE_I
			l_feature_name: STRING
			l_str_list: LINKED_LIST[attached STRING]
		do
			l_feature_table := a_class.feature_table
			check l_feature_table /= Void end

			from
				create l_str_list.make
				l_feature_table.start
			until
				l_feature_table.after
			loop
				l_feature := l_feature_table.item_for_iteration
				check l_feature /= Void end

				l_feature_name := l_feature.feature_name
				check l_feature_name /= Void end

				if l_feature.is_deferred then
					l_str_list.extend ("%"" + l_feature_name + "%"")
				end

				l_feature_table.forth
			end

			output.push (output.indentation)
				output.put_indentation
				output.put ("$deferred: [")
				output.put_list (l_str_list, ", ")
				output.put ("]")
				Result := output.data
			output.pop
		end

	process_features (a_class: attached CLASS_C)
			-- Process features of class `a_class' written in `a_class'.
		require
			has_feature_table: a_class.has_feature_table
		local
			l_feature_table: FEATURE_TABLE
			l_feature: FEATURE_I
			l_generated_features: LINKED_LIST[attached JSC_BUFFER_DATA]
		do
			l_feature_table := a_class.feature_table
			check l_feature_table /= Void end

			from
				create l_generated_features.make
				l_feature_table.start
			until
				l_feature_table.after
			loop
				l_feature := l_feature_table.item_for_iteration
				check l_feature /= Void end

					-- Only write features which are written in that class
				if l_feature.written_in = a_class.class_id then
					jsc_context.push_feature (l_feature)
					jsc_context.name_mapper.push_target_current

					if l_feature.is_external then
							-- Since external features have no code generated, check them for correctness.
						check_external_feature (l_feature)
					else
						if not is_stub then
							l_generated_features.extend (process_feature (l_feature))
						end
					end

					jsc_context.name_mapper.pop_target
					jsc_context.pop_feature
				end

				l_feature_table.forth
			end

			if not is_stub then
				l_generated_features.extend (generate_deferred (a_class))
				l_generated_features.extend (generate_invariant (a_class))
				output.put_data_list (l_generated_features, ",%N%N")
				output.put_new_line
			end
		end

feature {NONE} -- Feature Processing

	check_external_feature (a_feature: attached FEATURE_I)
			-- Validate an external feature (a stub)
		local
			l_external_name: STRING
			l_arg_name, l_arg_name2: STRING
			len: INTEGER
			l_test_result: STRING
			i, j: INTEGER
		do
			l_external_name := a_feature.external_name
			check l_external_name /= Void end

			create l_test_result.make_from_string (l_external_name)
			if attached a_feature.arguments as safe_args then
				from
					i := safe_args.lower
				until
					i > safe_args.upper
				loop
					l_arg_name := safe_args.item_name (i)
					check l_arg_name /= Void end

					if not l_test_result.has_substring ("$" + l_arg_name) then
						jsc_context.add_warning ("Possible malformed external",
							"Reason: The argument `" + l_arg_name + "' doesn't appear in external or another argument is a prefix of it.")
					end

					l_test_result.replace_substring_all ("$" + l_arg_name, i.out)
					i := i + 1
				end
			end

			l_test_result.replace_substring_all ("$TARGET", "TARGET")

			if l_test_result.index_of ('$', 1) /= 0 then
				jsc_context.add_warning ("Possible malformed external", "What to do: Make sure the external `" + l_external_name + "'%N" +
					"  is correct")
			end

				-- Arguments should not be prefixes of other arguments
			if attached a_feature.arguments as safe_args then
				from
					i := safe_args.lower
				until
					i > safe_args.upper
				loop
					l_arg_name := safe_args.item_name (i)
					check l_arg_name /= Void end
					len := l_arg_name.count

					from
						j := i + 1
					until
						j > safe_args.upper
					loop
						l_arg_name2 := safe_args.item_name (j)
						check l_arg_name2 /= Void end

						if l_arg_name.substring (1, l_arg_name2.count) ~ l_arg_name2 or l_arg_name2.substring (1, len) ~ l_arg_name then
							jsc_context.add_warning ("Bad parameter names for external feature",
								"What to do: Rename `"+l_arg_name+"' or `"+l_arg_name2+"'; one is not allowed to be a prefix of the other.")
						end

						j := j + 1
					end
					i := i + 1
				end
			end
		end

	process_feature (a_feature: attached FEATURE_I): attached JSC_BUFFER_DATA
			-- Generate code for `a_feature'
		local
			l_feature_name: STRING
			l_constant: CONSTANT_I
			l_value: VALUE_I
		do
			output.push (output.indentation)
				if a_feature.is_attribute then
					attribute_writer.reset (output.indentation)
					attribute_writer.write_attribute (a_feature)
					output.put_data (attribute_writer.output.data)

				elseif a_feature.is_constant then
					l_feature_name := a_feature.feature_name
					check l_feature_name /= Void end

					output.put_indentation
					output.put (l_feature_name)
					output.put (": ")

					l_constant ?= a_feature
					check l_constant /= Void end

					l_value := l_constant.value
					check l_value /= Void end

					output.put (constant_writer.process (l_value))

				else
					signature_writer.reset (output.indentation)
					signature_writer.write_feature_declaration (a_feature)
					output.put_data (signature_writer.output.data)

					output.put (" {")
					output.put_new_line
					output.indent

					if a_feature.is_once then
						output.indent
						output.put_line ("if (!$executed) {")
						output.indent
					end

					body_writer.reset (output.indentation)
					body_writer.write_feature_body (a_feature)

					if a_feature.is_once then
						output.put_line ("$executed = true;")

						output.put_data (body_writer.output.data)

						output.unindent
						output.put_line ("}")
						output.put_line ("return $cached;")
						output.unindent
						output.put_line ("};")
					else
						output.put_data (body_writer.output.data)
					end

					dependencies1.fill (body_writer.dependencies1)
					dependencies2.fill (body_writer.dependencies2)

					output.unindent
					output.put_indentation
					output.put ("}")

					if a_feature.is_once then
						output.put ("())")
					end
				end
				Result := output.data
			output.pop
		end

feature {NONE} -- Implementation

	attribute_writer: attached JSC_ATTRIBUTE_WRITER
	signature_writer: attached JSC_SIGNATURE_WRITER
	body_writer: attached JSC_BODY_WRITER
	constant_writer: attached JSC_CONSTANT_WRITER
	instruction_writer: attached JSC_INSTRUCTION_WRITER

	is_stub: BOOLEAN
			-- Is current class being translated a stub

	reset (a_indentation: attached STRING)
		do
			output.reset (a_indentation)
			create {LINKED_SET[INTEGER]}dependencies1.make
			create {LINKED_SET[INTEGER]}dependencies2.make
			is_stub := false
		end

end
