note
	description: "Precondition reductor"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_PRECONDITION_REDUCTOR

inherit
	AUT_PRECONDITION_REDUCTION_TASK

feature{NONE} -- Initialization

	make (a_system: like system; a_interpreter: like interpreter; a_error_handler: like error_handler; a_predicate: like current_predicate; a_connection: like connection)
			-- Initialization.
		do
			system := a_system
			interpreter := a_interpreter
			error_handler := a_error_handler
			current_predicate := a_predicate
			connection := a_connection
			create object_retriever
			create used_queryable_ids.make (20)
		end

feature -- Access

	connection: MYSQL_CLIENT
			-- The datbase connection used to retrieve semantic data

	progress_log_manager: ELOG_LOG_MANAGER
			-- Log manager to log progress-related messages

	query_log_manager: ELOG_LOG_MANAGER
			-- Log manager to log query-related messgaes

	object_retriever: AUT_QUERYABLE_QUERYABLE_RETRIEVER
			-- Retriever to get objects from semantic database

	used_queryable_ids: DS_HASH_SET [INTEGER]
			-- Used queryable IDs
			-- We don't want to retrieve those queryables any more.

feature -- Status report

	is_reduction_successful: BOOLEAN
			-- Is current reduction successful?

feature -- Setting

	set_progress_log_manager (a_log_manager: ELOG_LOG_MANAGER)
			-- Set `progress_log_manager' with `a_log_manager'.
		do
			progress_log_manager := a_log_manager
		ensure
			progress_log_manager_set: progress_log_manager = a_log_manager
		end

	set_query_log_manager (a_log_manager: ELOG_LOG_MANAGER)
			-- Set `query_log_manager' with `a_log_manager'.
		do
			query_log_manager := a_log_manager
			if object_retriever /= Void and then query_log_manager /= Void then
				object_retriever.set_log_manager (query_log_manager)
			end
		ensure
			query_log_manager_set: query_log_manager = a_log_manager
		end

	set_is_reduction_successful (b: BOOLEAN)
			-- Set `is_reduction_successful' with `b'.
		do
			is_reduction_successful := b
		ensure
			is_reduction_successful_set: is_reduction_successful = b
		end

feature{NONE} -- Database related

	reconnect
			-- Reconnect `connection'.
		do
			connection.close
			connection.dispose
			connection := interpreter.configuration.semantic_database_config.connection
			connection.connect
		end

feature{NONE} -- Implementation

	should_quit: BOOLEAN
			-- Should we quit current task?

feature{NONE} -- Implementation

	set_should_quit (b: BOOLEAN)
			-- Set `should_quit' with `b'.
		do
			should_quit := b
		ensure
			should_quit_set: should_quit = b
		end

	update_queryable_id_set (a_qry_id_set: DS_HASH_SET [INTEGER]; a_objects: LINKED_LIST [SEMQ_RESULT])
			-- Put all queryable IDs from `a_objects' into `a_qry_id_set'.
		do
			across a_objects as l_objs loop
				across l_objs.item.meta as l_metas loop
					l_metas.item.search (once "qry_id")
					if l_metas.item.found then
						a_qry_id_set.force_last (l_metas.item.found_item.to_integer)
					end
				end
			end
		end

	restart_interpreter_when_necessary
			-- Restart `interpreter' when necessary.
		do
			if not interpreter.is_executing or else not interpreter.is_ready then
				if interpreter.is_running then
					interpreter.stop
				end
				interpreter.start
				assign_void
			end
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
