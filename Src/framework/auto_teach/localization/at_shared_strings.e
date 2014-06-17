note
	description: "Provides shared access to localized strings for AutoTeach."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AT_SHARED_STRINGS

feature -- Names

	at_strings: AT_STRINGS
			-- Localized strings for AutoTeach.
		once
			create Result
		ensure
			valid_result: Result /= Void
		end

end
