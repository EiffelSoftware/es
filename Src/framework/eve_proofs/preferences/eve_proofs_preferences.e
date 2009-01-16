indexing
	description: "Preferences for EVE Proofs"
	date: "$Date$"
	revision: "$Revision$"

class EVE_PROOFS_PREFERENCES

create
	make

feature {NONE} -- Initialization

	make (a_preferences: PREFERENCES) is
			-- Initialize preference data
		require
			preferences_not_void: a_preferences /= Void
		do
			preferences := a_preferences
			initialize_preferences (a_preferences)
		end

feature -- Access

	boogie_executable: !STRING is
			-- Location of Boogie executable
		do
			if {l_value: !STRING} boogie_executable_preference.value then
				Result := l_value
			else
				Result := ""
			end
		end

feature -- Access

	preferences: !PREFERENCES
			-- Actual preferences.  Use only to get a preference which you do not know the type
			-- of at runtime through `get_resource'.

feature {NONE} -- Preference

	boogie_executable_preference: !STRING_PREFERENCE

	boogie_executable_string: !STRING is "tools.eve_proofs.boogie_executable"

feature {NONE} -- Implementation

	initialize_preferences (a_preferences: PREFERENCES) is
			-- Initialize preference values.
		require
			a_preferences_not_void: a_preferences /= Void
		local
			l_manager: PREFERENCE_MANAGER
			l_factory: BASIC_PREFERENCE_FACTORY
			l_string_preference: STRING_PREFERENCE
		do
			create l_factory
			l_manager := a_preferences.new_manager ("eve proofs")

			l_string_preference := l_factory.new_string_preference_value (l_manager, boogie_executable_string, "")
			check l_string_preference /= Void end
			boogie_executable_preference := l_string_preference
		end

end
