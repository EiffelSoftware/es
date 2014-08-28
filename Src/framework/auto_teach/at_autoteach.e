note
	description: "AutoTeach main class."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_AUTOTEACH

inherit

	SHARED_WORKBENCH

	SHARED_SERVER

	AT_COMMON

create
	make_with_options

feature {NONE} -- Initialization

	make_with_options (a_options: AT_OPTIONS)
			-- Initialization for `Current'.
		do
			options := a_options
			create input_classes.make

			create ast_iterator.make_with_options (options)
			ast_iterator.set_message_output_action (agent print_message)
		end

feature -- Interface

	add_class (a_class: CONF_CLASS)
			-- Add class `a_class'.
		do
			if attached {EIFFEL_CLASS_I} a_class as l_eiffel_class and then attached l_eiffel_class.compiled_class as l_compiled then
				input_classes.extend (l_compiled)
			else
				print_message (at_strings.error + ": " + at_strings.init_class_not_compiled (a_class.name))
			end
		end

	set_message_output_action (a_action: PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]])
			-- Set `a_action' as the action to be called for outputting messages.
		do
			message_output_action := a_action
		end

	run_autoteach
			-- Run autoteach.
		local
			l_out_file: PLAIN_TEXT_FILE
			l_output_path: PATH
			l_dir: DIRECTORY
			l_io: BOOLEAN
			l_level: NATURAL
		do
			if not l_io then
				l_io := True
				if not options.output_directory.exists then
					options.output_directory.recursive_create_dir
				end
				if not options.output_directory.is_writable then
					(create {DEVELOPER_EXCEPTION}).raise
				end
				l_io := False
				from
					l_level := options.min_hint_level
				until
						-- The `l_level' helper variable is necessary in order to avoid setting
						-- options.hint_level to an excessively high value, which could happen
						-- after the last iteration of the loop and cause a contract violation.
					l_level > options.max_hint_level
				loop
					options.hint_level := l_level
					print_message (at_strings.running_at_level (options.hint_level))

					across
						input_classes as ic
					loop
						if options.create_level_subfolders then
							l_io := True
							create l_dir.make_with_path (options.output_directory.path.extended (options.hint_level.out))
							if not l_dir.exists then
								l_dir.recursive_create_dir
							end
							l_io := False
						else
							l_dir := options.output_directory
						end

						l_io := True
						create l_out_file.make_create_read_write (l_dir.path.extended (ic.item.name.as_lower + ".e").out)
						l_io := False

						print_message (at_strings.processing_class (ic.item.name))
						process_class (ic.item, l_out_file)
						l_out_file.close
					end

					l_level := l_level + 1
				end
			else
				print_message (at_strings.error + ": " + at_strings.init_invalid_output_dir)
			end
		rescue
			if l_io then
				retry
			end
		end

feature {NONE} -- Implementation

	input_classes: LINKED_SET [CLASS_C]
			-- The classes to be processed by AutoTeach.

	message_output_action: detachable PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]]
			-- The action to be called for outputting messages.

	ast_iterator: AT_AST_ITERATOR
			-- The iterator performing the real work.

	process_class (a_class: CLASS_C; a_output_file: PLAIN_TEXT_FILE)
			-- Process `a_class', write output to  `a_output_file'.
		require
			file_open_and_writable: a_output_file.is_writable
		local
			l_text: STRING_8
		do
			ast_iterator.set_options (options)
			ast_iterator.process_class (a_class.ast, match_list_server.item (a_class.class_id))

			l_text := ast_iterator.text
				-- Fix for Windows double returns:
			l_text.prune_all ('%R')
			a_output_file.put_string (l_text)

			ast_iterator.reset
		end

	print_message (a_string: READABLE_STRING_GENERAL)
			-- Prints a line to output, if a message output action has been specified.
		do
			if attached message_output_action as l_message_output_action then
				l_message_output_action.call (a_string + "%N")
			end
		end

	options: AT_OPTIONS
			-- The AutoTeach options.

end
