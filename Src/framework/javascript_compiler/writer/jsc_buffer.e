note
	description : "Some sort of buffer :)."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_BUFFER

create
	make

feature {NONE} -- Initialization

	make
		do
			reset ("")
		end

feature -- Access

	force_string: attached STRING
			-- Output string
		local
			l_string: STRING
		do
			l_string := buffer.string
			check l_string /= Void end
			
			Result := l_string
		end

	data: attached JSC_BUFFER_DATA
		do
			create Result.make_from_buffer (buffer)
		end

	indentation: attached STRING
			-- Indentation level

feature -- Operations

	reset (a_indentation: attached STRING)
			-- Reset state
		do
			create buffer.make_empty
			create indentation.make_from_string (a_indentation)
		end

	put (a_string: attached STRING)
			-- Put `a_string' to output buffer
		do
			buffer.put_string (a_string)
		end

	put_data (a_data: attached JSC_BUFFER_DATA)
			-- Put `a_data' to output buffer
		do
			buffer.put_string (a_data.buffer.string)
		end

	put_line (a_line: attached STRING)
			-- Put `a_line' to output buffer
			-- The line will be indented
		do
			put_indentation
			put(a_line)
			put_new_line
		end

	put_comment_line (a_line: attached STRING)
			-- Put `a_line' to output buffer as a comment
			-- The line will be indented
		do
			put_indentation
			put("// ")
			put(a_line)
			put_new_line
		end

	put_new_line
			-- Put a new line to output buffer
		do
			put ("%N")
		end

	put_indentation
			-- Put the indentation to output buffer
		do
			put (indentation)
		end

	put_list (a_list: attached LIST[attached STRING]; a_glue: attached STRING)
		local
			l_is_first_parameter: BOOLEAN
		do
			from
				a_list.start
				l_is_first_parameter := true
			until
				a_list.after
			loop
				if l_is_first_parameter then
					l_is_first_parameter := false
				else
					put (a_glue)
				end
				put (a_list.item)
				a_list.forth
			end
		end

	put_data_list (a_data_list: attached LIST[attached JSC_BUFFER_DATA]; a_glue: attached STRING)
		local
			l_is_first_parameter: BOOLEAN
		do
			from
				a_data_list.start
				l_is_first_parameter := true
			until
				a_data_list.after
			loop
				if l_is_first_parameter then
					l_is_first_parameter := false
				else
					put (a_glue)
				end
				put_data (a_data_list.item)
				a_data_list.forth
			end
		end

	indent
			-- Increment indentation
		do
			create indentation.make_from_string (indentation)
			indentation.append_string ("%T")
		end

	unindent
			-- Decremenet indentation
		do
			create indentation.make_from_string (indentation)
			indentation.remove_tail (1)
		end


feature {NONE} -- Implementation

	buffer: attached KL_STRING_OUTPUT_STREAM --LINKED_LIST[attached STRING]
			-- Buffer that stores output

end
