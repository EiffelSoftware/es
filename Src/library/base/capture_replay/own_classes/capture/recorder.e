indexing
	description: "[
					Central recording instance for the capture-phase.
				]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	RECORDER

inherit
	CONTROLLER

create
	make

feature -- Initialization
	setup_on_text_serializer (filename: STRING) is
			-- Create a recorder based on a TEXT_SERIALIZER on the file `filename'
		do
			create {TEXT_SERIALIZER}serializer.make_on_textfile (filename)

			set_capture_replay_enabled(True)
		end



feature -- Access

	serializer: CAPTURE_SERIALIZER
			-- Serializer that is used for recording

	debug_output: BOOLEAN
			-- Is debug output enabled?

	in_observed_part: BOOLEAN is
			-- Is the program execution currently in the observed part?
			do
				Result := observed_stack.item
			end

feature -- Status change
	set_debug_output(new_debug_output: BOOLEAN)
			-- Set `debug_output'
		do
			debug_output := new_debug_output
		ensure
			new_debug_output_set: debug_output = new_debug_output
		end

feature -- Basic Operations

	methodbody_end (res: ANY): ANY
			-- Record a feature_exit - event
		local
			current_observed: BOOLEAN
		do
			enter
			current_observed := observed_stack.item
			observed_stack.remove
			if current_observed /= observed_stack.item then
				if current_observed then
					serializer.write_incallret (res)
				else
					serializer.write_outcallret (res)
				end
			end
			Result := res
			leave
		end

	methodbody_start (feature_name: STRING_8; target: OBSERVABLE; arguments: TUPLE)
			-- Record a feature_invoke - event.
		do
			enter
			--opt print_debug ("{REC}: MethodBodyStart: " + feature_name + "%N")
			if (target.is_observed /= observed_stack.item) then
				if target.is_observed then
					serializer.write_incall (feature_name, target, arguments)
				else
					serializer.write_outcall (feature_name, target, arguments)
				end
			end
			observed_stack.put (target.is_observed)
			leave
		end

	set_serializer(a_serializer: CAPTURE_SERIALIZER)
			-- Set the serializer to `a_serializer'
		do
			serializer := a_serializer
		end

feature {NONE} -- Implementation

		print_debug(message: STRING)
				-- Print a debug message if debug_output is enabled
			do
				if debug_output then
					print("{REC}" +message)
				end
			end

invariant
	observed_stack_not_void: observed_stack /= Void
	observed_stack_not_empty: not observed_stack.is_empty
	serializer_not_void: serializer /= Void

end -- class RECORDER

