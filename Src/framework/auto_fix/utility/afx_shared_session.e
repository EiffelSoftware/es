note
	description: "Summary description for {AFX_SHARED_SESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_SESSION

feature -- Access

	session: AFX_SESSION
			-- Shared session.
		require
			session_attached: is_session_attached
		do
			Result := session_cell.item
		end

	config: AFX_CONFIG
			-- Autofix configuration.
		require
			session_attached: is_session_attached
		do
			Result := session.config
		end

	event_actions: AFX_EVENT_ACTIONS
			-- Event actions.
		require
			session_attached: is_session_attached
		do
			Result := session.event_actions
		end

	progression_monitor: AFX_PROGRESSION_MONITOR
			-- Progression monitor.
		require
			session_attached: is_session_attached
		do
			Result := session.progression_monitor
		end

	exception_signature: AFX_EXCEPTION_SIGNATURE
			-- Signature of the exception.
		do
			Result := session.exception_signature
		end

	exception_recipient_feature: AFX_EXCEPTION_RECIPIENT_FEATURE
			-- Recipient feature of `exception_signature'.
		do
			Result := session.exception_recipient_feature
		end

feature -- Status report

	is_session_attached: BOOLEAN
			-- Is the shared session object attached?
		do
			Result := session_cell.item /= Void
		end

feature -- Status set

	set_session (a_session: AFX_SESSION)
			-- Set `a_session' as the shared session object.
		require
			session_attached: a_session /= Void
		do
			session_cell.put (a_session)
		end

feature{NONE} -- Initialization

	session_cell: CELL [AFX_SESSION]
			-- Cell to store a session object.
		once("PROCESS")
			create Result.put (Void)
		end

end
