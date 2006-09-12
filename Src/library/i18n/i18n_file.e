indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_FILE

feature
	-- creation
	make (path: STRING_GENERAL) is
			-- attempts to open the file at path
		deferred
		end

 feature
 	-- information
 	locale: STRING_32 is
 			-- target locale of the file, possibly derived from the file name
 		deferred
 		end

 	plural_form: INTEGER
 			-- the plural form used by the file

 	






 feature
 	-- mechanics

	opened: BOOLEAN -- is the file opened?

	close is
			-- closes the file
		require
			opened -- can't close file if not open
		deferred
		end



end
