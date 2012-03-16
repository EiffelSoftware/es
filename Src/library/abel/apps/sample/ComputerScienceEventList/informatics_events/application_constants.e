indexing
	description: "Application constants unique repository. Useful for configuring the application"
	author: "Marco Piccioni"
	date: "$05.02.2008$"
	revision: "$0.8.1$"

deferred class
	APPLICATION_CONSTANTS

	feature -- event status
		Proposed, Accepted, Rejected, Deleted: INTEGER is unique

	feature -- user status
		User_Active, User_Suspended: INTEGER is unique

	feature -- user roles
		ROLE_GUEST: INTEGER is 0
		ROLE_NORMAL_USER: INTEGER is 1
		ROLE_ADMINISTRATOR: INTEGER is 2

	feature -- precreated admin account
		Admin_email:STRING = "conferences@informatics-europe.org"
		Admin_first_name: STRING = "administrator"
		Admin_last_name: STRING = " "
		Admin_password: STRING = "dummy"
		Admin_organization: STRING = "Informatics Europe / Computer Science Department, ETH Zürich"
		Admin_telephone: STRING is "-"

		Smtp_server:STRING = "localhost"
		Event_accepted_email_subject:STRING = "Informatics Europe: submitted event proposal information"
		Event_accepted_email_message:STRING = "Thank you for submitting your event announcement.%N%NIt has now been approved for listing and you will find it at%N%Nhttp://www.informatics-europe.ethz.ch/cgi-bin/informatics_events.cgi%N%NWe suggest that you link back to the site by including the following HTML code on the conference page:%N%N<p>This event is listed at the Computer Science Event List, <a href=%"http://www.informatics-europe.ethz.ch/cgi-bin/informatics_events.cgi%">www.informatics-europe.org</a></p>%N%NThanks and best wishes for the conference.%N%NThe Computer Science Event List team"
		Event_proposed_email_subject:STRING = "Informatics Europe: an event proposal has been submitted"
		Event_proposed_email_message:STRING = "Hello, %N%NAn event proposal has been just submitted.%N%NYou can review the event details at:%N%Nhttp://www.informatics-europe.ethz.ch/cgi-bin/informatics_events.cgi%N%NThank you and Best Regards%N%NThe Site Editors"

end
