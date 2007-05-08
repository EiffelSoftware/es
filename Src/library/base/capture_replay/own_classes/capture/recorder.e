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

feature --creation

	make
			-- Create the controller.
		do
			create observed_stack.make(200)
			observed_stack.put (False)
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
			--set `debug_output'
		do
			debug_output := new_debug_output
		ensure
			new_debug_output_set: debug_output = new_debug_output
		end

feature -- Basic Operations

	methodbody_end (res: ANY): ANY
			-- See comment in CONTROLLER
--		require
--			serializer_not_void: serializer /= Void
		local
			current_observed: BOOLEAN
		do
--opt			print_debug ("{REC}:MethodBodyEnd%N")
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
		end

	methodbody_start (feature_name: STRING_8; target: ANY; arguments: TUPLE)
			-- Hook for recording. Is to be placed before the methodbody is evaluated
			-- 'target' is the object whose feature was called
			-- 'arguments' are the arguments of the feature.
--		require
--			feature_name_not_void: feature_name /= Void
--			target_not_void: target /= Void
--			arguments_not_void: arguments /= Void
--			serializer_not_void: serializer /= Void
		do
--opt			print_debug ("{REC}: MethodBodyStart: " + feature_name + "%N")
			if (target.is_observed /= observed_stack.item) then
				if target.is_observed then
					serializer.write_incall (feature_name, target, arguments)
				else
					serializer.write_outcall (feature_name, target, arguments)
				end
			end
			observed_stack.put (target.is_observed)
		end

	set_serializer(a_serializer: CAPTURE_SERIALIZER)
			-- Set the serializer to `a_serializer'
		do
			serializer := a_serializer
		end

feature {NONE} -- Implementation

-- For optimization - purposes removed.
--		print_debug(message: STRING)
--				-- Print a debug message if debug_output is enabled
--			do
--				if debug_output then
--					print("{REC}" +message)
--				end
--			end


feature --test

feature --RUBBISH
	expanded_test: ANY
			--test to see how eiffel converts an expanded type to any.
		local
			da_real: REAL
		do
			da_real:=5
			Result:=da_real
		end

--	object_from_pointer (p: POINTER): ANY
--			--returns the Eiffel object that 'p' points to.
--		external
--			"C inline use %"eif_eiffel.h%""
--		alias
--			"return (EIF_REFERENCE) $p;"
--		end

-- Not needed: for he prototype implemented in stack.c...
--	stack_offset(depth: INTEGER_32): INTEGER_32
--		external
--			"C signature(EIF_INTEGER):EIF_REFERENCE"
--		alias
--			"c_get_stack_offset"
--		end

--	argument_for_position (stack_level: INTEGER_32; i: INTEGER_32): ANY
--			--Returns the 'i'th argument of the feature call on level
---			--'stack_level'. Returns void if the Argument is an
--			--expanded type.
--		external
--			"C signature (EIF_INTEGER,EIF_INTEGER):EIF_REFERENCE use controller.h"
--		alias
--			"c_extract_argument"
--		end

--	capture_object (obj: ANY)
--			-- capture 'obj'
--		local
--			test: INTERNAL
--			id: IDENTIFIED
--		do

--			if obj = Void then
--				print("Void")
--			else
--				print ("generating type: " + obj.generating_type + "%N")
--				id ?= obj
--				if (id /= Void) then
--					print ("objectId: " + id.object_id.out + "%N")
--				else
--					print ("objectId: #ERROR(not IDENTIFIED) %N")
--				end
--			end
--		end

invariant
	observed_stack_not_void: observed_stack /= Void
	observed_stack_not_empty: not observed_stack.is_empty

end -- class RECORDER

