note
	description: "Persistent set of words."

deferred class
	SC_WORD_SET

feature {NONE} -- Initialization

	make
			-- Create empty set.
		do
			failure_message := ""
		ensure
			successful: is_successful
		end

feature -- Access

	words: SET [READABLE_STRING_32]
			-- Whole set.
		deferred
		ensure
			object_comparison: is_successful implies Result.object_comparison
		end

	has (word: READABLE_STRING_32): BOOLEAN
			-- Is `word' part of set?
		do
			Result := words.has (word)
		ensure
			definition: is_successful implies Result = words.has (word)
		end

	is_successful: BOOLEAN
			-- Is there no failure?
		do
			Result := failure_message.is_empty
		ensure
			definition: Result = failure_message.is_empty
		end

	failure_message: READABLE_STRING_32
			-- Message in case of failure.

feature -- Element change

	load
			-- Read set from persistent storage. Volatile words are overwritten.
		deferred
		end

	store
			-- Write set to persistent storage. Persistent words are overwritten.
		deferred
		end

	extend (word: READABLE_STRING_32)
			-- Add `word' to set. Changes are only made persistent with `store'.
		deferred
		ensure
			extended: is_successful implies words.has (word)
		end

	prune (word: READABLE_STRING_32)
			-- Remove `word' from set. Changes are only made persistent with `store'.
		deferred
		ensure
			pruned: is_successful implies not words.has (word)
		end

end
