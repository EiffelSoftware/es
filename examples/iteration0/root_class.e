indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_CLASS

inherit
	OBSERVABLE

create
	make

feature -- Initialization

	make is
			-- Creation procedure.
		local
			bank: BANK
			atm: ATM
			ui: ATM_UI
			serializer: TEXT_SERIALIZER
		do
			-- XXX hm... where is a good place to configure the recorder?
			create serializer.make_on_textfile("run.log")
			recorder.set_serializer (serializer)

			recorder.capture_methodbody_start ("make", Current, [])
			-- Initialize everything and start the UI...
			create bank.make
			atm := bank.atm
			ui := atm.ui

			ui.run
			recorder.capture_methodbody_end (Void)
		end

	replay_include
		-- Feature to make sure, that the library classes
		-- for replay are included in the build.
		local
			event_factory: EVENT_FACTORY
			parser: TEXT_EVENT_PARSER
			input_stream: KL_TEXT_INPUT_FILE
			a: ANY
		do
			create input_stream.make("foo.bar")
			create event_factory
			create parser.make (input_stream, event_factory)

		end

feature --Access
end -- class ROOT_CLASS
