indexing
	description: "Objects that send simple text-based emails"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

class
	EMAIL_HANDLER

inherit
	APPLICATION_CONSTANTS

feature -- Basic operations

	send_email (recipient, sender, subject, body:STRING)
		-- Sends a simple text based email. Sender is administrator
		require
			recipient_exists: recipient/=Void
			sender_exists: sender/=Void
			subject_exists: subject/=Void
			body_exists: body/=Void
		local
			l_smtp_protocol: SMTP_PROTOCOL
			l_host: HOST_ADDRESS
			l_email: EMAIL
		do
			create l_host.make_local
			-- Create the message.
			create l_email.make
			l_email.add_header_entry (l_email.h_subject, subject)
			l_email.add_header_entry (l_email.h_from, sender)
			l_email.add_header_entry (l_email.h_to, recipient)
			l_email.set_message (body)
			-- Send it.
			create l_smtp_protocol.make (Smtp_server, l_host.local_host_name)
			l_smtp_protocol.initiate_protocol
			l_smtp_protocol.transfer (l_email)
			l_smtp_protocol.close_protocol
		end

invariant
	invariant_clause: True -- Your invariant here

end
