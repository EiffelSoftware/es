note
	description: "Summary description for {AFX_SESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SESSION

create
	make

feature -- Initialization

	make (a_config: like config)
			-- Initialization
		require
			config_attached: a_config /= Void
		do
			config := a_config
		end

feature -- Access

	config: AFX_CONFIG assign set_config
			-- AutoFix configuration.

feature -- Status set

	set_config (a_config: like config)
			-- Set `config'.
		do
			config := a_config
		end

end
