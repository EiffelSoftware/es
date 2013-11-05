class F_DLL_CLIENT

feature
	test
		local
			n1, n2: F_DLL_NODE
		do
			create n1.make
			check n1.right = n1 end
			n1.insert_right (n1)
			check n1.right = n1 end
			create n2.make
			n1.insert_right (n2)
			check n1.right = n2 and n2.right = n1 end
			n2.remove_right
			check n1.right = n1 and n2.right = n2 end
		end

end

