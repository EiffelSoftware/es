indexing
	description: "Shared access to registry"
	author: "Ilinca Ciupa and Andreas Leitner"
	date: "$Date$"
	revision: "$Revision: 76108 $"

class AUT_SHARED_REGISTRY

feature -- Singleton Access

	registry: AUT_REGISTRY is
			-- Registry singleton
		once
			create Result
		ensure
			registry_not_void: Result /= Void		
		end

end
