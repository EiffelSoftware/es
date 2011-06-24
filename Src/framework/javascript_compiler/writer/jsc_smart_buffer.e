note
	description : "Some sort of buffer with push/pop :)."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_SMART_BUFFER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize object
		do
			create {LINKED_STACK[attached JSC_BUFFER]}writers.make
			push ("")
		end

feature -- Access

	force_string: attached STRING
			-- Ouput string
		do
			Result := writer.force_string
		end

	data: attached JSC_BUFFER_DATA
		do
			Result := writer.data
		end

	indentation: attached STRING
			-- Indentation level
		do
			Result := writer.indentation
		end

feature -- Operations

	reset (a_indentation: attached STRING)
			-- Reset state
		do
			writer.reset (a_indentation)
		end

	put (a_string: attached STRING)
			-- Put `a_string' to output buffer
		do
			writer.put (a_string)
		end

	put_data (a_data: attached JSC_BUFFER_DATA)
			-- Put `a_data' to output buffer
		do
			writer.put_data (a_data)
		end

	put_line (a_line: attached STRING)
			-- Put `a_line' to output buffer
			-- The line will be indented
		do
			writer.put_line (a_line)
		end

	put_comment_line (a_line: attached STRING)
			-- Put `a_line' to output buffer as a comment
			-- The line will be indented
		do
			writer.put_comment_line (a_line)
		end

	put_new_line
			-- Put a new line to output buffer
		do
			writer.put_new_line
		end

	put_indentation
			-- Put the indentation to output buffer
		do
			writer.put_indentation
		end

	put_list (a_list: attached LIST[attached STRING]; a_glue: attached STRING)
		do
			writer.put_list (a_list, a_glue)
		end

	put_data_list (a_data_list: attached LIST[attached JSC_BUFFER_DATA]; a_glue: attached STRING)
		do
			writer.put_data_list (a_data_list, a_glue)
		end

	indent
			-- Increment indentation
		do
			writer.indent
		end

	unindent
			-- Decremenet indentation
		do
			writer.unindent
		end

	push (a_indentation: attached STRING)
			-- Push writer
		local
			temp_writer: attached JSC_BUFFER
		do
			create temp_writer.make
			temp_writer.reset (a_indentation)
			writers.put (temp_writer)
		end

	pop
			-- Pop writer
		do
			writers.remove
		end

feature {NONE} -- Implementation

	writer: attached JSC_BUFFER
		do
			Result := writers.item
		end

	writers : attached STACK[attached JSC_BUFFER]

end
