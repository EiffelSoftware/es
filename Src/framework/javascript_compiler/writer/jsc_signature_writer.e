note
	description : "Translate signature of a routine to JavaScript."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_SIGNATURE_WRITER

inherit
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
		end

feature -- Access

	output: attached JSC_SMART_BUFFER
			-- Generated JavaScript code.

feature -- Basic Operations

	reset (a_indentation: attached STRING)
			-- Reset translation state.
		do
			output.reset (a_indentation)
		end

	write_feature_declaration (a_feature: attached FEATURE_I)
			-- Generate declaration for feature `a_feature'.
		do
			output.put_indentation
			output.put (jsc_context.name_mapper.feature_name (a_feature, false))
			output.put (" : ")

			if a_feature.is_once then
				output.put ("(function () {")
				output.put_new_line

				output.indent
				output.put_line ("var $cached = null, $executed = false;");
				output.put_indentation
				output.put ("return ");
			end

			write_feature_signature (a_feature)
		end

	write_feature_signature (a_feature: attached FEATURE_I)
			-- Generate signature for feature `a_feature'
		local
			l_args: LINKED_LIST[attached STRING]
			l_argument_name: STRING
			i: INTEGER
		do
			create l_args.make
			if attached a_feature.arguments as safe_arguments then
				from
					i := safe_arguments.lower
				until
					i > safe_arguments.upper
				loop
					l_argument_name := safe_arguments.item_name (i)
					check l_argument_name /= Void end
					l_args.extend (l_argument_name)
					i := i + 1
				end
			end

			output.put ("function (")
			output.put_list (l_args, ", ")
			output.put (")")
		end

end
