class
	A[F,G]

inherit 
	X[F,G]
	

feature

end
class
	D[H]
inherit
	A[INTEGER, H]
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
