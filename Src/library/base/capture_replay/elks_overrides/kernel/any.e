indexing

	description: "[
		Project-wide universal properties.
		This class is an ancestor to all developer-written classes.
		ANY may be customized for individual projects or teams.
		]"

	library: "Free implementation of ELKS library"
	copyright: "Copyright (c) 1986-2004, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class
	ANY

feature -- Customization

feature -- Access

	generator: STRING is
			-- Name of current object's generating class
			-- (base class of the type of which it is a direct instance)
		external
			"built_in"
		ensure
			generator_not_void: Result /= Void
			generator_not_empty: not Result.is_empty
		end

 	generating_type: STRING is
			-- Name of current object's generating type
			-- (type of which it is a direct instance)
		external
			"built_in"
 		ensure
 			generating_type_not_void: Result /= Void
			generating_type_not_empty: not Result.is_empty
 		end

feature -- Status report

	conforms_to (other: ANY): BOOLEAN is
			-- Does type of current object conform to type
			-- of `other' (as per Eiffel: The Language, chapter 13)?
		require
			other_not_void: other /= Void
		external
			"built_in"
		end

	same_type (other: ANY): BOOLEAN is
			-- Is type of current object identical to type of `other'?
		require
			other_not_void: other /= Void
		external
			"built_in"
		ensure
			definition: Result = (conforms_to (other) and
										other.conforms_to (Current))
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Is `other' attached to an object considered
			-- equal to current object?
		require
			other_not_void: other /= Void
		do
			Result := standard_is_equal (other)
		ensure
			symmetric: Result implies other.is_equal (Current)
			consistent: standard_is_equal (other) implies Result
		end

	frozen standard_is_equal (other: like Current): BOOLEAN is
			-- Is `other' attached to an object of the same type
			-- as current object, and field-by-field identical to it?
		require
			other_not_void: other /= Void
		external
			"built_in"
		ensure
			same_type: Result implies same_type (other)
			symmetric: Result implies other.standard_is_equal (Current)
		end

	frozen equal (some: ANY; other: like some): BOOLEAN is
			-- Are `some' and `other' either both void or attached
			-- to objects considered equal?
		do
			if some = Void then
				Result := other = Void
			else
				Result := other /= Void and then
							some.is_equal (other)
			end
		ensure
			definition: Result = (some = Void and other = Void) or else
						((some /= Void and other /= Void) and then
						some.is_equal (other))
		end

	frozen standard_equal (some: ANY; other: like some): BOOLEAN is
			-- Are `some' and `other' either both void or attached to
			-- field-by-field identical objects of the same type?
			-- Always uses default object comparison criterion.
		do
			if some = Void then
				Result := other = Void
			else
				Result := other /= Void and then
							some.standard_is_equal (other)
			end
		ensure
			definition: Result = (some = Void and other = Void) or else
						((some /= Void and other /= Void) and then
						some.standard_is_equal (other))
		end

	frozen is_deep_equal (other: like Current): BOOLEAN is
			-- Are `Current' and `other' attached to isomorphic object structures?
		require
			other_not_void: other /= Void
		external
			"built_in"
		ensure
			shallow_implies_deep: standard_is_equal (other) implies Result
			same_type: Result implies same_type (other)
			symmetric: Result implies other.is_deep_equal (Current)
		end

	frozen deep_equal (some: ANY; other: like some): BOOLEAN is
			-- Are `some' and `other' either both void
			-- or attached to isomorphic object structures?
		do
			if some = Void then
				Result := other = Void
			else
				Result := other /= Void and then some.is_deep_equal (other)
			end
		ensure
			shallow_implies_deep: standard_equal (some, other) implies Result
			both_or_none_void: (some = Void) implies (Result = (other = Void))
			same_type: (Result and (some /= Void)) implies some.same_type (other)
			symmetric: Result implies deep_equal (other, some)
		end

feature -- Duplication

	frozen twin: like Current is
			-- New object equal to `Current'
			-- `twin' calls `copy'; to change copying/twining semantics, redefine `copy'.
		external
			"built_in"
		ensure
			twin_not_void: Result /= Void
			is_equal: Result.is_equal (Current)
		end

	copy (other: like Current) is
			-- Update current object using fields of object attached
			-- to `other', so as to yield equal objects.
		require
			other_not_void: other /= Void
			type_identity: same_type (other)
		external
			"built_in"
		ensure
			is_equal: is_equal (other)
		end

	frozen standard_copy (other: like Current) is
			-- Copy every field of `other' onto corresponding field
			-- of current object.
		require
			other_not_void: other /= Void
			type_identity: same_type (other)
		external
			"built_in"
		ensure
			is_standard_equal: standard_is_equal (other)
		end

	frozen clone (other: ANY): like other is
			-- Void if `other' is void; otherwise new object
			-- equal to `other'
			--
			-- For non-void `other', `clone' calls `copy';
		 	-- to change copying/cloning semantics, redefine `copy'.
		obsolete
			"Use `twin' instead."
		do
			if other /= Void then
				Result := other.twin
			end
		ensure
			equal: equal (Result, other)
		end

	frozen standard_clone (other: ANY): like other is
			-- Void if `other' is void; otherwise new object
			-- field-by-field identical to `other'.
			-- Always uses default copying semantics.
		obsolete
			"Use `standard_twin' instead."
		do
			if other /= Void then
				Result := other.standard_twin
			end
		ensure
			equal: standard_equal (Result, other)
		end

	frozen standard_twin: like Current is
			-- New object field-by-field identical to `other'.
			-- Always uses default copying semantics.
		external
			"built_in"
		ensure
			standard_twin_not_void: Result /= Void
			equal: standard_equal (Result, Current)
		end

	frozen deep_twin: like Current is
			-- New object structure recursively duplicated from Current.
		external
			"built_in"
		ensure
			deep_twin_not_void: Result /= Void
			deep_equal: deep_equal (Current, Result)
		end

	frozen deep_clone (other: ANY): like other is
			-- Void if `other' is void: otherwise, new object structure
			-- recursively duplicated from the one attached to `other'
		obsolete
			"Use `deep_twin' instead."
		do
			if other /= Void then
				Result := other.deep_twin
			end
		ensure
			deep_equal: deep_equal (other, Result)
		end

	frozen deep_copy (other: like Current) is
			-- Effect equivalent to that of:
			--		`copy' (`other' . `deep_twin')
		require
			other_not_void: other /= Void
		do
			copy (other.deep_twin)
		ensure
			deep_equal: deep_equal (Current, other)
		end

feature {NONE} -- Retrieval

	frozen internal_correct_mismatch is
			-- Called from runtime to perform a proper dynamic dispatch on `correct_mismatch'
			-- from MISMATCH_CORRECTOR.
		local
			l_corrector: MISMATCH_CORRECTOR
			l_msg: STRING
			l_exc: EXCEPTIONS
		do
			l_corrector ?= Current
			if l_corrector /= Void then
				l_corrector.correct_mismatch
			else
				create l_msg.make_from_string ("Mismatch: ")
				create l_exc
				l_msg.append (generating_type)
				l_exc.raise_retrieval_exception (l_msg)
			end
		end

feature -- Output

	io: STD_FILES is
			-- Handle to standard file setup
		once
			create Result
			Result.set_output_default
		ensure
			io_not_void: Result /= Void
		end

	out: STRING is
			-- New string containing terse printable representation
			-- of current object
		do
			Result := tagged_out
		ensure
			out_not_void: Result /= Void
		end

	frozen tagged_out: STRING is
			-- New string containing terse printable representation
			-- of current object
		external
			"built_in"
		ensure
			tagged_out_not_void: Result /= Void
		end

	print (some: ANY) is
			-- Write terse external representation of `some'
			-- on standard output.
		do
			if some /= Void then
				io.put_string (some.out)
			end
		end

feature -- Platform

	Operating_environment: OPERATING_ENVIRONMENT is
			-- Objects available from the operating system
		once
			create Result
		ensure
			operating_environment_not_void: Result /= Void
		end

feature {NONE} -- Initialization

	default_create is
			-- Process instances of classes with no creation clause.
			-- (Default: do nothing.)
		do
		end

feature -- Basic operations

	default_rescue is
			-- Process exception for routines with no Rescue clause.
			-- (Default: do nothing.)
		do
		end

	frozen do_nothing is
			-- Execute a null action.
		do
		end

	frozen default: like Current is
			-- Default value of object's type
		do
		end

	frozen default_pointer: POINTER is
			-- Default value of type `POINTER'
			-- (Avoid the need to write `p'.`default' for
			-- some `p' of type `POINTER'.)
		do
		ensure
			-- Result = Result.default
		end

feature -- Capture/Replay

	program_flow_sink: PROGRAM_FLOW_SINK
			-- Recorder for capturing events on the object
			-- `set_controller' needs to be executed before this feature is called.
		local
			environment: EXECUTION_ENVIRONMENT
			mode: STRING
		once
			create {NULL_PROGRAM_FLOW_SINK}Result
			create environment
			mode := environment.get("CR_MODE")
			if mode = Void then
				print("*'cr_mode' not defined. Using NULL_PROGRAM_FLOW_SINK to disable capture_replay.%N")
				--sink already created.
			elseif mode.is_case_insensitive_equal (mode_capture) then
				print("* Capture activated%N")
				create {RECORDER}Result.make
			elseif mode.is_case_insensitive_equal (mode_replay) then
				print("* Replay activated%N")
				create {PLAYER}Result.make
			elseif mode.is_case_insensitive_equal (mode_log_replay) then
				print("* Replay with logging player activated.%N")
				create {LOGGING_PLAYER}Result.make
			else
				print("'cr_mode' = '" + mode + "' is not a recognized Value.")
			end
		ensure
			Result_not_void: Result /= Void
		end

	is_observed: BOOLEAN
			-- Is this object observed?
			-- Classes that belong to the observed
			-- set should override this.
		once
			Result := True
		end

	--XXX copying of objects not yet supported (object ID needs to be reset after copy.)
	cr_object_id: INTEGER_32 is
			--
		local
			obj_id: INTEGER_32
		do
			obj_id := c_object_id ($Current)
			if  obj_id = 0 then
					-- Set the object ID to the next available value.
				obj_id := cr_global_object_id.item
				cr_set_object_id (obj_id)
				cr_global_object_id.set_item (cr_global_object_id.item + 1)
			end

			Result := obj_id
		end

	cr_set_object_id (new_id: INTEGER_32) is
			--
		do
			c_set_object_id ($Current, new_id)
		end


feature {NONE} -- Implementation

	mode_replay:STRING is "replay"

	mode_capture: STRING is "capture"

	mode_log_replay: STRING is "log_replay"

	mode_proxy: STRING is "proxy"

	c_object_id(object: POINTER): INTEGER_32 is
			--
		external
			"C inline use <eif_malloc.h>"
		alias
			"*(OBJECT_ID_TYPE *)($object + (HEADER($object)->ov_size & B_SIZE) - sizeof(OBJECT_ID_TYPE))"
		end

	c_set_object_id(object: POINTER; value: INTEGER_32) is
			--
		external
			"C inline use <eif_malloc.h>"
		alias
			"*(OBJECT_ID_TYPE *)($object + (HEADER($object)->ov_size & B_SIZE) - sizeof(OBJECT_ID_TYPE)) = $value"
		end

	cr_global_object_id: INTEGER_32_REF is
			-- The next free ID.
		once
			create Result
			Result.set_item(1)
		end

invariant
	reflexive_equality: standard_is_equal (Current)
	reflexive_conformance: conforms_to (Current)

end
