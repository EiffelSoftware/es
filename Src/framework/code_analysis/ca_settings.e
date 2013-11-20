note
	description: "Summary description for {CA_SETTINGS}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_SETTINGS

create
	make

feature {NONE} -- Initialization

	make
		do
			initialize
		end

	initialize
			-- Initialize preference values.
		local
			l_factory: BASIC_PREFERENCE_FACTORY
			l_manager: PREFERENCE_MANAGER
		do
			create l_factory
			create preferences.make
			l_manager := preferences.new_manager ("tools.code_analysis")

			are_hints_enabled := l_factory.new_boolean_preference_value (l_manager, "Enable Hints", True)

		end

feature -- Settings

	preferences: PREFERENCES

	are_hints_enabled: BOOLEAN_PREFERENCE

feature {NONE} -- Implementation

end
