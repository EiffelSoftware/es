note
	description: "Sample repository, specialized in sql queries on {PERSON} objects."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PERSON_SQL_DAO

create
	make_with_mysql_repository

feature -- Initialization


	make_with_mysql_repository (a_repository: PS_MYSQL_REPOSITORY)
			-- Initialize `Current' with a MySQL repository implementation.
		do
			repository := a_repository

		ensure
			repository_set: repository = a_repository
		end

feature -- Access

	repository: PS_MYSQL_REPOSITORY
			-- MySQL repository implementation.
end
