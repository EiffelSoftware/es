deferred class
	TEST_REN_A

feature -- Access

	foo
		do
			output.extend ("A.foo")
			unk
		end

	bar
		do
			output.extend ("A.bar")
			unk
		end

	unk
		deferred
		end

	output: attached LIST[attached STRING]

end
