note
	description: "Summary description for {AFX_HASH_CALCULATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_HASH_CALCULATOR

inherit
    HASHABLE

feature -- status report

	hash_code: INTEGER
			-- <Precursor>
		local
		    l_linear: DS_LINEAR[INTEGER]
		    l_int: INTEGER
		do
		    if internal_hash_code = 0 then
		        l_int := 0
		        l_linear := key_to_hash

    				-- The magic number `8388593' below is the greatest prime lower than
    				-- 2^23 so that this magic number shifted to the left does not exceed 2^31.
    			from
    				l_linear.start
    			until
    				l_linear.after
    			loop
    				l_int := ((l_int \\ 8388593) |<< 8) + l_linear.item_for_iteration
    				l_linear.forth
    			end
		        internal_hash_code := l_int
		    end

		    Result := internal_hash_code.abs
		end

feature -- operation

	key_to_hash: DS_LINEAR[INTEGER]
			-- array of integers to calculate the hash code
		deferred
		end

feature{NONE} -- implementation

	internal_hash_code: INTEGER
			-- internal hash code

end
