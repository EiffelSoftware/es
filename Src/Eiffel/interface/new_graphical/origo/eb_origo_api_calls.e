indexing
	description: "Objects that perform XML RPC calls to Origo through the XML RPC client"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_API_CALLS

inherit
	EB_SHARED_PREFERENCES
		export
			{NONE} all
		end

create
	make

feature -- Initialisation

	make (a_parent_window: EV_WINDOW) is
		require
			a_parent_window_not_void: a_parent_window /= Void
		do
			parent_window := a_parent_window
		end

feature -- XML RPC calls

	login: STRING is
			-- perform a login and return the session id
		local
			l_process: PROCESS
			l_factory: PROCESS_FACTORY
			command_line: STRING
			session: STRING
			error: STRING
		do
			session := ""
			error := ""
			command_line := preferences.origo_data.xml_rpc_client_path.out
			command_line.append (" login -uk ")
			command_line.append (preferences.origo_data.user_key)
			command_line.append (" -ak ")
			command_line.append (application_key)
			create l_factory
			l_process := l_factory.process_launcher_with_command_line (command_line, Void)
			l_process.redirect_output_to_agent (agent session.append)
			l_process.redirect_error_to_agent (agent error.append)
			l_process.launch

				-- launch process
			if l_process.launched then
				l_process.wait_for_exit

					-- if everything went fine
				if error.is_empty then
					Result := session

					-- an error occurred
				else
					error.insert_string ("Error during login:%N", 1)
					show_warning (error)
				end

				-- the process could not be launched
			else
				show_warning ("Error during login:%NCommand line tool could not be launched")
			end
		end

feature {NONE} -- Implementation

	show_warning (warning: STRING) is
			-- show a warning dialog
		local
			warning_dialog: EV_WARNING_DIALOG
		do
			create warning_dialog.make_with_text (warning)
			if parent_window = Void then
				warning_dialog.show
			else
				warning_dialog.show_modal_to_window (parent_window)
			end
		end


feature {NONE} -- Implementation

--	session: STRING
--		-- session string

	parent_window: EV_WINDOW
		-- window which causes the calls

	application_key: STRING is "KEYFORTHEEIFFELSTUDIOINTEGRATION"


end
