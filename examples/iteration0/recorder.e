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

	capturearguments (first_argument: POINTER; argument_count: INTEGER_32)
			--captures all 'argument_count' arguments of a method call, where
			--'first_argument' points to the first (i.e leftmost) of them.
		require
			first_argument_not_void: first_argument /= Void
			argument_count_valid: argument_count > 0
		local
			i: INTEGER_32
		do
			from
				i := 0
			until
				i >= argument_count
			loop
				print ("Capture Arguments:" + i.out + "%N")
				captureobject (get_argument (first_argument, i))
				i := i + 1
			end
		end

	captureobject (obj: ANY)
			--captures one object.
		require
		local
			test: INTERNAL
			id: IDENTIFIED
		do
			--create test.make

			--test.

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

	get_argument (first_argument: POINTER; i: INTEGER_32): ANY
			--Returns the 'i'th argument of a feature call or void if the Argument is an
			--expanded type.'first_argument' points to
			--the first argument of the feature call.
		external
			"C signature (EIF_POINTER,EIF_INTEGER):EIF_REFERENCE use recorder.h"
		alias
			"c_extract_argument"
		end

	methodbodyend (res: ANY)
			--Hook for recording. Is to be placed at the end of a MethodBody
			--'res' is the Result of the Method that should be instrumented.
		local
			current_observed: BOOLEAN
		do
--			print ("$$MethodBodyEnd")
			current_observed := is_observed.item
			is_observed.remove
			if current_observed /= is_observed.item then
				if current_observed then
					print ("INCALLRET")
				else
					print ("OUTCALLRET")
				end
				captureobject (res)
			end
			print("%N")
		end

	methodbodystart (method_name: STRING_8; first_argument: POINTER; argument_count: INTEGER_32)
			-- Hook for recording. Is to be placed before the methodbody is evaluated
			-- 'first_argument' points to the first argument (on the stack) of the routine
			-- argument_count is the number of arguments of the routine
		require
			method_name_not_void: method_name /= Void
		--	first_argument_not_void: first_argument /= Void
			argument_count_valid: argument_count > 0
		local
			obj: ANY
			target: OBSERVABLE
		do
--			print ("$$MethodBodyStart: " + method_name + "%N")
			obj := get_argument (first_argument, 0)
			target ?= obj
			check
				target_not_void: target /= Void
			end
			if (target.is_observed /= is_observed.item) then
				if target.is_observed then
					print ("INCALL: "+ method_name + "%N" )
				else
					print ("OUTCALL" + method_name + "$N")
				end
				print ("%TArguments:%N")
				capturearguments (first_argument, argument_count)
			end
			is_observed.put (target.is_observed)
		end

	object_from_pointer (p: POINTER): ANY
			--returns the Eiffel object that 'p' points to.
		external
			"C inline use %"eif_eiffel.h%""
		alias
			"return (EIF_REFERENCE) $p;"
		end

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

