indexing
	description: "Shared parameter loader"
	author: "Lucas Serpa Silva"
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_SHARED_PARAMETER_LOADER

feature -- Access
	parameter_loader: AUT_PARAMETER_LOADER  is
			-- Singleton Access to AUT_PARAMETER_LOADER
		once
			create Result.make
		ensure
			AUT_PARAMETER_LOADER: Result /= Void
		end

invariant
	invariant_clause: True -- Your invariant here

end
