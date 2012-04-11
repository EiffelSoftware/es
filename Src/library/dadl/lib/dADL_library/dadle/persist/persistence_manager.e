indexing
	description: "Summary description for {PERSISTENCE_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PERSISTENCE_MANAGER

feature -- Initialization


feature -- Access

	medium: PERSISTENCE_MEDIUM -- the chosen medium

	format: PERSISTENCE_FORMAT	-- the chosen format

feature -- Basic operations

	store (an_object: ANY)
			-- persists an_object using the format and medium stored by current object
		require
			an_object_exists: an_object /= Void
			medium_exists: medium /= Void
		do
			format.store(an_object,medium)
		end

	retrieve: ANY
			-- retrieves an_object using the medium and format stored by current object
		require
			medium_exists: medium /= Void
		do
			Result := format.retrieve(medium)
		end

end
