note
	description: "Summary description for {AFX_SHARED_SESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_SESSION

inherit

	ANY

	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

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

	program_state_expression_equality_tester: KL_EQUALITY_TESTER [AFX_PROGRAM_STATE_EXPRESSION]
			-- Expression equality tester for current session.
		do
			if config.is_breakpoint_specific then
				Result := Breakpoint_specific_equality_tester
			else
				Result := Breakpoint_unspecific_equality_tester
			end
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
		once
			create Result.put (Void)
		end

end
