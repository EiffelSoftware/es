class
	M_EX

feature
	f1: INTEGER
	
	test(arg1,arg2:INTEGER)
			-- 2 arguments, 1 result
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
		
	test2(arg1: INTEGER): INTEGER
			-- 1 result, 1 argument. result as argument
		local
			l1: INTEGER
		do
			l1 := 5
			Result := 2*l1
			-- ex start
			if Result > arg1 then
				Result := 0
			else
				Result := 2
			end
			-- ex end
		end
		
	test3(arg1: INTEGER): INTEGER
			-- 2 arguments, no result
		local
			l1,l2,l3: INTEGER
		do
			l1 := 5
			l2 := 5
			-- ex start
			l3 := l1+l2
			f2 := 3*l3
			-- ex end
		end
		
	test4(arg1: INTEGER): INTEGER
			-- loop
		local
			l1,l2,l3,l4: INTEGER
		do
			from
				l1 := 5
			until
				l1 > arg1
			loop
				-- ex start
				l2 := l1+arg1
				l3 := 2*arg1
				if l2>l3 then
					f2 := f2 + 1
				else
					f2 := f2 - 1
				end
				l4 := f2+f2
				-- ex end
				l1 := l1 + 1
			end
			
			-- result
			f2 := l4
			-- fake result
			l3 := l1
		end
		
	test5(arg1: INTEGER): INTEGER
			-- writable argument
		local
			l1,l2: INTEGER
		do
			l1 := 5
			-- ex start
			if arg1>0 then
				l1 := arg1
			end
			
			l2 := l1+2
			l2 := l2*l2
			-- ex end
		end
		
	test6(arg1: INTEGER): INTEGER
			-- hidden result
		local
			l1: like arg1
		do
			l1 := 5
			-- ex start
			if arg1>0 then
				l1 := arg1
			end
			-- ex end
			f2 := l1
		end
		
	test7(arg1: STRING): INTEGER
			-- hidden result
		local
			l1: INTEGER
		do
			if attached arg1.count as cnt then				
				l1 := 5
				-- ex start
				if l1>5 then
					l1 := cnt
				end
				-- ex end
			end
			
			f2 := l1
		end
		
	f2: INTEGER

end
