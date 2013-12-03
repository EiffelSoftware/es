class A_LEMMA

feature

	lemma1 (x: INTEGER)
		note
			status: lemma
		require
			x > 0
		do
		ensure
			-x <= 0
		end

	lemma2 (x: INTEGER)
		note
			status: lemma
		require
			x > 0
		local
			a: ANY
		do
--			create a
		ensure
			-x <= 0
		end

	client
		do
			lemma1 (10)
			lemma2 (20)
		end

end
