indexing
	description: "Application constants unique repository. Useful for configuring the application"
	author: "Marco Piccioni"
	date: "$05.02.2008$"
	revision: "$0.8.1$"

deferred class
	APPLICATION_CONSTANTS

	feature -- event status
		Proposed, Accepted, Rejected, Deleted: INTEGER is unique

	feature -- user status
		User_Active, User_Suspended: INTEGER is unique

	feature -- user roles
		ROLE_GUEST: INTEGER is 0
		ROLE_NORMAL_USER: INTEGER is 1
		ROLE_ADMINISTRATOR: INTEGER is 2

	feature -- precreated admin account
		Admin_email:STRING = "admin@informatics_events.org"
		Admin_first_name: STRING = "admin"
		Admin_last_name: STRING = ""
		Admin_password: STRING = "dummy"
		Admin_organization: STRING = "Informatics Europe / Computer Science Department, ETH Zürich"
		Admin_telephone: STRING is "-"


end
