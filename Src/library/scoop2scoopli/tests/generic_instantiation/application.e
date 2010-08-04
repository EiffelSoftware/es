class APPLICATION

create
	make

feature
	make
		local
			l_b : B
			l_a : A [INTEGER]
			l_sb : separate B
		do
			io.put_string ("Hello world!%N")
		end

end

