note
	description : "Compile Eiffel source code to JavaScript source code"
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JAVASCRIPT_COMPILER

inherit
	SHARED_SERVER
		export {NONE} all end

	SHARED_JSC_ENVIRONMENT
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
			create {LINKED_LIST[attached CLASS_C]} classes_to_compile.make
			create {LINKED_SET[INTEGER]}classes_to_compile_set.make
			create class_writer.make
			create runtime_dispatch_writer.make
		ensure
			empty: classes_to_compile.is_empty
		end

feature -- Access

	classes_to_compile: attached LIST [attached CLASS_C]
		-- Classes which will be compiled

	classes_to_compile_set: attached SET [INTEGER]
		-- Classes which will be compiled as a set

feature -- Operations

	reset
			-- Reset state
		do
			classes_to_compile.wipe_out
			classes_to_compile_set.wipe_out
		ensure
			empty: classes_to_compile.is_empty
		end

	is_added (a_class: attached CLASS_C): BOOLEAN
			-- Is `a_class' already added to be compiled?
		do
			Result := classes_to_compile_set.has (a_class.class_id)
		end

	add_class_to_compile (a_class: attached CLASS_C)
			-- Add `a_class' as a class to be compiled
		require
			not_added_alreay: not is_added (a_class)
		do
			if not classes_to_compile_set.has (a_class.class_id) then
				classes_to_compile.extend (a_class)
				classes_to_compile_set.extend (a_class.class_id)
			end
		ensure
			extended: classes_to_compile.count = old (classes_to_compile.count) + 1
		end

	register_message_callbacks (a_output, a_window: PROCEDURE [ANY, TUPLE [STRING]])
			-- Register callback functions to receive messages.
		do
			output_callback := a_output
			window_callback := a_window
		end

	execute_compilation
			-- Compile all the classes to JavaScript
		local
			i: INTEGER
			l_system: SYSTEM_I
			l_class: CLASS_C
			l_current_class: CLASS_C
			l_current_class_name: STRING
			compiled_classes: HASH_TABLE[attached JSC_BUFFER_DATA, INTEGER]
			dependencies_count: HASH_TABLE[INTEGER, INTEGER]
			inverse_dependencies: HASH_TABLE[attached SET[INTEGER], INTEGER]
			linear: LINEAR[INTEGER]
			l_set: SET[INTEGER]
		do
			errors.wipe_out
			warnings.wipe_out

			l_system := system
			check l_system /= Void end

			put_output_message ("Generating JavaScript")

				-- Iterate over all classes and find "special" Eiffel classes (a.k.a Stubs)
			put_window_message ("Finding JavaScript Stubs")
			find_javascript_stubs

				-- Iterate over the ancesters of Eiffel Base classes which will
				-- be translated into native JavaScript types
			mark_native_class_parents (<< "CHARACTER_8", "CHARACTER_32", "INTEGER_8",
				"INTEGER_16", "INTEGER_32", "INTEGER_64", "REAL_32", "REAL_64",
				"STRING_8", "STRING_32", "ARRAY", "TUPLE" >>)

			runtime_dispatch_writer.generate_runtime_dispatch
			write_runtime_dispatch

				-- Compile all & keep track of dependencies
			from
				create compiled_classes.make (classes_to_compile.count)
				create inverse_dependencies.make (classes_to_compile.count)
				create dependencies_count.make (classes_to_compile.count)
				classes_to_compile.start
				i := 1
			until
				classes_to_compile.after
			loop
				l_current_class := classes_to_compile.item

				l_current_class_name := l_current_class.name_in_upper
				check l_current_class_name /= Void end

				put_window_message ("Compiling class " + i.out + "/" + classes_to_compile.count.out + ": " + l_current_class_name)

					-- Process class
				class_writer.process_class (l_current_class)

				if not jsc_context.informer.is_stub (l_current_class.class_id) then
						-- Write resulting JavaScript to a file
					write_one_class (l_current_class)

					compiled_classes[l_current_class.class_id] := class_writer.output.data
					dependencies_count[l_current_class.class_id] := class_writer.dependencies1.count

						-- Record inverse arcs for level 1 dependencies
					from
						linear := class_writer.dependencies1.linear_representation
						linear.start
					until
						linear.after
					loop
						l_class := l_system.class_of_id (linear.item)
						check l_class /= Void end

						if jsc_context.informer.is_eiffel_base_class (l_class) then
							dependencies_count[l_current_class.class_id] := dependencies_count[l_current_class.class_id] - 1
						else
							if not classes_to_compile_set.has (linear.item) then
								classes_to_compile.extend (l_class)
								classes_to_compile_set.extend (l_class.class_id)
							end

							if not inverse_dependencies.has (linear.item) then
								create {LINKED_SET[INTEGER]}l_set.make
								inverse_dependencies[linear.item] := l_set
							end

							l_set := inverse_dependencies[linear.item]
							check l_set /= Void end

							l_set.extend (l_current_class.class_id)
						end



						linear.forth
					end

					from
						linear := class_writer.dependencies2.linear_representation
						linear.start
					until
						linear.after
					loop
						l_class := l_system.class_of_id (linear.item)
						check l_class /= Void end

						if not jsc_context.informer.is_eiffel_base_class (l_class) then
							if not classes_to_compile_set.has (linear.item) then
								l_class := l_system.class_of_id (linear.item)
								check l_class /= Void end

								classes_to_compile.extend (l_class)
								classes_to_compile_set.extend (l_class.class_id)
							end
						end

						linear.forth
					end
				end

				classes_to_compile.forth
				i := i + 1
			end

			put_window_message ("Writing all to single file")
				-- Write all the compiled classes to a single file
			write_all (compiled_classes, dependencies_count, inverse_dependencies)

			put_output_message ("JavaScript compilation finished.")
			put_window_message ("JavaScript compilation finished.")
		end

feature {NONE} -- Implementation

	class_writer: attached JSC_CLASS_WRITER
			-- Compiles one class at a time to JavaScript

	runtime_dispatch_writer: attached JSC_RUNTIME_DISPATCH_WRITER
			-- Generates the runtime dispatch

	find_javascript_stubs
			-- Iterate over all classes & populate the `jsc_context' with the "special" ones
		local
			l_system: SYSTEM_I
			l_classes: CLASS_C_SERVER
			l_class_name: STRING
			l_class_ast: CLASS_AS
			i: INTEGER
			l_javascript_native_name: STRING
			l_eiffel_base_classes: STRING
		do
			jsc_context.informer.reset

			l_system := system
			check l_system /= Void end

			l_classes := l_system.classes
			check l_classes /= Void end

			from
				i := l_classes.lower
			until
				i >= l_classes.upper
			loop
				if attached l_classes.item (i) as safe_class then
					l_class_name := safe_class.name_in_upper
					check l_class_name /= Void end

					l_class_ast := safe_class.ast
					check l_class_ast /= Void end

					if attached l_class_ast.top_indexes as safe_top_indexes
						and then attached extract_string_value (safe_top_indexes, "javascript") as safe_javascript_note then

						if safe_javascript_note.starts_with ("NativeStub:") then
								-- This is a native stub with a qualified name of the native JavaScript class
								-- E.g. Eiffel Class JS_HTML_DIV_ELEMENT has a note javascript:"NativeStub:HtmlDivElement"
								--   * clients of this class will not require this class (there is no file -- it is native)
								--   * no JavaScript file/code will be generated for this class
								--   * object tests will be translated to native JavaScript instanceof
							l_javascript_native_name := safe_javascript_note.substring (12, safe_javascript_note.count)
							jsc_context.informer.add_native_stub (safe_class.class_id, l_javascript_native_name)

						elseif safe_javascript_note.is_equal ("NativeStub") then
								-- This is a native stub without a qualified name of the native JavaScript class
								-- It could be some sort of "placehoder" for external JavaScript.
								--   * clients of this class will not require this class (there is no file)
								--   * no JavaScript file/code will be generated for this class
								--   * object tests will not work with this classes
							jsc_context.informer.add_fictive_stub (safe_class.class_id)

						elseif safe_javascript_note.is_equal ("Stub") then
								-- This is a stub for an existing (user-written) JavaScript class
								--   * clients of this class *will* require this class
								--   * no JavaScript file/code will be generated for this class
								--   * object tests *should* work with this class
							jsc_context.informer.add_stub (safe_class.class_id)

						elseif safe_javascript_note.starts_with ("EiffelBaseNativeStub:") then
								-- This is a stub for an Eiffel Base class which will become a native JavaScript type
								--   * clients of this class will not require this class
								--   * no JavaScript file/code will be generated for this class
								--   * object tests: handled by runtime, *should* work
								--   * EiffelBase feature calls will be redirected to this class
							l_eiffel_base_classes := safe_javascript_note.substring (22, safe_javascript_note.count)
							jsc_context.informer.add_eiffel_base_redirect (l_class_name, l_eiffel_base_classes.split (','))
							jsc_context.informer.add_fictive_stub (safe_class.class_id)

						elseif safe_javascript_note.starts_with ("EiffelBase:") then
								-- This is a stub for an Eiffel Base class
								--   * clients of this class *will* require this class
								--   * a JavaScript file with the code will be generated for this class
								--   * object tests should work: ???
								--   * EiffelBase feature calls will be redirected to this class
							l_eiffel_base_classes := safe_javascript_note.substring (12, safe_javascript_note.count)
							jsc_context.informer.add_eiffel_base_redirect (l_class_name, l_eiffel_base_classes.split (','))

						end

							-- Add all fictive stubs to be compiled (actually for their externals to be verified)
						if jsc_context.informer.is_fictive_stub (safe_class.class_id) then
							if not is_added (safe_class) then
								add_class_to_compile (safe_class)
							end
						end
					end
				end
				i := i + 1
			end
		end

	extract_string_value (indexing_clause: attached INDEXING_CLAUSE_AS; tag: attached READABLE_STRING_GENERAL): detachable STRING
			-- Extract string associated with `tag'
			-- Void if not a string or not tag `tag'
		require
			not_tag_is_empty: not tag.is_empty
		local
			i: INDEX_AS
			index_list: EIFFEL_LIST [ATOMIC_AS]
			s: STRING_AS
			s_value: STRING
			is_first: BOOLEAN
		do
			i := indexing_clause.index_as_of_tag_name (tag)

			if i /= Void then
				index_list := i.index_list
				check index_list /= Void end

				create Result.make (20)
				from
					index_list.start
					is_first := true
				until
					index_list.after
				loop
					s ?= index_list.item

					if s /= Void then
						if is_first then
							is_first := false
						else
							Result.append (", ")
						end

						s_value := s.value
						check s_value /= Void end

						Result.append (s_value)
					end

					index_list.forth
				end
			end
		end


feature {NONE} -- Native classes parents

	mark_native_class_parents (native_types: attached ARRAY[attached STRING])
			-- Walk inheritance tree up starting at `native_types' and mark found classes.
		local
			l_system: SYSTEM_I
			l_classes: CLASS_C_SERVER
			l_class_name: STRING
			i: INTEGER
			l_native_types: attached SET[attached STRING]
		do
			from
				create {LINKED_SET[attached STRING]}l_native_types.make
				l_native_types.compare_objects
				i := native_types.lower
			until
				i >= native_types.upper
			loop
				l_native_types.put (native_types[i])
				i := i + 1
			end

			l_system := system
			check l_system /= Void end

			l_classes := l_system.classes
			check l_classes /= Void end

			from
				i := l_classes.lower
			until
				i >= l_classes.upper
			loop
				if attached l_classes.item (i) as safe_class then
					l_class_name := safe_class.name_in_upper
					check l_class_name /= Void end

					if l_native_types.has (l_class_name) then
						mark_up (safe_class)
					end
				end

				i := i + 1
			end
		end

	mark_up (a_class: attached CLASS_C)
			-- Walk inheritance tree up starting at `a_class' and mark found classes.
		local
			l_parent: CL_TYPE_A
			l_parent_class: CLASS_C
		do
			if attached a_class.parents as safe_parents then
				from
					safe_parents.start
				until
					safe_parents.after
				loop
					l_parent := safe_parents.item
					check l_parent /= Void end

					l_parent_class := l_parent.associated_class
					check l_parent_class /= Void end

					jsc_context.informer.add_ancestor_of_native_type (l_parent.class_id)
					mark_up (l_parent_class)

					safe_parents.forth
				end
			end
		end

feature {NONE} -- Implementation

	output_callback: PROCEDURE [ANY, TUPLE [STRING]]
			-- Callback function for output panel

	window_callback: PROCEDURE [ANY, TUPLE [STRING]]
			-- Callback function for status bar

	put_output_message (a_string: STRING)
			-- Put `a_string' to output.
		do
			if attached output_callback as safe_output_callback then
				safe_output_callback.call ([a_string])
			end
		end

	put_window_message (a_string: STRING)
			-- Put `a_string' to status bar.
		do
			if attached window_callback as safe_window_callback then
				safe_window_callback.call ([a_string])
			end
		end


feature {NONE} -- Write to HDD

	write_runtime_dispatch
		local
			l_dir: DIRECTORY
			l_output_file: PLAIN_TEXT_FILE
		do
			create l_dir.make (output_folder)
			if not l_dir.exists then
				l_dir.create_dir
			end

			create l_output_file.make_open_write (runtime_dispatch_file_name)
			l_output_file.put_string (runtime_dispatch_writer.output.force_string)
			l_output_file.close
		end

	write_one_class (a_class: attached CLASS_C)
			-- Write `a_class' to file, using `class_writer'.
		local
			l_dir: DIRECTORY
			l_output_file: PLAIN_TEXT_FILE
		do
			create l_dir.make (output_folder)
			if not l_dir.exists then
				l_dir.create_dir
			end

			create l_output_file.make_open_write (one_class_file_name (a_class))
			l_output_file.put_string (class_writer.processed_dependencies.force_string)
			l_output_file.put_string (class_writer.output.force_string)
			l_output_file.close
		end

	write_all (	compiled_classes: attached HASH_TABLE[attached JSC_BUFFER_DATA, INTEGER];
				dependencies_count: attached HASH_TABLE[INTEGER, INTEGER];
				inverse_dependencies: attached HASH_TABLE[attached SET[INTEGER], INTEGER])
			-- Write all classes to a file, sorting them by dependency.
		local
			l_dir: DIRECTORY
			l_output_file: PLAIN_TEXT_FILE
			written: LINKED_SET[INTEGER]
			i, class_to_write_id, class_id: INTEGER
			class_to_write: JSC_BUFFER_DATA
			linear: LINEAR[INTEGER]
			inverse_dependency: SET[INTEGER]
		do
			create l_dir.make (output_folder)
			if not l_dir.exists then
				l_dir.create_dir
			end

			create l_output_file.make_open_write (all_file_name)

			l_output_file.put_string (runtime_dispatch_writer.output.force_string)

				-- Generate one humongous js file, containing all the compiled classes, in proper order
			from
				create written.make
				i := 1
			until
				i > compiled_classes.count
			loop
				-- Pick a class with no dependencies
				from
					compiled_classes.start
					class_to_write_id := 0
				until
					compiled_classes.after
				loop
					class_id := compiled_classes.key_for_iteration
					if not written.has (class_id) then
						if dependencies_count[class_id] = 0 then
							class_to_write_id := class_id
						elseif class_to_write_id = 0 then
							class_to_write_id := class_id
						end
					end

					compiled_classes.forth
				end

				class_to_write := compiled_classes[class_to_write_id]
				check class_to_write /= Void end

					-- Write class
				l_output_file.put_string (class_to_write.force_string)
				l_output_file.put_string ("%N%N%N")
				written.put (class_to_write_id)

					-- Subtract dependencies
				if inverse_dependencies.has (class_to_write_id) then
					from
						inverse_dependency := inverse_dependencies[class_to_write_id]
						check inverse_dependency /= Void end

						linear := inverse_dependency.linear_representation
						linear.start
					until
						linear.after
					loop

						dependencies_count [linear.item] := dependencies_count [linear.item] - 1

						linear.forth
					end
				end


				i := i + 1
			end

			l_output_file.close
		end

	output_folder: attached STRING
			-- Path name to the output folder
		local
			l_output_path: FILE_NAME
		do
			create l_output_path.make_from_string (project_target_path)
			l_output_path.extend ("JavaScript")
			Result := l_output_path
		end

	one_class_file_name (a_class: attached CLASS_C): attached STRING
			-- Path name to the file for `a_class'.
		local
			l_output_path: FILE_NAME
			l_class_name: STRING
		do
			l_class_name := a_class.name_in_upper
			check l_class_name /= Void end

			create l_output_path.make_from_string (project_target_path)
			l_output_path.extend ("JavaScript")
			l_output_path.extend (l_class_name + ".js")
			Result := l_output_path
		end

	runtime_dispatch_file_name: attached STRING
			-- Path name to the file for the runtime dispatch.
		local
			l_output_path: FILE_NAME
		do
			create l_output_path.make_from_string (project_target_path)
			l_output_path.extend ("JavaScript")
			l_output_path.extend ("runtime_dispatch.js")
			Result := l_output_path
		end

	all_file_name: attached STRING
			-- Path name to the file for all classes.
		local
			l_output_path: FILE_NAME
		do
			create l_output_path.make_from_string (project_target_path)
			l_output_path.extend ("JavaScript")
			l_output_path.extend ("all.js")
			Result := l_output_path
		end

	project_target_path: attached STRING
			-- Path name to the target of current project
		local
			l_system: SYSTEM_I
			l_project: E_PROJECT
			l_project_directory: PROJECT_DIRECTORY
			l_dir_name: DIRECTORY_NAME
		do
			l_system := system
			check l_system /= Void end

			l_project := l_system.eiffel_project
			check l_project /= Void end

			l_project_directory := l_project.project_directory
			check l_project_directory /= Void end

			l_dir_name := l_project_directory.target_path
			check l_dir_name /= Void end

			Result := l_dir_name
		end

end
