note
	description : "Generate the runtime dispatch for feature calls."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_RUNTIME_DISPATCH_WRITER

inherit
	SHARED_JSC_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize object
		do
			create output.make
		end

feature -- Access

	output: attached JSC_SMART_BUFFER
			-- Generated JavaScript

feature -- Basic Operation

	generate_runtime_dispatch
		local
			l_tests: LINKED_LIST[attached JSC_BUFFER_DATA]
		do
			output.reset("")
			output.put_line ("runtime.special_dispatch = function (obj, full_feature_name, feature_name) {")
			output.indent
			output.put_line ("var args = Array.prototype.slice.apply(arguments, [3]);")

			create l_tests.make
			l_tests.extend (write_class("BOOLEAN", "typeof obj === %"boolean%""))
			l_tests.extend (write_class("STRING", "typeof obj === %"string%""))
			l_tests.extend (write_class("INTEGER", "typeof obj === %"number%" && parseInt(obj) === obj"))
			l_tests.extend (write_class("REAL", "typeof obj === %"number%""))
			l_tests.extend (write_class("ARRAY", "obj instanceof Array"))

			output.put_indentation
			output.put_data_list (l_tests, " else ")
			output.put_new_line

			output.put_line ("return obj[full_feature_name].apply(obj, args);")

			output.unindent
			output.put_line ("};")
		end

feature {NONE} -- Implementation

	write_class (a_class_name, a_obj_test: attached STRING): attached JSC_BUFFER_DATA
		local
			l_class_name: STRING
			l_class: CLASS_C
		do
			output.push (output.indentation)
				l_class_name := jsc_context.informer.eiffel_base_redirect_to (a_class_name)
				l_class := jsc_context.informer.find_class_named(l_class_name)

				output.put ("if (")
				output.put (a_obj_test)
				output.put (") {")
				output.put_new_line
				output.indent

				if attached l_class as safe_class then

					write_features (safe_class)
						-- If falled through ifs => missing feature
					output.put_line ("throw %"Missing EiffelBase feature equivalent of %" + feature_name + %" in " + l_class_name + "%";")

				else
						-- If class not found => missing class
					jsc_context.add_error ("Missing EiffelBase class equivalent: " + l_class_name, "What to do: Make sure you have a class named " + l_class_name + "%N" +
							"  in your universe -- representing the equivalent of " + a_class_name)
					output.put_line ("throw %"Missing EiffelBase class equivalent: " + l_class_name + " for " + a_class_name + "%";")
				end

				output.unindent
				output.put_indentation
				output.put ("}")

				Result := output.data
			output.pop
		end

	write_features (a_class: attached CLASS_C)
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
					l_generated_features.extend (write_feature(l_feature))
				end

				l_feature_table.forth
			end

			if not l_generated_features.is_empty then
				output.put_indentation
				output.put_data_list (l_generated_features, " else ")
				output.put_new_line
			end
		end

	write_feature (a_feature: attached FEATURE_I): attached JSC_BUFFER_DATA
		local
			l_template: attached STRING
			l_feature_name: STRING_32
			l_feature_arguments: LIST[attached STRING]
			l_feature_external_name: STRING
			is_static: BOOLEAN
			i: INTEGER
			l_argument: STRING
		do
			output.push (output.indentation)
				output.put ("if (feature_name === %"")
				l_feature_name := a_feature.feature_name_32
				check l_feature_name /= Void end
				output.put (l_feature_name)
				output.put ("%") {")
				output.put_new_line
				output.indent

					output.put_indentation
					output.put ("return ")

					is_static := false
					l_feature_external_name := a_feature.external_name
					check l_feature_external_name /= Void end
					create l_template.make_from_string (l_feature_external_name)

						-- If the template starts with #, a static call should be made
					if l_template.starts_with ("#") then
						l_template := l_template.substring (2, l_template.count)
						is_static := true
					end

						-- If the template contains the $TARGET, a static call should be made
					if l_template.substring_index ("$TARGET", 1) > 0 then
						l_template.replace_substring_all ("$TARGET", "obj")
						is_static := true
					end

					if not is_static then
						output.put ("obj")
						if not l_template.starts_with ("[") then
							output.put (".")
						end
					end

					if attached a_feature.arguments as safe_feature_arguments then
							-- Fill in the argument names
						from
							create {LINKED_LIST[attached STRING]}l_feature_arguments.make
							i := safe_feature_arguments.lower
						until
							i > safe_feature_arguments.upper
						loop
							l_argument := safe_feature_arguments.item_name (i)
							check l_argument /= Void end

							l_feature_arguments.extend ("$" + l_argument)
							i := i + 1
						end

						process_template_replace (l_template, l_feature_arguments)
					else
							-- No replacing is needed
						output.put (l_template)
					end

					output.put (";")
					output.put_new_line

				output.unindent
				output.put_indentation
				output.put ("}")

				Result := output.data
			output.pop
		end

	process_template_replace (a_template: attached STRING; a_keys: attached LIST[attached STRING])
			-- Replace `a_keys' with `a_values' in `a_template'.
		local
			l_result: attached STRING
			i: INTEGER
		do
			from
				create l_result.make_from_string (a_template)
				a_keys.start
				i := 0
			until
				a_keys.after
			loop
				l_result.replace_substring_all (a_keys.item, "args["+i.out+"]")
				a_keys.forth
				i := i + 1
			end

			output.put (l_result)
		end

end
