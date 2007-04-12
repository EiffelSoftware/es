indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RECORDER

create
	make

feature {NONE} -- Initialization


feature -- Access

	is_observed: LINKED_STACK [BOOLEAN]
			--Stack of the is_observed Values (TODO find a better description...)

feature -- Comparison

feature -- Status report

feature -- Duplication

feature -- Miscellaneous

	capture_arguments (argument_count: INTEGER_32)
			--captures all 'argument_count' arguments of a method call, where
			--'first_argument' points to the first (i.e leftmost) of them.
		require
			argument_count_valid: argument_count >= 0
		local
			i: INTEGER_32
			offset: INTEGER_32
		do
			from
				i := 0
			until
				i >= argument_count
			loop
				print ("Capture Arguments:" + i.out + "%N")
				--1== 'get_argument'
				--2 == 'capture_arguments'
				--3 == 'methodbodystart' YES!!!
				--4 == observed method.
				capture_object (get_argument (4, i))--methodbodystart, this method  and get_argument down the stack...
				i := i + 1
			end
		end

	capture_object (obj: ANY)
			--captures one object.
		require
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

	get_argument (stack_level: INTEGER_32; i: INTEGER_32): ANY
			--Returns the 'i'th argument of the feature call on level
			--'stack_level'. Returns void if the Argument is an
			--expanded type.
		external
			"C signature (EIF_INTEGER,EIF_INTEGER):EIF_REFERENCE use recorder.h"
		alias
			"c_extract_argument"
		end

	methodbodyend (res: ANY)
			--Hook for recording. Is to be placed at the end of a MethodBody
			--'res' is the Result of the Method that should be instrumented.
		local
			current_observed: BOOLEAN
		do
			print ("$$MethodBodyEnd%N")
			current_observed := is_observed.item
			is_observed.remove
			if current_observed /= is_observed.item then
				if current_observed then
					print ("INCALLRET")
				else
					print ("OUTCALLRET")
				end
				capture_object (res)
			end
			print("%N")
		end

	methodbodystart (method_name: STRING_8; target: OBSERVABLE; argument_count: INTEGER_32)
			-- Hook for recording. Is to be placed before the methodbody is evaluated
			-- 'first_argument' points to the first argument (on the stack) of the routine
			-- argument_count is the number of arguments of the routine
		require
			method_name_not_void: method_name /= Void
			argument_count_valid: argument_count >= 0
		local
			obj: ANY
		do

			print ("$$MethodBodyStart: " + method_name + "%N")
			if (target.is_observed /= is_observed.item) then
				if target.is_observed then
					print ("INCALL: "+ method_name + "%N" )
				else
					print ("OUTCALL" + method_name + "$N")
				end
				print ("%TArguments:%N")
				capture_arguments (argument_count -1) --XXX change argument count in the hooks...
			end
			is_observed.put (target.is_observed)
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

feature -- Basic operations

feature -- Access bits size


feature -- Access bytes size


feature -- Access min max values


feature -- Output



feature {NONE} -- Retrieval

feature --test

feature --RUBBISH

	bar
			--
		local
			exc: EXCEPTIONS
		do
			create exc
			exc.raise ("Hello World")
		end

	c_getcaller: ANY
		external
			"C signature ():EIF_OBJECT use recorder.h"
		alias
			"getCaller"
		end

	foo: ANY
			--
		local
			second_run: BOOLEAN
		do
			if not second_run then
				bar
			end
			Result := Current
		rescue
			print ("exception caught...")
			second_run := True
			retry
		end

feature --creation

	make
			--
		do
			create is_observed.make
			is_observed.put (False)
		end

invariant
	invariant_clause: True

		-- from ANY
	reflexive_equality: standard_is_equal (Current)
	reflexive_conformance: conforms_to (Current)

end -- class RECORDER

