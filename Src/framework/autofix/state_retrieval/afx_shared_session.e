note
	description: "Summary description for {AFX_SHARED_SESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_SESSION

feature -- Access

	autofix_config: AFX_CONFIG
			-- Config
		do
			Result := autofix_config_cell.item
		end

feature{NONE} -- Initialization

	autofix_config_cell: CELL [AFX_CONFIG]
			-- Cell to store a config
		once
			create Result.put (Void)
		end

	set_autofix_config (a_config: like autofix_config)
			-- Set `autofix_config' with `a_config'.
		do
			autofix_config_cell.put (a_config)
		end

end
