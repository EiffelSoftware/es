note
	description: "Summary description for {AFX_SESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SESSION

create
	make

feature -- Initialization

	make (a_config: like config)
			-- Initialization
		require
			config_attached: a_config /= Void
		do
			config := a_config
			create event_actions.make
		end

feature -- Access

	config: AFX_CONFIG assign set_config
			-- AutoFix configuration.

	exception_signature: AFX_EXCEPTION_SIGNATURE assign set_exception_signature
			-- Signature of the exception.

	exception_recipient_feature: AFX_EXCEPTION_RECIPIENT_FEATURE
			-- Recipient feature of `exception_signature'.

	event_actions: AFX_EVENT_ACTIONS
			-- Event actions.

feature -- Status set

	set_config (a_config: like config)
			-- Set `config'.
		do
			config := a_config
		end

	set_exception_signature (a_signature: AFX_EXCEPTION_SIGNATURE)
			-- Set `a_signature'.
		require
			signature_attached: a_signature /= Void
		do
			exception_signature := a_signature
			create exception_recipient_feature.make_for_exception (exception_signature)
		end

end
