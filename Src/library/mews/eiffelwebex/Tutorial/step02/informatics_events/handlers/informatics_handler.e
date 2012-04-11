indexing
	description: "Generic parent handler for this informatics_events application, defined common initialization and processing routines."
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "$05.02.2008$"
	revision: "$0.8.1$"

deferred class
	INFORMATICS_HANDLER

inherit
	REQUEST_HANDLER
	redefine
		make, initialize
	end
	APPLICATION_CONSTANTS

feature -- Attribute

	user_manager: USER_MANAGER
		-- access registered user information

	encryptor: ENCRYPTOR
		-- used encryptor implementation

	return_view: HTML_TEMPLATE_VIEW
		-- result html page

	actual_user: INFORMATICS_USER
		-- actual user

	my_session: INFORMATICS_SESSION
		-- wrapped session related operations

feature -- Creation

	make is
			-- creation
		do
			PRECURSOR

			create my_session.make (session)

			create {ENIGMA}encryptor.make(5)
		end

	initialize(env: REQUEST_DISPATCHER) is
			-- init references to dispatcher and session object
		do
			PRECURSOR(env)

			create my_session.make (session)

			create {ENIGMA}encryptor.make(5)
		end


feature {INFORMATICS_HANDLER} -- processing request


	pre_processing is
			-- common tasks to be executed before starting process user request
			-- try authentice user, and filter out unauthorized request
		do
			create {USER_MANAGER_FILE_IMPL}user_manager.make("data_folder", "users", encryptor)
		end

	post_processing is
			-- common tasks to be executed after request processed
		do
		end

invariant
	invariant_clause: True -- Your invariant here

end
