note
	description: "[
				application service
			]"
	date: "$Date: 2016-10-21 10:45:18 -0700 (Fri, 21 Oct 2016) $"
	revision: "$Revision: 99331 $"

class
	BOOKS_RESTAPI


inherit
	WSF_LAUNCHABLE_SERVICE
		redefine
			initialize
		end
	APPLICATION_LAUNCHER [BOOKS_RESTAPI_EXECUTION]


create
	make_and_launch

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			Precursor
			set_service_option ("port", 7979)
			set_service_option ("verbose", "yes")
			set_service_option ("max_concurrent_connections","10")
			set_service_option ("max_tcp_clients","10")
		end

end
