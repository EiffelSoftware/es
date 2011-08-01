note
	description: "Constants for Subversion commands"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_OPTIONS

feature -- Resources

	global_options: SVN_GLOBAL_OPTIONS
		once
			create Result
		end

	add_options: SVN_ADD_COMMAND_OPTIONS
		once
			create Result
		end

	checkout_options: SVN_CHECKOUT_COMMAND_OPTIONS
		once
			create Result
		end

	commit_options: SVN_COMMIT_COMMAND_OPTIONS
		once
			create Result
		end

	copy_options: SVN_COPY_COMMAND_OPTIONS
		once
			create Result
		end

	delete_options: SVN_DELETE_COMMAND_OPTIONS
		once
			create Result
		end

	list_options: SVN_LIST_COMMAND_OPTIONS
		once
			create Result
		end

	log_options: SVN_LOG_COMMAND_OPTIONS
		once
			create Result
		end

	merge_options: SVN_MERGE_COMMAND_OPTIONS
		once
			create Result
		end

	status_options: SVN_STATUS_COMMAND_OPTIONS
		once
			create Result
		end

	update_options: SVN_UPDATE_COMMAND_OPTIONS
		once
			create Result
		end

end
