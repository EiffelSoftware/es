note
	description: "Simple hash set."
	manual_inv: true
	false_guards: true
	model: set

class
	F_HS_SET [G -> F_HS_HASHABLE]

create
	make

feature {NONE} -- Initialization

	make
		note
			status: creator
		local
			i: INTEGER
		do
			create buckets.make (1, 10)
			from
				i := 1
			invariant
				buckets.is_wrapped
				buckets.is_fresh
				buckets.sequence.count = 10
				1 <= i and i <= 11
				across 1 |..| (i - 1) as j all  buckets.sequence [j.item].is_empty end
				modify_model ("sequence", buckets)
			until
				i > 10
			loop
				buckets [i] := {MML_SEQUENCE [G]}.empty_sequence
				i := i + 1
			end
			set_owns ([buckets])
		end

feature -- Status report

	has (v: G): BOOLEAN
		require
			v_closed: v.closed
		local
			b: MML_SEQUENCE [G]
		do
			check inv; v.inv end
			b := buckets [v.hash_code]
			Result := b.domain [bucket_index (b, v)]
		ensure
			definition: Result = set_has (v)
		end

feature -- Modification

	extend (v: G)
		require
			v_wrapped: v.is_wrapped
			modify_model (["set", "owns"], Current)
			modify_field ("owner", v)
		local
			b: MML_SEQUENCE [G]
		do
			check v.inv end
			b := buckets [v.hash_code]
			if not b.domain [bucket_index (b, v)] then
				buckets [v.hash_code] := b & v
				set := set & v
				set_owns (owns & v)
				check set [v] end
			end
			check set_has (v) end
		ensure
			abstract_effect: set_has (v)
			precise_effect_has: old set_has (v) implies set = old set
			precise_effect_new: not old set_has (v) implies set = old set & v
		end

	join (other: F_HS_SET [G])
		note
			explicit: contracts, wrapping
		require
			is_wrapped
			other.is_wrapped
			other /= Current
			modify_model (["set", "owns"], Current)
			modify (other)
		local
			i, j: INTEGER
			ss: MML_SEQUENCE [MML_SEQUENCE [G]]
			s: MML_SEQUENCE [G]
		do
			other.unwrap
			from
				i := 1
				ss := other.buckets.sequence
				check inv_only ("set_non_void") end
			invariant
				is_wrapped
				other.is_open
				other.buckets.is_wrapped
				ss = ss.old_
				1 <= i and i <= ss.count + 1
				across 1 |..| (i - 1) as k all
					across 1 |..| (ss [k.item].count) as l all set_has ((ss [k.item]) [l.item]) end end
				across i |..| ss.count as k all
					across 1 |..| (ss [k.item].count) as l all (ss [k.item]) [l.item].is_wrapped end end
				set.old_ <= set
				across set as x all x.item /= Void and then (set.old_ [x.item] or other.set_has (x.item).old_) end
				modify_model (["set", "owns"], Current)
			until
				i > ss.count
			loop
				s := other.buckets [i]
				from
					j := 1
				invariant
					is_wrapped
					other.is_open
					other.buckets.is_wrapped
					1 <= j and j <= s.count + 1
					set.old_ <= set
					across 1 |..| (j - 1) as l all set_has (s [l.item]) end -- TODO!
					across 1 |..| (i - 1) as k all
						across 1 |..| (ss [k.item].count) as l all set_has ((ss [k.item]) [l.item]) end end -- TODO!
					across j |..| s.count as l all s [l.item].is_wrapped end
					across (i + 1) |..| ss.count as k all
						across 1 |..| (ss [k.item].count) as l all (ss [k.item]) [l.item].is_wrapped end end
					across set as x all x.item /= Void and then (set.old_ [x.item] or other.set_has (x.item).old_) end
				until
					j > s.count
				loop
					extend (s [j])
					j := j + 1
				end
				i := i + 1
			end
		ensure
			is_wrapped
			other.is_open
			has_old: old set <= set
			has_other: across old other.set as y all set_has (y.item) end
			no_extra: across set as x all set_has (x.item).old_ or other.set_has (x.item).old_ end
		end

	remove (v: G)
		require
			v_closed: v.is_wrapped or owns [v]
			modify_model (["set", "owns"], Current)
			modify_field ("owner", set)
		local
			b: MML_SEQUENCE [G]
			i: INTEGER
			x: G
		do
			check v.inv end
			b := buckets [v.hash_code]
			i := bucket_index (b, v)
			if b.domain [i] then
				x := b [i]
				buckets [v.hash_code] := b.removed_at (i)
				set := set / x
				x.lemma_transitive (v, set)
				set_owns (owns / x)
			end
		ensure
			abstract_effect: not set_has (v)
			precise_effect_not_found: not old set_has (v) implies set = old set
			precise_effect_found: old set_has (v) implies
				across old set as y some (set = old set / y.item) and v.is_model_equal (y.item) end
			v_wrapped: v.is_wrapped
		end

feature {F_HS_SET} -- Implementation

	buckets: V_ARRAY [MML_SEQUENCE [G]]
			-- Storage array.

	bucket_index (b: MML_SEQUENCE [G]; v: G): INTEGER
			-- Index in `b' of an element that is model-equal to `v'.
		require
			v_closed: v.closed
			items_clsoed: across 1 |..| b.count as j all b [j.item].closed end
		do
			from
				Result := 1
			invariant
				1 <= Result and Result <= b.count + 1
				across 1 |..| (Result - 1) as j all not v.is_model_equal (b [j.item]) end
			until
				Result > b.count or else v.is_model_equal (b [Result])
			loop
				Result := Result + 1
			variant
				b.count - Result
			end
		ensure
			b.domain [Result] implies v.is_model_equal (b [Result])
			not b.domain [Result] implies across 1 |..| b.count as j all not v.is_model_equal (b [j.item]) end
		end

feature -- Specification

	set: MML_SET [G]
			-- Set of elements.
		note
			status: ghost
		attribute
		end

	set_has (v: G): BOOLEAN
			-- Does `set' contain an element equal to `v'?
		note
			status: ghost, functional
		require
			v /= Void
			reads (Current, set, v)
		do
			Result := across set as x some v.is_model_equal (x.item) end
		end

invariant
	owns_definition: owns = create {MML_SET [ANY]}.singleton (buckets) + set
	buckets_exist: buckets /= Void
	bucket_lower: buckets.lower_ = 1
	buckets_count: buckets.sequence.count = 10
	no_observers: buckets.observers.is_empty
	set_non_void: set.non_void
	set_not_too_large: across set as x all
		buckets.sequence.domain [x.item.hash_code_] and then
		buckets.sequence [x.item.hash_code_].has (x.item) end
	set_not_too_small: across 1 |..| buckets.sequence.count as i all
		across 1 |..| buckets.sequence [i.item].count as j all
			set [(buckets.sequence [i.item])[j.item]] and then (buckets.sequence [i.item])[j.item].hash_code_ = i.item end end
	no_duplicates: across 1 |..| buckets.sequence.count as i all
		across 1 |..| (buckets.sequence [i.item].count - 1) as j all
			across (j.item + 1) |..| buckets.sequence [i.item].count as k all
				not (buckets.sequence [i.item])[k.item].is_model_equal ((buckets.sequence [i.item])[j.item]) end end end

note
	explicit: owns
end
