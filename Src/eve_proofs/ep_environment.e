indexing
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

class EP_ENVIRONMENT

inherit {NONE}

	KL_SHARED_STANDARD_FILES
		export {NONE} all end

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize environment with default output stream.
		do
			reset
		ensure
			output_buffer_set: output_buffer = std.output
		end

feature -- Access

	output_buffer: !KI_TEXT_OUTPUT_STREAM
			-- Output buffer for generated Boogie code

feature -- Element change

	set_output_buffer (a_value: !KI_TEXT_OUTPUT_STREAM)
			-- Set `output_buffer' to `a_value'.
		do
			output_buffer := a_value
		ensure
			output_buffer_set: output_buffer = a_value
		end

feature -- Basic operations

	reset
			-- Reset environment for new verification session.
		do
			if {l_buffer: KI_TEXT_OUTPUT_STREAM} std.output then
				output_buffer := l_buffer
			else
				check false end
			end
		ensure
			output_buffer_reset: output_buffer = std.output
		end

end
