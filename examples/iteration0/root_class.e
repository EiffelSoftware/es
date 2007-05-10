indexing
	description: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_CLASS

create
	make

feature -- Initialization

--	create_logging_player(replay_filename:STRING; log_filename: STRING): LOGGING_PLAYER
--			--
--		local
--			ignore_result: CONTROLLER
--		do
--			create Result.make
--			ignore_result := set_controller (Result)
--			initialize_player (replay_filename,Result)
--			Result.set_recorder (create_recorder (log_filename))
--		end

--	create_player (filename: STRING): PLAYER
--			--
--		local
--			ignore_result: CONTROLLER
--		do
--			create Result.make
--			ignore_result := set_controller (Result)
--			initialize_player (filename,Result)
--		end

--	create_recorder (filename: STRING_8): RECORDER
--			--
--		local
--			serializer: TEXT_SERIALIZER
--			ignore_result: CONTROLLER
--		do
--			create Result.make
--			ignore_result := set_controller (Result)
--			create serializer.make_on_textfile (filename)
--			Result.set_serializer (serializer)
--			Result.set_capture_replay_enabled (True)
--		end

--	initialize_player (filename: STRING; p: PLAYER)
--			--
--		local
--			resolver: ENTITY_RESOLVER
--			event_factory: EVENT_FACTORY
--			parser: TEXT_EVENT_PARSER
--			input_file: KL_TEXT_INPUT_FILE
--			caller: EXAMPLE_CALLER
--		do
--			create caller
--			create resolver.make
--			create event_factory
--			create input_file.make (filename)
--			input_file.open_read
--			create parser.make (input_file, event_factory)
--			p.set_caller (caller)
--			p.set_event_factory (event_factory)
--			p.set_resolver (resolver)
--		end

	make
			-- Creation procedure.
		local
			recorder: RECORDER
			player: PLAYER
			logging_player: LOGGING_PLAYER

			caller: EXAMPLE_CALLER

			bank: BANK
			atm: ATM
			ui: ATM_UI
			mode: INTEGER_32
			test_performance: BOOLEAN
			ignore_result: ANY
		do
			mode := replay_logged
			inspect mode
			when capture then
				create recorder.make
				recorder.setup_on_text_serializer ("run.log")
			when replay_simple then
				create player.make
				create caller
				player.setup_on_text_file ("run.log", caller)
				player.play
			when replay_logged then
				create logging_player.make
				create caller
				logging_player.setup_on_text_files ("run.log", "replay_run.log", caller)
				player.play
			when performance_test_normal then
				create recorder.make --run with not set-up recorder == without instrumentation.
				test_performance := True
			when performance_test_capture then
				create recorder.make
				recorder.setup_on_text_serializer ("run.log")
				test_performance := True
			else
				print ("executing a normal run of the application.")
			end
			test_performance := False
			if controller.is_capture_replay_enabled then
				controller.methodbody_start ("make", Current, [])
			end
			if (not controller.is_replay_phase) or is_observed then
				create bank.make
				atm := bank.atm
				if test_performance then
					create {PERFORMANCE_TESTER_ATM_UI} ui.make (atm)
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
			create input_stream.make ("foo.bar")
			create event_factory
			create parser.make (input_stream, event_factory)
		end


feature --Access
-- Modes for the example application:

	capture: INTEGER_32 is unique

	normal_run: INTEGER_32 is unique

	performance_test_capture: INTEGER_32 is unique

	performance_test_normal: INTEGER_32 is unique

	replay_logged: INTEGER_32 is unique

	replay_simple: INTEGER_32 is unique

invariant
		-- from OBSERVABLE
	invariant_clause: True

end -- class ROOT_CLASS

