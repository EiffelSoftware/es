class
	TEST3_REN_B
inherit
	TEST3_REN_A rename f as af end
feature
	f: attached STRING
		do
			Result := "B.f"
		end
end
