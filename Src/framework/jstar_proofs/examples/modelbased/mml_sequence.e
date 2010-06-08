note
	description: "A sample MML class with separation logic contracts."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MML_SEQUENCE

feature

	cons (i: INTEGER): MML_SEQUENCE
		require
			--SL-- SEQ(Current,{s:_a})
		deferred
		ensure
			--SL-- SEQ(Current,{s:_a}) * SEQ(Result,{s:cons(i,_a)})
		end

	head: INTEGER
		require
			--SL-- SEQ(Current,{s:cons(_e,_a)})
		deferred
		ensure
			--SL-- SEQ(Current,{s:cons(_e,_a)}) * Result = _e
		end

	tail: MML_SEQUENCE
		require
			--SL-- SEQ(Current,{s:cons(_e,_a)})
		deferred
		ensure
			--SL-- SEQ(Current,{s:cons(_e,_a)}) * SEQ(Result,{s:_a})
		end

	is_nil: BOOLEAN
		require
			--SL-- SEQ(Current,{s:_a})
		deferred
		ensure
			--SL-- SEQ(Current,{s:_a}) * Result = builtin_eq(_a,empty())
		end

	eq (other: MML_SEQUENCE): BOOLEAN
		require
			--SL-- SEQ(Current,{s:_a}) * SEQ(other,{s:_b})
		deferred
		ensure
			--SL-- SEQ(Current,{s:_a}) * SEQ(other,{s:_b}) * Result = builtin_eq(_a,_b)
		end

end
