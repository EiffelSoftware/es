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
			a_recorder: RECORDER
			a_player: PLAYER

			bank: BANK
			atm: ATM
			ui: ATM_UI
			serializer: TEXT_SERIALIZER
			test_performance: BOOLEAN
			capture_replay: BOOLEAN
			replay_phase: BOOLEAN

			caller: EXAMPLE_CALLER
			player: PLAYER
			resolver: ENTITY_RESOLVER
			event_factory: EVENT_FACTORY
			parser: TEXT_EVENT_PARSER
			input_file: KL_TEXT_INPUT_FILE

			ignore_Result: ANY
		do
			test_performance := False
			capture_replay := True
			replay_phase := False

			if capture_replay then
				if replay_phase then
					create a_player.make

					a_player ?= set_controller(a_player)

					create caller
					create resolver.make
					create event_factory
		        	create input_file.make("run.log")
					input_file.open_read

					create parser.make (input_file, event_factory)

					player ?= controller
					player.set_caller (caller)
					player.set_event_factory (event_factory)
					player.set_resolver (resolver)
					player.play
				else
					create a_recorder.make
					a_recorder ?= set_controller(a_recorder)
					--capture phase

					check
						controller_is_recorder: a_recorder /= Void
					end
					 -- XXX hm... where is a good place to configure the controller?
					create serializer.make_on_textfile("run.log")
					a_recorder.set_serializer (serializer)
					a_recorder.set_capture_replay_enabled(True)
				end

				controller.set_capture_replay_enabled (True)
				controller.set_replay_phase (replay_phase)
			end

			if controller.is_capture_replay_enabled then
					controller.methodbody_start ("make", Current, [])
			end
			if (not controller.is_replay_phase) or is_observed then
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
			end
			if controller.is_capture_replay_enabled then
				ignore_result := controller.methodbody_end (Void)
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
