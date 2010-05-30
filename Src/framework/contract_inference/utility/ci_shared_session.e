note
	description: "Shared contract inference session"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SHARED_SESSION

feature -- Access

	contract_inference_config: CI_CONFIG
			-- Config
		do
			Result := contract_inference_config_cell.item
		end

feature{NONE} -- Initialization

	contract_inference_config_cell: CELL [CI_CONFIG]
			-- Cell to store a config
		once
			create Result.put (Void)
		end

	set_contract_inference_config (a_config: like contract_inference_config)
			-- Set `contract_inference_config' with `a_config'.
		do
			contract_inference_config_cell.put (a_config)
		end


end
