note
	description: "Display information about ROC CMS installation."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_ADMIN_INFO_HANDLER

inherit
	CMS_HANDLER
	WSF_URI_HANDLER

	SHARED_EXECUTION_ENVIRONMENT

create
	make

feature -- Execution

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		local
			r: like new_generic_response
			s: STRING
		do
			if req.is_get_request_method then
				if api.has_permission ({CMS_ADMIN_MODULE_ADMINISTRATION}.perm_view_system_info) then
					r := new_generic_response (req, res)
					create s.make_empty
					r.set_title ("System Information")
					r.add_to_primary_tabs (api.administration_link ("Administration", ""))
					append_system_info_to (s)
					if attached {WSF_STRING} req.query_parameter ("query") as p_query then
						if
							p_query.is_case_insensitive_equal ("environment")
							or p_query.is_case_insensitive_equal ("env")
						then
							append_system_environment_to (s)
						end
					end
					r.set_main_content (s)
					r.execute
				else
					send_access_denied (req, res)
				end
			else
				send_bad_request (req, res)
			end
		end

	append_system_info_to (s: STRING)
		local
			l_mailer: NOTIFICATION_MAILER
--			l_previous_mailer: NOTIFICATION_MAILER
		do
			s.append ("<ul>")
			across
				api.setup.system_info as ic
			loop
				s.append ("<li><strong>"+ html_encoded (ic.key) +":</strong> ")
				s.append (html_encoded (ic.item))
				s.append ("</li>")
			end
			s.append ("<li><strong>Storage:</strong> ")
			s.append (" -&gt; ")
			s.append (api.storage.generator)
			s.append ("</li>")

			s.append ("<li><strong>Mailer:</strong> ")
			l_mailer := api.setup.mailer
			from until l_mailer = Void loop
				s.append (" -&gt; ")
				s.append (l_mailer.generator)
				if attached {NOTIFICATION_CHAIN_MAILER} l_mailer as l_chain_mailer then
					l_mailer := l_chain_mailer.next
				else
					l_mailer := Void
				end
			end
			s.append ("</li>")
			s.append ("</ul>")
		end

	append_system_environment_to (s: STRING)
		local
			l_mailer: NOTIFICATION_MAILER
--			l_previous_mailer: NOTIFICATION_MAILER
		do
			s.append ("<h3>Environment</h3>")
			s.append ("<h4>from Setup</h4>")
			if attached api.setup.environment_items as l_site_envs then
				s.append ("<ul>")
				across
					l_site_envs as ic
				loop
					s.append ("<li><strong>"+ html_encoded (ic.key) +":</strong> ")
					if attached ic.item as v then
						s.append (html_encoded (v))
					else
						s.append ("")
					end
					s.append ("</li>")
				end
				s.append ("</ul>")
			end
			s.append ("<h4>from Process</h4>")
			if attached execution_environment.starting_environment as l_proc_envs then
				s.append ("<ul>")
				across
					l_proc_envs as ic
				loop
					s.append ("<li><strong>"+ html_encoded (ic.key) +":</strong> ")
					s.append (html_encoded (ic.item))
					s.append ("</li>")
				end
				s.append ("</ul>")
			end
		end

end
