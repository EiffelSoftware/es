note
	description: "Summary description for {EV_APPLICATION_DELEGATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_APPLICATION_DELEGATE

inherit
	NS_OBJECT
		redefine
			make
		end

	NS_APPLICATION_DELEGATE_PROTOCOL
		redefine
			application_did_finish_launching_,
			application_should_terminate_after_last_window_closed_,
			application_will_terminate_
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			-- Add objc callbacks
			add_objc_callback ("applicationDidFinishLaunching:", agent application_did_finish_launching_)
			add_objc_callback ("applicationShouldTerminateAfterLastWindowClosed:", agent application_should_terminate_after_last_window_closed_)
			add_objc_callback ("applicationWillTerminate", agent application_will_terminate_)
			Precursor
		end

feature -- NS_APPLICATION_DELEGATE_PROTOCOL

	application_did_finish_launching_ (a_notification: NS_NOTIFICATION)
		do
--			print ("Application did finish launching%N")
		end

	application_should_terminate_after_last_window_closed_ (a_sender: NS_APPLICATION): BOOLEAN
		do
			Result := True
		end

	application_will_terminate_ (a_notification: NS_NOTIFICATION)
		do
			print ("Terminating application%N")
		end

end
