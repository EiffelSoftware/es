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
			test_performance: BOOLEAN
			ptui: PERFORMANCE_TESTER_ATM_UI
		do
			test_performance := True

			-- XXX hm... where is a good place to configure the recorder?
			create serializer.make_on_textfile("run.log")
			recorder.set_serializer (serializer)
			recorder.set_capture_replay(True)

			if recorder.capture_replay then
--				if recorder.in_observed_part /= is_observed then --boundary cross...
					recorder.capture_methodbody_start ("make", Current, [])
--				end
--				recorder.put_is_observed(is_observed)
			end

			-- Initialize everything and start the UI...
			create bank.make
			atm := bank.atm
			if test_performance then
				create {PERFORMANCE_TESTER_ATM_UI}ui.make(atm)
				atm.set_ui (ui)
			else
				ui := atm.ui
			end

			ui.run

			if recorder.capture_replay then
--				recorder.remove_is_observed
--				if recorder.in_observed_part /= is_observed then
					recorder.capture_methodbody_end (Void)
--				end
			end
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
