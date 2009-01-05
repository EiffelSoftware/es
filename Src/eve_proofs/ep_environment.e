indexing
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

class EP_ENVIRONMENT

inherit

	KL_SHARED_STANDARD_FILES
		export {NONE} all end

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize environment with default output stream.
		do
		end

feature -- Access

	output_buffer: !EP_OUTPUT_BUFFER
			-- Output buffer for generated Boogie code

feature -- Element change

	set_output_buffer (a_value: !EP_OUTPUT_BUFFER)
			-- Set `output_buffer' to `a_value'.
		do
			output_buffer := a_value
		ensure
			output_buffer_set: output_buffer = a_value
		end

end
