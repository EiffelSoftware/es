indexing
	description: "Application constants unique repository. Useful for configuring the application"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$0.3.1$"

deferred class
	APPLICATION_CONSTANT

	feature --conference constants

		Undefined, Proposed, Accepted, Delayed, Rejected: INTEGER is unique --constant unique values that can be assigned to a conference status_of_approval

		Conference_list_number_of_columns:INTEGER = 7

	feature --presentation constants

		UN_countries_number:INTEGER = 192 --number of United Nations countries at 1.1.2007

	feature --deployment constants

	--application configuration constants for deploying on Apache on Linux
		Data_path:STRING = "D:\Li\UserConverter\EIFGENs\dataconverter\W_code\"
		Form_action:STRING ="csardas.cgi"
		Form_action_admin:STRING ="csardas_admin.cgi"
		Submission_link:STRING = "csardas.cgi?submission=yes"

--	application configuration constants for deploying on Apache on Mac
--		Data_path:STRING = ""
--		Form_action:STRING ="/cgi-bin/informatics_europe.cgi"
--		Form_action_admin:STRING ="/cgi-bin/informatics_europe_admin.cgi"
--		Submission_link:STRING = "/cgi-bin/informatics_europe.cgi?submission=yes"

--	application configuration constants for deploying on Apache on both Mac and Linux
		Users_file_name:STRING= "user_list_data_file"
		Users_file_name2:STRING= "user_list_data_file2"
		Accepted_conference_list_data_file_name:STRING = "accepted_conference_list_data_file"
		Proposed_conference_list_data_file_name:STRING = "proposed_conference_list_data_file"
		Rejected_conference_list_data_file_name:STRING = "rejected_conference_list_data_file"
		Conference_id_generator_data_file_name:STRING = "conference_id_generator_data_file"
		Smtp_server:STRING = "localhost"
		Event_accepted_email_subject:STRING = "Informatics Europe: submitted event proposal information"
		Event_accepted_email_message:STRING = "Thank you for submitting your event announcement.%N%NIt has now been approved for listing and you will find it at%N%Nhttp://events.informatics-europe.org%N%NWe suggest that you link back to the site by including the following HTML code on the conference page:%N%N<p>This event is listed at the Computer Science Event List, <a href=%"http://events.informatics-europe.org%">events.informatics-europe.org</a></p>%N%NThanks and best wishes for the conference.%N%NThe Computer Science Event List team"
		Event_proposed_email_subject:STRING = "Informatics Europe: an event proposal has been submitted"
		Event_proposed_email_message:STRING = "Hello, %N%NAn event proposal has been just submitted.%N%NYou can review the event details at:%N%Nhttp://www.informatics-europe.org/cgi-bin/informatics_europe_admin.cgi%N%NThank you and Best Regards%N%NThe Site Editors"
		Admin_email:STRING = "conferences@informatics-europe.org"
		Css_path:STRING = "/css/docs.css"
		Img_path:STRING = "/img/"
		Main_website:STRING = "http://www.informatics-europe.org"
		Acknowledgements_page:STRING = "/acknowledgements.html"
end
