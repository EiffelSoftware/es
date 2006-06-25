indexing
	description: "Defines several constants used in several classes of the emu server."
	author: "Bernhard S. Buss"
	created: "25.june.2006"
	date: "$Date$"
	revision: "$Revision$"

class
	EMU_SERVER_CONSTANTS

--inherit
--	ANY
--		undefine
--			default_create
--		end

create
	-- is not to be created.

feature -- Project

	project_folder_name: STRING is "projects"
			-- the default location of the project folders.

end
