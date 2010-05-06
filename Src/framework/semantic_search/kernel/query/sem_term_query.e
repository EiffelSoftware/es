note
	description: "Term query"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TERM_QUERY

inherit
	SEM_QUERY

	SEM_SHARED_BOOST_VALUES

	HASHABLE

	DEBUG_OUTPUT

create
	make,
	make_with_boost

feature{NONE} -- Initialization

	make (a_term: like term)
			-- Initialize `term' with `a_term'.
		do
			make_with_boost (term, default_boost_value)
		ensure
			term_set: term = a_term
			boost_st: boost = default_boost_value
		end

	make_with_boost (a_term: like term; a_boost: DOUBLE)
			-- Initialize `term' with `a_term' and `boost' with `a_boost'.
		do
			term := a_term
			set_boost (a_boost)
		ensure
			term_set: term = a_term
			boost_st: boost = a_boost
		end

feature -- Access

	term: SEM_TERM
			-- Term inside current query

	boost: DOUBLE
			-- Boost value of current query
			-- Default: 1.0

	text, debug_output: STRING
			-- Text representation of current query
		do
			create Result.make (64)
			Result.append (term.text)
			Result.append_character (' ')
			Result.append (boost_string)
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		do
			if hash_code_cache = 0 then
				hash_code_cache := term.text.hash_code
				if hash_code_cache = 0 then
					hash_code_cache := 1
				end
			end
			Result := hash_code_cache
		end


feature -- Setting

	set_boost (a_boost: DOUBLE)
			-- Set `boost' with `a_boost'.
		do
			boost := a_boost
		ensure
			boost_set: boost = a_boost
		end

feature{NONE} -- Implementation

	hash_code_cache: INTEGER
			-- Cache for `hash_code'

end
