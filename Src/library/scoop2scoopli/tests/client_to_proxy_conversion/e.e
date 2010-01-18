class
	A[F,G]

inherit 
	X[F,G]
	

feature

end
class
	E[H]
inherit
	A[STRING,H]
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
