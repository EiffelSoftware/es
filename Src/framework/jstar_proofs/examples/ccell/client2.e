note
	description: "Summary description for {CLIENT2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	js_logic: "client2.logic"
	js_abstraction: "client2.abs"

class
	CLIENT2

feature

	im_fine (l: LIBRARY): CCEL2
		require
			--SL-- True
		do
			create Result.init (5)
			l.use_counter (Result)
		ensure
			--SL-- Cn(Result,{cnt:10})
		end

	i_break (l: LIBRARY): CCEL2
		require
			--SL-- True
		do
			create Result.init (5)
			l.use_counter (Result)
			l.use_cell (Result, 7)
		ensure
			--SL-- Cell(Result,{cnt:10;val:7})
		end

end
