indexing
	description: "Objects that write class text to a file"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_CLASS_PRINTER

feature -- Access

	is_output_stream_valid: BOOLEAN
			-- Can we currently print to `output_file'?
		do
			Result := output_stream /= Void and then
				output_stream.is_open_write
		end

feature -- Status settings

	initialize (an_output_stream: like output_stream) is
			-- Set `output_stream' to `an_output_stream' and set
			-- `indent_value' to its default value.
		require
			an_output_stream_not_void: an_output_stream /= Void
		do
			output_stream := an_output_stream
			indent_level := 0
		ensure
			output_stream_set: output_stream = an_output_stream
		end

	finish is
			-- Set `output_stream' and `indent_level' to its default values
		do
			output_stream := Void
			indent_level := 0
		ensure
			output_stream_unset: output_stream = Void
			indent_level_reset: indent_level = 0
		end


feature {NONE} -- Basic class text output

	output_stream: KI_CHARACTER_OUTPUT_STREAM
			-- Output stream to print class text

	indent_character: STRING is "%T"
			-- String used for indentation

	indent_level: INTEGER
			-- Level of current indentation

	increase_indent is
			-- Increase `indent_level' by one.
		do
			indent_level := indent_level + 1
		ensure
			indent_level_increased: indent_level = old indent_level + 1
		end

	decrease_indent is
			-- Decrease `indent_level' by one.
		require
			indent_level_positive: indent_level > 0
		do
			indent_level := indent_level - 1
		ensure
			indent_level_increased: indent_level = old indent_level - 1
		end

	indent: STRING is
			-- Returns `indent_character' `indent_level'-times
		local
			i: INTEGER
		do
			from
				create Result.make_empty
				i := 1
			until
				i > indent_level
			loop
				Result.append (indent_character)
				i := i + 1
			end
		ensure
			not_void: Result /= Void
			correct_count: Result.count = indent_character.count*indent_level
		end

	put_string (a_str: STRING) is
			-- Writes `a_str' to `output_stream'.
		require
			valid_output_stream: is_output_stream_valid
			a_str_not_void: a_str /= Void
		do
			output_stream.put_string (a_str)
		end

	put_line (a_str: STRING) is
			-- Writes `a_str' to `output_stream' adding indentation and newline character.
		require
			valid_output_stream: is_output_stream_valid
			a_str_not_void: a_str /= Void
		do
			put_string (indent + a_str + "%N")
		end

	put_comment (a_str: STRING) is
			-- Writes `a_str' to `output_stream' with comment prefix, indentation and newline character.
		require
			valid_output_stream: is_output_stream_valid
			a_str_not_void: a_str /= Void
		do
			put_string (indent + indent_character + "-- " + a_str + "%N")
		end

invariant
	indent_level_not_negative: indent_level >= 0

end
