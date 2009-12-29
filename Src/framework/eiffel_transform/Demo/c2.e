class
	C2
inherit
	C1
		rename
			somestring as str
		redefine
			str
		end
feature
	str:STRING
		do
			Result := "This is str in class C2%N"
		end
end
