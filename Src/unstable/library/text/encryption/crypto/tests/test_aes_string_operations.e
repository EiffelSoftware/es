class
	TEST_AES_STRING_OPERATIONS

inherit
	EQA_TEST_SET

feature -- Test routines

	test_ecb_mode
		local
			aes: AES
			key, plaintext, encrypted, decrypted: STRING_8
			bc: BYTE_ARRAY_CONVERTER
		do
			create aes.make
			key := "Sixteen byte key"

				-- Test case 1: Basic functionality
			plaintext := "Hello, World!"
			encrypted := aes.ecb_encoding_string (plaintext, key)
			create bc.make_from_string (encrypted)
			decrypted := aes.ecb_decoding_string (encrypted, key)

			assert ("ECB decryption matches original", plaintext.is_equal (decrypted))

				-- Test case 2: Empty string
			plaintext := ""
			encrypted := aes.ecb_encoding_string (plaintext, key)
			decrypted := aes.ecb_decoding_string (encrypted, key)
			assert ("ECB empty string", plaintext.is_equal (decrypted))

				-- Test case 3: Long string (multiple blocks)
			plaintext := "This is a longer string that will span multiple blocks in AES encryption."
			encrypted := aes.ecb_encoding_string (plaintext, key)
			decrypted := aes.ecb_decoding_string (encrypted, key)
			assert ("ECB long string", plaintext.is_equal (decrypted))

				-- Test case 4: Exact block size
			plaintext := "Exactly16Bytes!!"
			encrypted := aes.ecb_encoding_string (plaintext, key)
			decrypted := aes.ecb_decoding_string (encrypted, key)
			assert ("ECB exact block size", plaintext.is_equal (decrypted))
		end

	test_cbc_mode
		local
			aes: AES
			key, iv, plaintext, encrypted, decrypted: STRING_8
		do
			create aes.make
			key := "Sixteen byte key"
			iv := "16-byte init vec"

				-- Test case 1: Basic functionality
			plaintext := "Hello, World!"
			encrypted := aes.cbc_encoding_string (plaintext, key, iv)
			decrypted := aes.cbc_decoding_string (encrypted, key, iv)
			assert ("CBC decryption matches original", plaintext.is_equal (decrypted))

				-- Test case 2: Empty string
			plaintext := ""
			encrypted := aes.cbc_encoding_string (plaintext, key, iv)
			decrypted := aes.cbc_decoding_string (encrypted, key, iv)
			assert ("CBC empty string", plaintext.is_equal (decrypted))

				-- Test case 3: Long string (multiple blocks)
			plaintext := "This is a longer string that will span multiple blocks in AES encryption."
			encrypted := aes.cbc_encoding_string (plaintext, key, iv)
			decrypted := aes.cbc_decoding_string (encrypted, key, iv)
			assert ("CBC long string", plaintext.is_equal (decrypted))

				-- Test case 4: Exact block size
			plaintext := "Exactly16Bytes!!"
			encrypted := aes.cbc_encoding_string (plaintext, key, iv)
			decrypted := aes.cbc_decoding_string (encrypted, key, iv)
			assert ("CBC exact block size", plaintext.is_equal (decrypted))
		end

	test_ctr_mode
		local
			aes: AES
			key, nonce, plaintext, encrypted, decrypted: STRING_8
		do
			create aes.make
			key := "Sixteen byte key"
			nonce := "16-byte nonce123"

				-- Test case 1: Basic functionality
			plaintext := "Hello, World!"
			encrypted := aes.ctr_encoding_string (plaintext, key, nonce)
			decrypted := aes.ctr_decoding_string (encrypted, key, nonce)
			assert ("CTR decryption matches original", plaintext.is_equal (decrypted))

				-- Test case 2: Empty string
			plaintext := ""
			encrypted := aes.ctr_encoding_string (plaintext, key, nonce)
			decrypted := aes.ctr_decoding_string (encrypted, key, nonce)
			assert ("CTR empty string", plaintext.is_equal (decrypted))

				-- Test case 3: Long string (multiple blocks)
			plaintext := "This is a longer string that will span multiple blocks in AES encryption."
			encrypted := aes.ctr_encoding_string (plaintext, key, nonce)
			decrypted := aes.ctr_decoding_string (encrypted, key, nonce)
			assert ("CTR long string", plaintext.is_equal (decrypted))

				-- Test case 4: Exact block size
			plaintext := "Exactly16Bytes!!"
			encrypted := aes.ctr_encoding_string (plaintext, key, nonce)
			decrypted := aes.ctr_decoding_string (encrypted, key, nonce)
			assert ("CTR exact block size", plaintext.is_equal (decrypted))

				-- Test case 5: Very long string (tests counter wraparound)
			create plaintext.make_filled ('x', 100000) -- A string of 100,000 'x' characters
			encrypted := aes.ctr_encoding_string (plaintext, key, nonce)
			decrypted := aes.ctr_decoding_string (encrypted, key, nonce)
			assert ("CTR very long string", plaintext.is_equal (decrypted))
		end

end
