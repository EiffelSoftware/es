class
	CAT_NPATH
	
feature {NONE} -- Test

	npath (a, b, c, d, e, f, g, h, j: INTEGER)
		do
			if a > b then
				print ("a > b")
			end
			if c /= d then
				print ("c /= d")
			elseif f > h then
				print ("f > h")
			else
				print ("c = d")
			end
		end
	
end
