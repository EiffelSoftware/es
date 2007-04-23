indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RECORDER

create
	make

feature --creation

	make
			-- Create the recorder.
		do
			create observed_stack.make(200)
			observed_stack.put (False)
		end

feature -- Access

	observed_stack: ARRAYED_STACK [BOOLEAN]
			--Stack of the is_observed Values (TODO find a better description...)

feature -- Basic Operations

	capture_object (obj: ANY)
			-- capture 'obj'
		local
			test: INTERNAL
			id: IDENTIFIED
		do

			if obj = Void then
				print("Void")
			else
				print ("generating type: " + obj.generating_type + "%N")
				id ?= obj
				if (id /= Void) then
					print ("objectId: " + id.object_id.out + "%N")
				else
					print ("objectId: #ERROR(not IDENTIFIED) %N")
				end
			end
		end

	capture_methodbody_end (res: ANY)
			--Hook for recording. Is to be placed at the end of a MethodBody
			--'res' is the Result of the Method that should be instrumented.
		local
			current_observed: BOOLEAN
		do
			print ("$$MethodBodyEnd%N")
			current_observed := observed_stack.item
			observed_stack.remove
			if current_observed /= observed_stack.item then
				if current_observed then
					print ("INCALLRET")
				else
					print ("OUTCALLRET")
				end
				capture_object (res)
			end
			print("%N")
		end

	capture_methodbody_start (method_name: STRING_8; target: ANY; arguments: TUPLE)
			-- Hook for recording. Is to be placed before the methodbody is evaluated
			-- 'target' is the object whose feature was called
			-- 'arguments' are the arguments of the feature.
		require
			method_name_not_void: method_name /= Void
			target_not_void: target /= Void
			arguments_not_void: arguments /= Void
		do
			print ("$$MethodBodyStart: " + method_name + "%N")
			if (target.is_observed /= observed_stack.item) then
				if target.is_observed then
					print ("INCALL: "+ method_name + "%N" )
				else
					print ("OUTCALL" + method_name + "$N")
				end
				print ("%TArguments:%N")
				capture_arguments (arguments)
			end
			observed_stack.put (target.is_observed)
		end


feature {NONE} -- Implementation

	capture_arguments (arguments: TUPLE)
			--captures all 'argument_count' arguments of a method call, where
			--'first_argument' points to the first (i.e leftmost) of them.
		require
			arguments_not_void: arguments /= Void
		local
			i: INTEGER
		do
			from
				i := 0
			until
				i >= arguments.count
			loop
				print ("Argument:" + i.out + "%N")
				capture_object (arguments.item(i))

				i := i + 1
			end
		end

--	argument_for_position (stack_level: INTEGER_32; i: INTEGER_32): ANY
--			--Returns the 'i'th argument of the feature call on level
---			--'stack_level'. Returns void if the Argument is an
--			--expanded type.
--		external
--			"C signature (EIF_INTEGER,EIF_INTEGER):EIF_REFERENCE use recorder.h"
--		alias
--			"c_extract_argument"
--		end

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

invariant
	invariant_clause: True

end -- class RECORDER

