note
	description: "Summary description for {SVN_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SVN_PARSER

feature -- Parse commands

	parse_checkout (a_checkout_command: SVN_CLIENT_CHECKOUT_COMMAND)
		require
			checkout_command_not_void: a_checkout_command /= Void
		deferred
		end

	parse_commit (a_commit_command: SVN_CLIENT_COMMIT_COMMAND)
		require
			commit_command_not_void: a_commit_command /= Void
		deferred
		end

	parse_list (a_list_command: SVN_CLIENT_LIST_COMMAND)
		require
			list_command_not_void: a_list_command /= Void
		deferred
		end

	parse_log (a_log_command: SVN_CLIENT_LOG_COMMAND)
		require
			log_command_not_void: a_log_command /= Void
		deferred
		end

	parse_status (a_status_command: SVN_CLIENT_STATUS_COMMAND)
		require
			stats_command_not_void: a_status_command /= Void
		deferred
		end

	parse_error (a_client_command: SVN_CLIENT_COMMAND)
		require
			client_command_not_void: a_client_command /= Void
		deferred
		end

end
