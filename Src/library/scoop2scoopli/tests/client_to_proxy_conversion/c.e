class
	A[F,G]

inherit 
	X[F,G]
	

feature

end
class
	C[Z]

inherit
	B[Z]
	redefine
		make
	end
	D[Z]
	redefine
		make
	end

	E[INTEGER]
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
