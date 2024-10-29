note
	description: "Summary description for {CMS_ENVIRONMENT_RESOLVER}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_ENVIRONMENT_RESOLVER

inherit
	APPLICATION_RESOLVER

	SHARED_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make (a_cms_setup: CMS_SETUP)
		do
			setup := a_cms_setup
		end

	setup: CMS_SETUP

feature -- Access

	expanded_variable (vn: READABLE_STRING_GENERAL): detachable READABLE_STRING_GENERAL
			-- <Precursor/>
		do
			Result := setup.environment_item (vn)
			if Result = Void then
				Result := execution_environment.item (vn)
			end
		end

note
	copyright: "2011-2024, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end

