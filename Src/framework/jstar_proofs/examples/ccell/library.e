note
	description: "Summary description for {LIBRARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	LIBRARY

feature

	use_counter (c: COUNTER)
		require
			--SL-- Cn(c,{cnt:_v})
		deferred
		ensure
			--SL-- Cn(c,{cnt:builtin_plus(_v,10)})
		end

	use_cell (c: CEL; v: INTEGER)
		require
			--SL-- Cell(c,{val:_v})
		deferred
		ensure
			--SL-- Cell(c,{val:v})
		end
		
end
