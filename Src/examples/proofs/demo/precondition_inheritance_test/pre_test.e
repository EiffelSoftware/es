class
	PRE_TEST

feature

	test (b: !B)
		local
			a: A
		do
			a := b

			a.f (1)

			a.f (0)
		end

end
