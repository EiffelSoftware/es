class
	B

inherit

	A
		redefine f end

feature

	f (i: INTEGER)
		require else
			i = 0
		do

		end

end
