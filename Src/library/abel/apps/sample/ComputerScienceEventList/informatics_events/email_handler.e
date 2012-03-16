indexing
	description: "Objects that send simple text-based emails"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.6.1$"

class
	EMAIL_HANDLER

inherit
	APPLICATION_CONSTANTS

feature -- Basic operations

	send_email (recipient, sender, subject, body: STRING)
			-- Sends a simple text based email. Sender is administrator
		require
			recipient_exists: recipient /= Void
			sender_exists: sender /= Void
			subject_exists: subject /= Void
			body_exists: body /= Void
		local
			l_body: STRING
			l_email: EMAIL
			l_smtp_protocol: SMTP_PROTOCOL
		do
			-- %N -> %R%N
			l_body := body.twin
			l_body.replace_substring_all ("%N", "%R%N")
			l_body.replace_substring_all ("%R%R%N", "%R%N")

			-- Create the message.
			create l_email.make
			l_email.add_header_entry (l_email.h_subject, subject)
			l_email.add_header_entry (l_email.h_from, sender)
			l_email.add_header_entry (l_email.h_to, recipient)
			l_email.set_message (l_body)

			-- Send it.
			create l_smtp_protocol.make (Smtp_server, (create {HOST_ADDRESS}.make_local).local_host_name)
			l_smtp_protocol.initiate_protocol
			l_smtp_protocol.transfer (l_email)
			l_smtp_protocol.close_protocol
		end

end
