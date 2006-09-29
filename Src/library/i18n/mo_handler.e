indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_MO_HANDLER inherit

		I18N_FILE_HANDLER
		redefine
			file
		end


		feature
			file: I18N_MO_FILE -- do this in make?

end
