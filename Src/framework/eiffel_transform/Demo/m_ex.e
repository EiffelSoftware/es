class
	M_EX

feature
	f1: INTEGER
	
	test(arg1,arg2:INTEGER)
		local
			l1,l2,l3: INTEGER
		do
			l1 := 1
			-- ex start
			if l1>arg1 then
				l2 := l1+arg1
				l3 := l2+42
			else
				l3 := 42
			end
			-- ex end
			f2 := l3+arg2
		end
		
--	test2(arg1: INTEGER): INTEGER
--		local
--			l1: INTEGER
--		do
--			l1 := 5
--			Result := 2*l1
--			if Result > arg1
--				Result := 0
--			else
--				Result := 2
--			end
--		end
--		
--	ex(l1, arg1: INTEGER): INTEGER
--		local
--			l2: INTEGER
--		do
--			if l1>arg1 then
--				l2 := l1+arg1
--				Result := l2+42
--			else
--				Result := 42
--			end
--		end
		
	f2: INTEGER
end
