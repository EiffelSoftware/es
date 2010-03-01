note
	description: "Simple debug logger."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_DEBUG_LOGGER
create
	make

feature -- Constants

	logfile_name: STRING = "eiffel_transform.log"
			-- Name of logfile

	default_log_level: like log_level = 5
			-- Default loglevel

feature {NONE}-- Creation

	make
			-- Create new instance
		local
			l_env: EXECUTION_ENVIRONMENT
			l_src_dir: STRING
			l_retry: BOOLEAN
		do
			is_enabled := false

			debug("eiffel_transform")
				if not l_retry then
					create l_env
					l_src_dir := l_env.get("EIFFEL_SRC")

					if l_src_dir /= void then
						create log_file.make_open_read_append (l_src_dir+"\framework\eiffel_transform\"+logfile_name)
						if log_file /= void then
							is_enabled := true
						end
						log_file.close
					end

					log_level := default_log_level
				end
			end
		rescue
			is_enabled := false
			l_retry := true
			retry
		end

feature {NONE} -- Implementation

	log_file: PLAIN_TEXT_FILE

feature -- Access

	is_enabled: BOOLEAN

	log_level: INTEGER

	output_file: STRING

feature -- Operation

	log_error (a_string: STRING)
			-- Add `a_string' as error
		require
			string_set: a_string /= void
		do
			log_msg(0, "[ERR] "+a_string)
		end

	log_warning (a_string: STRING)
			-- Add `a_string' as warning
		require
			string_set: a_string /= void
		do
			log_msg(1, "[WARN] "+a_string)
		end

	log_info (a_string: STRING)
			-- Add `a_string' as info
		require
			string_set: a_string /= void
		do
			log_msg(2, "[INFO] "+a_string)
		end

	log_msg (a_log_level: like log_level; a_string: STRING)
			-- Add `a_string' with `a_log_level' to the output
		require
			string_set: a_string /= void

		local
			l_now: TIME
		do
			if is_enabled and a_log_level <= log_level then
				log_file.open_append
				create l_now.make_now
				log_file.put_string ("["+formatted_time(l_now)+"] "+a_string+"%N")
				log_file.close
			end
		end

feature {NONE} -- Implementation

	formatted_time (a_time: TIME): STRING
			-- Formatted `a_time'
		do
			Result := a_time.hour.out + ":"+ a_time.minute.out + ":" + a_time.second.out + "." + a_time.milli_second.out
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
