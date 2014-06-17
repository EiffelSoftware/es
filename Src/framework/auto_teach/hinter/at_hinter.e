note
	description: "Hinter main class."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HINTER

inherit

	SHARED_WORKBENCH

	AT_COMMON

create
	make_with_options

feature {NONE} -- Initialization

	make_with_options (a_options: AT_OPTIONS)
			-- Initialization for `Current'.
		do
			options := a_options
			create input_classes.make
		end

feature -- Interface

	add_class (a_class: CONF_CLASS)
			-- Add class `a_class'.
		do
			if attached {EIFFEL_CLASS_I} a_class as l_eiffel_class and then attached l_eiffel_class.compiled_class as l_compiled then
				input_classes.extend (l_compiled)
			else
				print_line (at_strings.error_class_not_compiled (a_class.name))
			end
		end

	set_message_output_action (a_action: PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]])
			-- Set `a_action' as the action to be called for outputting messages.
		do
			message_output_action := a_action
		end

	run_hinter
			-- Run hinter.
		local
			l_out_file: PLAIN_TEXT_FILE
			l_class_processor: AT_HINTER_CLASS_PROCESSOR
		do
			create l_class_processor.make_with_options (options)
			across
				input_classes as ic
			loop
					-- TODO: support recreating the source cluster/folder structure?
				create l_out_file.make_create_read_write (options.output_directory.path.extended (ic.item.name + ".e").out)
				l_class_processor.process_class (ic.item, l_out_file)
				l_out_file.close
			end
		end

feature {NONE} -- Implementation

	input_classes: LINKED_SET [CLASS_C]
			-- The classes to be processed by hinter.

	message_output_action: detachable PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]]
			-- The action to be called for outputting messages.

	print_line (a_string: READABLE_STRING_GENERAL)
			-- Prints a line to output, if a message output action has been specified.
		do
			if attached message_output_action as l_message_output_action then
				l_message_output_action.call (a_string + "%N")
			end
		end

	options: AT_OPTIONS
			-- The AutoTeach options.

end
