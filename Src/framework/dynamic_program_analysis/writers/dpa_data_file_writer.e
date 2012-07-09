note
	description: "Summary description for {EPA_DATA_FILE_WRITER}."
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
