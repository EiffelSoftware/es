note
	description: "Summary description for {AFX_HASH_CALCULATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_HASH_CALCULATOR

inherit
    HASHABLE

feature -- Status report

	hash_code: INTEGER
			-- <Precursor>
		local
		    l_linear: DS_LINEAR[INTEGER]
		    l_int: INTEGER
		    l_max_prime: INTEGER
		do
		    if internal_hash_code = 0 then
		        l_int := 0
		        l_linear := key_to_hash

    			from
    				l_linear.start
    			until
    				l_linear.after
    			loop
    				l_int := ((l_int \\ internal_max_prime) |<< 8) + l_linear.item_for_iteration
    				l_linear.forth
    			end

    				-- Make sure the hash code we compute is not 0
    			if l_int = 0 then
    				internal_hash_code := internal_max_prime - 1
    			else
    				internal_hash_code := l_int
    			end
		    end

		    Result := internal_hash_code.abs
		end

feature{NONE} -- implementation

	key_to_hash: DS_LINEAR[INTEGER]
			-- Array of integers to calculate the hash code.
		deferred
		end

	internal_hash_code: INTEGER
			-- Internal hash code.

	internal_max_prime: INTEGER = 8388593
   			-- The magic number `8388593' is the greatest prime lower than
   			-- 2^23 so that this magic number shifted to the left does not exceed 2^31.

end
