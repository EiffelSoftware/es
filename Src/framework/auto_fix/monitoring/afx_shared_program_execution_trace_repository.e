note
	description: "Summary description for {AFX_SHARED_PROGRAM_EXECUTION_TRACE_REPOSITORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_PROGRAM_EXECUTION_TRACE_REPOSITORY

create
	default_create

feature -- Access

	trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			-- Current trace repository.
		local
			l_repos: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
		do
			if trace_repository_cache.item = Void then
				create l_repos.make
				set_repository (l_repos)
			end

			Result := trace_repository_cache.item
		end

feature -- Status set

	set_repository (a_repos: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY)
			-- Set trace repository.
		require
			repos_attached: a_repos /= Void
		do
			trace_repository_cache.put (a_repos)
		end

feature -- Implementation

	trace_repository_cache: CELL[AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY]
			-- Cache for trace repository.
		once
			create Result.put (Void)
		end

end
