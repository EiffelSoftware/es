class
	A[F,G]

inherit 
	X[F,G]
	

feature

end
class
	C[T]

inherit
	B[T]
	redefine
		make
	end

create
	make

feature
	make is
			-- blubb
		do

		end

end
