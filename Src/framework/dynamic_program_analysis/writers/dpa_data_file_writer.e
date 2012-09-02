note
	description: "A writer that writes the data from a dynamic program analysis to disk using one or multiple files."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DPA_DATA_FILE_WRITER

inherit
	DPA_DATA_WRITER

feature -- Access

	output_path: STRING
			-- Output-path where the file should be written to.

end
