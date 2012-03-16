indexing
	description: "deferred class for encrypt/decrypt operations"
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "10.11.2007"
	revision: "$0.6$"

deferred class
	ENCRYPTOR

feature -- operation
	encrypt(input: STRING): STRING is
			-- encrypt 'input' string to result string
		deferred
		end

	decrypt(input: STRING): STRING is
			-- decrypt 'input' string back to original string
		deferred
		end

end
