note
	description: "Hahsable object."

deferred class
	F_HS_HASHABLE

inherit
	ANY
		redefine
			is_model_equal
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code.
		note
			explicit: contracts
			status: ghost
		require
			closed
			reads (ownership_domain, subjects)
		deferred
		ensure
			Result = hash_code_
		end

feature -- Specification

	hash_code_: INTEGER
			-- Hash code.
		note
			status: ghost
		attribute
		end

	is_model_equal (other: like Current): BOOLEAN
			-- Is the abstract state of `Current' equal to that of `other'?
		note
			status: ghost
			explicit: contracts
		do
			Result := hash_code_ = other.hash_code_
		ensure then
			agrees_with_hash: Result implies hash_code_ = other.hash_code_
			symmetric: Result = (other.is_model_equal (Current))
		end

	lemma_transitive (x: like Current; ys: MML_SET [like Current])
			-- Property that follows from transitivity of `is_model_equal'.
		note
			status: lemma
		require
			equal_x: is_model_equal (x)
			not_in_ys: across ys as y all not is_model_equal (y.item) end
		deferred
		ensure
			x_not_in_ys: across ys as y all not x.is_model_equal (y.item) end
		end

invariant
	hash_code_bounds: 1 <= hash_code_ and hash_code_ <= 10

end
