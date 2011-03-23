note
	description : "Some sort of buffer :)."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_WRITER

create
	make

feature {NONE} -- Initialization

	make
		do
			create buffer.make
			reset ("")
		end

feature {NONE} -- Implementation

	computed_string: attached STRING
	computed_to: INTEGER

	update_computed_string
		local
			i: INTEGER
		do
			from
				i := computed_to + 1
			until
				i > buffer.count
			loop
				computed_string.append_string (buffer[i])
				i := i + 1
			end
			computed_to := buffer.count
		end

feature -- Access

	force_string: attached STRING
			-- Output string
		do
			update_computed_string
			Result := computed_string
		end

	data: attached JSC_WRITER_DATA
		do
			create Result.make_from_buffer (buffer)
		end

	indentation: attached STRING
			-- Indentation level

feature -- Operations

	reset (a_indentation: attached STRING)
			-- Reset state
		do
			computed_string := ""
			computed_to := 0
			create buffer.make
			create indentation.make_from_string (a_indentation)
		end

	put (a_string: attached STRING)
			-- Put `a_string' to output buffer
		do
			buffer.extend (a_string)
		end

	put_data (a_data: attached JSC_WRITER_DATA)
			-- Put `a_data' to output buffer
		do
			buffer.fill (a_data.buffer)
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
			buffer.extend ("%N")
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

	put_data_list (a_data_list: attached LIST[attached JSC_WRITER_DATA]; a_glue: attached STRING)
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

	buffer: attached LINKED_LIST[attached STRING]
			-- Buffer that stores output

end
