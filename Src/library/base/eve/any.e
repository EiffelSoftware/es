note
	description: "[
		Project-wide universal properties.
		This class is an ancestor to all developer-written classes.
		ANY may be customized for individual projects or teams.
		]"

	library: "EVE base library"
	status: "See notice at end of class."
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ANY

feature -- Customization

feature -- Access

	generator: STRING
			-- Name of current object's generating class
			-- (base class of the type of which it is a direct instance)
		external
			"built_in"
		ensure
			generator_not_void: Result /= Void
			generator_not_empty: not Result.is_empty
		end

	generating_type: TYPE [detachable like Current]
			-- Type of current object
			-- (type of which it is a direct instance)
		do
			Result := {detachable like Current}
 		ensure
 			generating_type_not_void: Result /= Void
 		end

feature -- Status report

	conforms_to (other: ANY): BOOLEAN
			-- Does type of current object conform to type
			-- of `other' (as per Eiffel: The Language, chapter 13)?
		require
			other_not_void: other /= Void
		external
			"built_in"
		end

	same_type (other: ANY): BOOLEAN
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

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		require
			other_not_void: other /= Void
		external
			"built_in"
		end

	is_equal_ (other: like Current): BOOLEAN
			-- Is the abstract state of Current equal to that of `other'?
		note
			explicit: contracts
		require
--			same_type: generating_type = other.generating_type
			closed: closed
			other_closed: other.closed
			subjects_closed: across subjects as s all s.item.closed end
			other_subjects_closed: across other.subjects as s all s.item.closed end
		do
			Result := True
		ensure
			definition: Result = is_model_equal (other)
		end

	frozen standard_is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object of the same type
			-- as current object, and field-by-field identical to it?
		require
			other_not_void: other /= Void
		external
			"built_in"
		end

	frozen equal (a: detachable ANY; b: like a): BOOLEAN
			-- Are `a' and `b' either both void or attached
			-- to objects considered equal?
		do
			if a = Void then
				Result := b = Void
			else
				Result := b /= Void and then
							a.is_equal (b)
			end
		end

	frozen equal_ (x, y: ANY): BOOLEAN
		note
			explicit: contracts
		require
			x_void_or_closed: attached x implies x.closed
			y_void_or_closed: attached y implies y.closed
			x_subjects_closed: attached x implies across x.subjects as s all s.item.closed end
			y_subjects_closed: attached y implies across y.subjects as s all s.item.closed end
		do
			if x = Void then
				Result := y = Void
			elseif x.generating_type = y.generating_type then
				Result := x.is_equal_ (y)
			end
		ensure
			Result = model_equals (x, y)
		end

	frozen standard_equal (a: detachable ANY; b: like a): BOOLEAN
			-- Are `a' and `b' either both void or attached to
			-- field-by-field identical objects of the same type?
			-- Always uses default object comparison criterion.
		do
			if a = Void then
				Result := b = Void
			else
				Result := b /= Void and then
							a.standard_is_equal (b)
			end
		end

	frozen is_deep_equal (other: like Current): BOOLEAN
			-- Are `Current' and `other' attached to isomorphic object structures?
		require
			other_not_void: other /= Void
		external
			"built_in"
		end

	frozen deep_equal (a: detachable ANY; b: like a): BOOLEAN
			-- Are `a' and `b' either both void
			-- or attached to isomorphic object structures?
		do
			if a = Void then
				Result := b = Void
			else
				Result := b /= Void and then a.is_deep_equal (b)
			end
		end

feature -- Duplication

	frozen twin: like Current
			-- New object equal to `Current'
			-- `twin' calls `copy'; to change copying/twining semantics, redefine `copy'.
		external
			"built_in"
		ensure
			twin_not_void: Result /= Void
			is_equal: Result ~ Current
		end

	copy (other: like Current)
			-- Update current object using fields of object attached
			-- to `other', so as to yield equal objects.
		require
			other_not_void: other /= Void
			type_identity: same_type (other)
		external
			"built_in"
		ensure
			is_equal: Current ~ other
		end

	frozen standard_copy (other: like Current)
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

	frozen clone (other: detachable ANY): like other
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
			equal: Result ~ other
		end

	frozen standard_clone (other: detachable ANY): like other
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

	frozen standard_twin: like Current
			-- New object field-by-field identical to `other'.
			-- Always uses default copying semantics.
		external
			"built_in"
		ensure
			standard_twin_not_void: Result /= Void
			equal: standard_equal (Result, Current)
		end

	frozen deep_twin: like Current
			-- New object structure recursively duplicated from Current.
		external
			"built_in"
		ensure
			deep_twin_not_void: Result /= Void
			deep_equal: deep_equal (Current, Result)
		end

	frozen deep_clone (other: detachable ANY): like other
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

	frozen deep_copy (other: like Current)
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

	frozen internal_correct_mismatch
			-- Called from runtime to perform a proper dynamic dispatch on `correct_mismatch'
			-- from MISMATCH_CORRECTOR.
		local
			l_msg: STRING
			l_exc: EXCEPTIONS
		do
			if attached {MISMATCH_CORRECTOR} Current as l_corrector then
				l_corrector.correct_mismatch
			else
				create l_msg.make_from_string ("Mismatch: ")
				create l_exc
				l_msg.append (generating_type.name)
				l_exc.raise_retrieval_exception (l_msg)
			end
		end

feature -- Output

	io: STD_FILES
			-- Handle to standard file setup
		once
			create Result
			Result.set_output_default
		ensure
			io_not_void: Result /= Void
		end

	out: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			Result := tagged_out
		ensure
			out_not_void: Result /= Void
		end

	frozen tagged_out: STRING
			-- New string containing terse printable representation
			-- of current object
		external
			"built_in"
		ensure
			tagged_out_not_void: Result /= Void
		end

	print (o: detachable ANY)
			-- Write terse external representation of `o'
			-- on standard output.
		do
			if o /= Void then
				io.put_string (o.out)
			end
		end

feature -- Platform

	Operating_environment: OPERATING_ENVIRONMENT
			-- Objects available from the operating system
		once
			create Result
		ensure
			operating_environment_not_void: Result /= Void
		end

feature {NONE} -- Initialization

	default_create
			-- Process instances of classes with no creation clause.
			-- (Default: do nothing.)
		note
			status: creator
		do
		end

feature -- Basic operations

	default_rescue
			-- Process exception for routines with no Rescue clause.
			-- (Default: do nothing.)
		do
		end

	frozen do_nothing
			-- Execute a null action.
		note
			explicit: contracts, wrapping
		require
			modify ([])
		do
		end

	frozen default: detachable like Current
			-- Default value of object's type
		do
		end

	frozen default_pointer: POINTER
			-- Default value of type `POINTER'
			-- (Avoid the need to write `p'.`default' for
			-- some `p' of type `POINTER'.)
		do
		ensure
			-- Result = Result.default
		end

	frozen as_attached: attached like Current
			-- Attached version of Current
			-- (Can be used during transitional period to convert
			-- non-void-safe classes to void-safe ones.)
		do
			Result := Current
		end

feature -- SCOOP
	frozen set_handler_active (a_obj: separate ANY)
			--
		external
			"C inline use %"eif_macros.h%""
		alias
			"EIF_SET_ACTIVE(eif_access($a_obj))"
		end

	frozen set_handler_passive (a_obj: separate ANY)
			--
		external
			"C inline use %"eif_macros.h%""
		alias
			"EIF_SET_PASSIVE(eif_access($a_obj))"
		end

feature -- Verification: contract clauses

	frozen modify (a_objects: TUPLE): BOOLEAN
			-- Does this routine modify `a_objects'?
		do
			Result := True
		end

	frozen modify_field (a_fields: ANY; a_objects: TUPLE): BOOLEAN
			-- Does this routine modify attributes `a_fields' of objects in `a_objects'?
		do
			Result := True
		end

	frozen modify_model (a_models: ANY; a_objects: TUPLE): BOOLEAN
			-- Does this routine modify model queries `a_models' of objects in `a_objects'?
		do
			Result := True
		end

	frozen reads (a_objects: TUPLE): BOOLEAN
			-- Does this function read `a_objects'?
		do
			Result := True
		end

	frozen reads_field (a_fields: ANY; a_objects: TUPLE): BOOLEAN
			-- Does this function read attributes `a_fields' of objects in `a_objects'?
		do
			Result := True
		end

	frozen reads_model (a_models: ANY; a_object: TUPLE): BOOLEAN
			-- Does this function read model queries `a_models' of objects in `a_objects'?
		do
			Result := True
		end

	frozen decreases (a_variants: TUPLE): BOOLEAN
			-- Does this routine / loop descrease `a_variants'?
		do
			Result := True
		end

	frozen inv: BOOLEAN
			-- Invariant of `Current'.
		do
			Result := True
		end

	frozen inv_without (a_clauses: TUPLE): BOOLEAN
			-- Invariant of `Current' without `a_clauses'.
		do
			Result := True
		end

	frozen inv_only (a_clauses: TUPLE): BOOLEAN
			-- Invariant of `Current' restricted to `a_clauses'.
		do
			Result := True
		end

	frozen is_fresh: BOOLEAN
			-- Was Current unallocated in the pre-state?
		do
			Result := True
		end

feature -- Verification: ownership operations

	frozen wrap
			-- Wrap object `a'.
		do
		end

	frozen wrap_all (a: MML_SET [ANY])
			-- Wrap all objects in `a' simultaneously.
		do
		end

	frozen unwrap
			-- Unwrap object `a'.
		do
		end

	frozen unwrap_all (a: MML_SET [ANY])
			-- Unwrap all objects in `a' simultaneously.
		do
		end

feature -- Verification: ownership queries

	frozen is_wrapped: BOOLEAN
			-- Is `Current' wrapped?
		do
			Result := True
		end

	frozen is_free: BOOLEAN
			-- Is `Current' free?
		do
			Result := True
		end

	frozen is_open: BOOLEAN
			-- Is `Current open?
		do
			Result := True
		end

	frozen is_field_writable (a_field: STRING): BOOLEAN
			-- Is field `a_field' of `Current' writable?
		do
			Result := True
		end

	frozen is_fully_writable: BOOLEAN
			-- Are all fields of `Current' writable?
		do
			Result := True
		end

	frozen is_field_readable (a_field: STRING): BOOLEAN
			-- Is field `a_field' of `Current' readable?
		do
			Result := True
		end

	frozen is_fully_readable: BOOLEAN
			-- Are all fields of `Current' readable?
		do
			Result := True
		end

	frozen transitive_owns: MML_SET [ANY]
			-- Reflexive transitive closure of `owns'.
		note
			status: ghost
		do
		end

	frozen ownership_domain: MML_SET [ANY]
			-- Ownership domain of `Current'
			-- (coincides with `transitive_owns' when `closed' and contains only `Current' otherwise).
		note
			status: ghost
		do
		end

	frozen universe: MML_SET [ANY]
			-- Set of all objects.
		note
			status: ghost
		do
		end

feature -- Verification: ownership fields

	frozen closed: BOOLEAN
			-- Is this object in a consistent state.
		note
			status: ghost
		do
		end

	frozen owner: ANY assign set_owner
			-- Owner of this object.
		note
			status: ghost
		do
		end

	frozen set_owner (a: ANY)
			-- Set owner of this object to `a'.
		do
		end

	owns: MML_SET [ANY] assign set_owns
			-- Owns set of this object.
		note
			status: ghost
			guard: True
		do
		end

	frozen set_owns (a: MML_SET [ANY])
			-- Set owns set of this object.
		do
		end

	subjects: MML_SET [ANY] assign set_subjects
			-- Subjects set of this object.
		note
			status: ghost
			guard: True
		do
		end

	frozen set_subjects (a: MML_SET [ANY])
			-- Set subjects set of this object.
		do
		end

	observers: MML_SET [ANY] assign set_observers
			-- Observers set of this object.
		note
			status: ghost
			guard: in_observers
		do
		end

	frozen set_observers (a: MML_SET [ANY])
			-- Set observers set of this object.
		do
		end

	in_observers (new_observers: like observers; o: ANY): BOOLEAN
			-- Is `o' in `new_observers'? (Guard for `observers')
		note
			status: functional, ghost
		do
			Result := new_observers [o]
		end

feature -- Verification: auxiliary

	is_model_equal (other: like Current): BOOLEAN
			-- Is the abstract state of `Current' equal to that of `other'?
		note
			status: ghost
			explicit: contracts
		require
			other /= Void
--			generating_type = other.generating_type
			reads (Current, other)
		do
			Result := True
		ensure
			reflexive: other = Current implies Result
			symmetric: Result = other.is_model_equal (Current)
		end

	lemma_transitive (x: like Current; ys: MML_SET [ANY])
			-- Property that follows from transitivity of `is_model_equal'.
			-- ToDo: reformulate once we have call_forall.
		note
			status: lemma
		require
			equal_x: is_model_equal (x)
			ys_exist: ys.non_void
		do
		ensure
			x_in_ys_iff_current_in_ys: across ys as y some is_model_equal (y.item) end =
				across ys as y some x.is_model_equal (y.item) end
		end

	frozen model_equals (x, y: ANY): BOOLEAN
		note
			status: ghost, functional
		require
			reads (x, y)
		do
			Result := (x = Void and y = Void) or ((x /= Void and x.generating_type = y.generating_type) and then x.is_model_equal (y))
		end

	frozen old_: like Current
			-- Old expression outside of postconditions.
		do
		end

	frozen use_definition (a_function_call: ANY)
			-- Bring definition of the opaque function in `a_function_call' into scope.
		do
		end

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
