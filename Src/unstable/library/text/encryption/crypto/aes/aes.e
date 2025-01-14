note
	description: "[
			This is a small implementation of the AES 
			[ECB](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Electronic_Codebook_.28ECB.29), 
			[CTR](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Counter_.28CTR.29) and 
			[CBC](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher_Block_Chaining_.28CBC.29) 
			encryption algorithms written in pure Eiffel based on tiny-AES-c C implementation.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=tiny-AES-c", "src=https://github.com/kokke/tiny-AES-c", "protocol=uri"
	EIS: "name=ECB", "src=https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Electronic_Codebook_.28ECB.29%T", "protocol=uri"
	EIS: "name=CTR", "src=https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Counter_.28CTR.29", "protocol=uri"
	EIS: "name=CBC", "src=https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher_Block_Chaining_.28CBC.29", "protocol=uri"
	EIS: "name=AES-Documentation", "src=https://en.wikipedia.org/wiki/Advanced_Encryption_Standard", "protocol=uri"
	EIS: "name=PKCS7", "src=https://en.wikipedia.org/wiki/Padding_(cryptography)#PKCS7", "protocol=uri"
	EIS: "name=PKCS#7 ", "src=https://datatracker.ietf.org/doc/html/rfc5652#section-6.3", "protocol=uri"

class
	AES

create
	make, make_with_params

feature {NONE} -- Initialization

	make
			-- Initialize the AES context with default parameters (AES-128)
		do
			make_with_params (create {AES_128_PARAMETERS})
		end

	make_with_params (a_parameters: AES_PARAMETERS)
			-- Initialize the AES context with specific parameters
		do
			parameters := a_parameters
			create round_key.make_filled (0, 1, parameters.key_exp_size)
			create iv.make_filled (0, 1, aes_blocklen)
		ensure
			parameters_set: parameters = a_parameters
		end

feature -- Context Setup

	init_ctx (a_key: ARRAY [NATURAL_8])
			-- Initialize the AES context with just a key
		require
			valid_key_size: a_key.count = parameters.key_length
		do
			expand_key (a_key)
		end

	init_ctx_iv (a_key: ARRAY [NATURAL_8]; a_iv: ARRAY [NATURAL_8])
			-- Initialize the AES context with a key and IV
		require
			valid_key_size: a_key.count = parameters.key_length
			valid_iv_size: a_iv.count = aes_blocklen
		do
			expand_key (a_key)
			set_iv (a_iv)
		end

	set_iv (a_iv: ARRAY [NATURAL_8])
			-- Set the IV for the AES context
		require
			valid_iv_size: a_iv.count = aes_blocklen
		do
			iv.copy (a_iv)
		end

feature -- String ECB encoding

	ecb_encoding_string (s: READABLE_STRING_8; a_key: STRING_8): STRING_8
			-- Encode the input string `s` using ECB mode with the given key `a_key`
		require
			key_length_valid: a_key.count = parameters.key_length
		local
			converter: BYTE_ARRAY_CONVERTER
			buffer: ARRAY [NATURAL_8]
			key_array: ARRAY [NATURAL_8]
		do
				-- Convert key to NATURAL_8 array
			create converter.make_from_string (a_key)
			key_array := converter.to_natural_8_array

				-- Initialize AES context with the key
			init_ctx (key_array)

			create converter.make_from_string (s)
			buffer := converter.to_natural_8_array

				-- Add PKCS7 padding
			buffer := pkcs7_pad (buffer, aes_blocklen)

			ecb_encrypt (buffer)

			create Result.make_from_string (make_from_natural_8_array (buffer))
		end

	ecb_decoding_string (s: READABLE_STRING_8; a_key: STRING_8): STRING_8
			-- Decode the input string `s` using ECB mode with the given key `a_key`
		require
			key_length_valid: a_key.count = parameters.key_length
		local
			converter: BYTE_ARRAY_CONVERTER
			buffer: ARRAY [NATURAL_8]
			key_array: ARRAY [NATURAL_8]
		do
				-- Convert key to NATURAL_8 array
			create converter.make_from_string (a_key)
			key_array := converter.to_natural_8_array

				-- Initialize AES context with the key
			init_ctx (key_array)

			create converter.make_from_string (s)
			buffer := converter.to_natural_8_array

			ecb_decrypt (buffer)

				-- Remove PKCS7 padding
			buffer := pkcs7_unpad (buffer)

			create Result.make_from_string (make_from_natural_8_array (buffer))
		end

feature -- String CBC encoding		

	cbc_encoding_string (s: READABLE_STRING_8; a_key: STRING_8; a_iv: STRING_8): STRING_8
			-- Encode the input string `s` using CBC mode with the given key `a_key` and IV `a_iv`
		require
			key_length_valid: a_key.count = parameters.key_length
			iv_length_valid: a_iv.count = aes_blocklen
		local
			converter: BYTE_ARRAY_CONVERTER
			buffer: ARRAY [NATURAL_8]
			key_array, iv_array: ARRAY [NATURAL_8]
		do
				-- Convert key and IV to NATURAL_8 arrays
			create converter.make_from_string (a_key)
			key_array := converter.to_natural_8_array
			create converter.make_from_string (a_iv)
			iv_array := converter.to_natural_8_array

				-- Initialize AES context with the key and IV
			init_ctx_iv (key_array, iv_array)

			create converter.make_from_string (s)
			buffer := converter.to_natural_8_array

				-- Add PKCS7 padding
			buffer := pkcs7_pad (buffer, aes_blocklen)
			cbc_encrypt_buffer (buffer)

			create Result.make_from_string (make_from_natural_8_array (buffer))
		end

	cbc_decoding_string (s: READABLE_STRING_8; a_key: STRING_8; a_iv: STRING_8): STRING_8
			-- Decode the input string `s` using CBC mode with the given key `a_key`
		require
			key_length_valid: a_key.count = parameters.key_length
			iv_length_valid: a_iv.count = aes_blocklen
		local
			converter: BYTE_ARRAY_CONVERTER
			buffer: ARRAY [NATURAL_8]
			key_array, iv_array: ARRAY [NATURAL_8]
		do
				-- Convert key and IV to NATURAL_8 arrays
			create converter.make_from_string (a_key)
			key_array := converter.to_natural_8_array
			create converter.make_from_string (a_iv)
			iv_array := converter.to_natural_8_array

				-- Initialize AES context with the key and IV
			init_ctx_iv (key_array, iv_array)

			create converter.make_from_string (s)
			buffer := converter.to_natural_8_array

			cbc_decrypt_buffer (buffer)

				-- Remove PKCS7 padding
			buffer := pkcs7_unpad (buffer)
			create Result.make_from_string (make_from_natural_8_array (buffer))
		end

feature -- String CTR encoding		

	ctr_encoding_string (s: READABLE_STRING_8; a_key: STRING_8; a_nonce: STRING_8): STRING_8
			-- Encode the input string `s` using CTR mode with the given key `a_key` and nonce `a_nonce`
		require
			key_length_valid: a_key.count = parameters.key_length
			nonce_length_valid: a_nonce.count = aes_blocklen
		local
			converter: BYTE_ARRAY_CONVERTER
			buffer: ARRAY [NATURAL_8]
			key_array, nonce_array: ARRAY [NATURAL_8]
		do
				-- Convert key and nonce to NATURAL_8 arrays
			create converter.make_from_string (a_key)
			key_array := converter.to_natural_8_array
			create converter.make_from_string (a_nonce)
			nonce_array := converter.to_natural_8_array

				-- Initialize AES context with the key and nonce
			init_ctx_iv (key_array, nonce_array)

			create converter.make_from_string (s)
			buffer := converter.to_natural_8_array

				-- No padding is needed for CTR mode
			ctr_xcrypt_buffer (buffer)

			create Result.make_from_string (make_from_natural_8_array (buffer))
		end

	ctr_decoding_string (s: READABLE_STRING_8; a_key: STRING_8; a_nonce: STRING_8): STRING_8
			-- Decode the input string `s` using CTR mode with the given key `a_key` and nonce `a_nonce`
		require
			key_length_valid: a_key.count = parameters.key_length
			nonce_length_valid: a_nonce.count = aes_blocklen
		local
			converter: BYTE_ARRAY_CONVERTER
			buffer: ARRAY [NATURAL_8]
			key_array, nonce_array: ARRAY [NATURAL_8]
		do
				-- Convert key and nonce to NATURAL_8 arrays
			create converter.make_from_string (a_key)
			key_array := converter.to_natural_8_array
			create converter.make_from_string (a_nonce)
			nonce_array := converter.to_natural_8_array

				-- Initialize AES context with the key and nonce
			init_ctx_iv (key_array, nonce_array)

			create converter.make_from_string (s)
			buffer := converter.to_natural_8_array

				-- CTR mode is symmetric, so we use the same operation for decryption
			ctr_xcrypt_buffer (buffer)

			create Result.make_from_string (make_from_natural_8_array (buffer))
		end

feature -- Encryption Operations

	ecb_encrypt (a_buffer: ARRAY [NATURAL_8])
			-- Encrypt the buffer using ECB mode
		require
			a_buffer_correct_size: a_buffer.count \\ aes_blocklen = 0
		local
			i: INTEGER
			current_block: ARRAY [NATURAL_8]
		do
			from
				i := 1
			until
				i > a_buffer.count
			loop
					-- Extract the current block
				current_block := a_buffer.subarray (i, i + aes_blocklen - 1)
				current_block.rebase (1)

					-- Encrypt the block
				cipher (current_block)

					-- Copy the encrypted block back to the buffer
				a_buffer.subcopy (current_block, 1, aes_blocklen, i)

				i := i + aes_blocklen
			end
		ensure
			buffer_length_unchanged: a_buffer.count = old a_buffer.count
		end

	cbc_encrypt_buffer (a_buffer: ARRAY [NATURAL_8])
			-- Encrypt the buffer using CBC mode
		require
			buffer_size_multiple_of_block_length: a_buffer.count \\ aes_blocklen = 0
		local
			i: INTEGER
			l_iv: ARRAY [NATURAL_8]
			current_block: ARRAY [NATURAL_8]
		do
			create l_iv.make_filled (0, 1, aes_blocklen)
			l_iv.copy (iv)

			from
				i := 1
			until
				i > a_buffer.count
			loop
					-- Extract the current block
				current_block := a_buffer.subarray (i, i + aes_blocklen - 1)
				current_block.rebase (1)

					-- XOR with IV
				xor_with_iv (current_block, l_iv)

					-- Encrypt the block
				cipher (current_block)

					-- Copy the encrypted block back to the buffer
				a_buffer.subcopy (current_block, 1, aes_blocklen, i)

					-- Set the next IV
				l_iv.copy (current_block)

				i := i + aes_blocklen
			end

				-- Store IV in context for next call
			iv.copy (l_iv)
		ensure
			buffer_length_unchanged: a_buffer.count = old a_buffer.count
		end

	ctr_xcrypt_buffer (buf: ARRAY [NATURAL_8])
			-- Symmetrical operation: same function for encrypting as for decrypting.
			-- Note any IV/nonce should never be reused with the same key.
		local
			buffer: ARRAY [NATURAL_8]
			i, bi: INTEGER
		do
			create buffer.make_filled (0, 1, aes_blocklen)

			from
				i := 1
				bi := aes_blocklen + 1
			until
				i > buf.count
			loop
				if bi > aes_blocklen then
						-- We need to regen xor complement in buffer
					buffer.copy (iv)
					cipher (buffer)

						-- Increment Iv and handle overflow
					from
						bi := aes_blocklen
					until
						bi < 1
					loop
						if iv [bi] = 255 then
							iv [bi] := 0
							bi := bi - 1
						else
							iv [bi] := iv [bi] + 1
							bi := 0 -- Exit the loop
						end
					end
					bi := 1
				end

				buf [i] := buf [i].bit_xor (buffer [bi])

				i := i + 1
				bi := bi + 1
			end
		ensure
			buf_size_unchanged: buf.count = old buf.count
		end

feature -- Decryption Operations

	ecb_decrypt (a_buffer: ARRAY [NATURAL_8])
			-- Decrypt the buffer using ECB mode
		require
			a_buffer_correct_size: a_buffer.count \\ aes_blocklen = 0
		local
			i: INTEGER
			current_block: ARRAY [NATURAL_8]
		do
			from
				i := 1
			until
				i > a_buffer.count
			loop
					-- Extract the current block
				current_block := a_buffer.subarray (i, i + aes_blocklen - 1)
				current_block.rebase (1)

					-- Decrypt the block
				inv_cipher (current_block)

					-- Copy the decrypted block back to the buffer
				a_buffer.subcopy (current_block, 1, aes_blocklen, i)

				i := i + aes_blocklen
			end
		ensure
			buffer_length_unchanged: a_buffer.count = old a_buffer.count
		end

	cbc_decrypt_buffer (buf: ARRAY [NATURAL_8])
			-- Decrypt the buffer using CBC mode
		require
			buf_length_valid: buf.count \\ aes_blocklen = 0
		local
			i: INTEGER
			store_next_iv: ARRAY [NATURAL_8]
			current_block: ARRAY [NATURAL_8]
		do
			create store_next_iv.make_filled (0, 1, aes_blocklen)

			from
				i := 1
			until
				i > buf.count
			loop
					-- Store the current block as the next IV
				store_next_iv.copy (buf.subarray (i, i + aes_blocklen - 1))

					-- Extract the current block
				current_block := buf.subarray (i, i + aes_blocklen - 1)
				current_block.rebase (1)

					-- Decrypt the block
				inv_cipher (current_block)

					-- XOR with the current IV
				xor_with_iv (current_block, iv)

					-- Copy the decrypted block back to the buffer
				buf.subcopy (current_block, 1, aes_blocklen, i)

					-- Set the next IV
				iv.copy (store_next_iv)
				iv.rebase (1)

				i := i + aes_blocklen
			end
		ensure
			buf_length_unchanged: buf.count = old buf.count
		end

feature -- Access

	parameters: AES_PARAMETERS
			-- AES parameters (key length and expanded key size)

	round_key: ARRAY [NATURAL_8]
			-- Expanded key for AES rounds

	iv: ARRAY [NATURAL_8]
			-- Initialization vector for CBC and CTR modes

feature -- Constants

	aes_blocklen: INTEGER = 16
			-- Block length in bytes - AES is 128b block only

feature {NONE} -- Implementation

	expand_key (a_key: ARRAY [NATURAL_8])
			-- Expand the input key for AES
		local
			i, j, k: INTEGER
			tempa: ARRAY [NATURAL_8]
			u8tmp: NATURAL_8
		do
			create tempa.make_filled (0, 1, 4)

			check round_key.count = parameters.key_exp_size end

				-- The first round key is the key itself
			from i := 0 until i >= parameters.nk loop
				round_key [i * 4 + 1] := a_key [i * 4 + 1]
				round_key [i * 4 + 2] := a_key [i * 4 + 2]
				round_key [i * 4 + 3] := a_key [i * 4 + 3]
				round_key [i * 4 + 4] := a_key [i * 4 + 4]
				i := i + 1
			end

				-- All other round keys are found from the previous round keys
			from i := parameters.nk until i >= parameters.nb * (parameters.number_of_rounds + 1) loop
				k := (i - 1) * 4
				tempa [1] := round_key [k + 1]
				tempa [2] := round_key [k + 2]
				tempa [3] := round_key [k + 3]
				tempa [4] := round_key [k + 4]

				if i \\ parameters.nk = 0 then
						-- RotWord function
					u8tmp := tempa [1]
					tempa [1] := tempa [2]
					tempa [2] := tempa [3]
					tempa [3] := tempa [4]
					tempa [4] := u8tmp

						-- SubWord function
					tempa [1] := get_sbox_value (tempa [1])
					tempa [2] := get_sbox_value (tempa [2])
					tempa [3] := get_sbox_value (tempa [3])
					tempa [4] := get_sbox_value (tempa [4])

					tempa [1] := tempa [1].bit_xor (rcon [(i // parameters.nk) + 1])
				end

				if attached {AES_256_PARAMETERS} parameters as params_256 then
					if i \\ params_256.nk = 4 then
							-- SubWord function
						tempa [1] := get_sbox_value (tempa [1])
						tempa [2] := get_sbox_value (tempa [2])
						tempa [3] := get_sbox_value (tempa [3])
						tempa [4] := get_sbox_value (tempa [4])
					end
				end

				j := i * 4
				k := (i - parameters.nk) * 4
				round_key [j + 1] := round_key [k + 1].bit_xor (tempa [1])
				round_key [j + 2] := round_key [k + 2].bit_xor (tempa [2])
				round_key [j + 3] := round_key [k + 3].bit_xor (tempa [3])
				round_key [j + 4] := round_key [k + 4].bit_xor (tempa [4])

				i := i + 1
			end
		end

	get_sbox_value (num: NATURAL_8): NATURAL_8
			-- Get the S-box value for a given number
		local
			l_num: INTEGER_16
		do
			l_num := num.to_integer_16 + 1
			Result := sbox [l_num]
		end

	inv_cipher (state: ARRAY [NATURAL_8])
			-- Inverse cipher operation
		require
			state_correct_size: state.count = aes_blocklen
		local
			round: INTEGER
			state_2d: ARRAY2 [NATURAL_8]
		do
				-- Convert 1D array to 2D array for easier manipulation
			create state_2d.make_filled (0, 4, 4)
			array_to_state (state, state_2d)

				-- Add the First round key to the state before starting the rounds.
			add_round_key (parameters.number_of_rounds, state_2d, round_key)

				-- There will be Nr rounds.
				-- The first Nr-1 rounds are identical.
				-- These Nr rounds are executed in the loop below.
				-- Last one without InvMixColumn()
			from
				round := parameters.number_of_rounds - 1
			until
				round < 0
			loop
				inv_shift_rows (state_2d)
				inv_sub_bytes (state_2d)
				add_round_key (round, state_2d, round_key)
				if round /= 0 then
					inv_mix_columns (state_2d)
				end
				round := round - 1
			end

				-- Convert 2D array back to 1D array
			state_to_array (state_2d, state)
		end

	xor_with_iv (buf: ARRAY [NATURAL_8]; a_iv: ARRAY [NATURAL_8])
			-- XOR the buffer with the IV
		require
			buf_correct_size: buf.count = aes_blocklen
			iv_correct_size: a_iv.count = aes_blocklen
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > aes_blocklen -- The block in AES is always 128bit no matter the key size
			loop
				buf [i] := buf [i].bit_xor (a_iv [i])
				i := i + 1
			end
		end

	inv_sub_bytes (state: ARRAY2 [NATURAL_8])
			-- Inverse sub bytes operation
		require
			state_correct_size: state.height = 4 and state.width = 4
		local
			i, j: INTEGER
		do
			from
				i := 1
			until
				i > 4
			loop
				from
					j := 1
				until
					j > 4
				loop
					state [j, i] := get_sbox_invert (state [j, i])
					j := j + 1
				end
				i := i + 1
			end
		ensure
			state_size_unchanged: state.height = old state.height and state.width = old state.width
		end

	get_sbox_invert (num: NATURAL_8): NATURAL_8
			-- Get the inverse S-box value for a given number
		local
			l_num: INTEGER_16
		do
			l_num := num.to_integer_16 + 1
			Result := rsbox.at (l_num)
		end

	inv_mix_columns (state: ARRAY2 [NATURAL_8])
			-- Inverse mix columns operation
		require
			state_not_void: state /= Void
			state_correct_size: state.height = 4 and state.width = 4
		local
			i: INTEGER
			a, b, c, d: NATURAL_8
		do
			from
				i := 1
			until
				i > 4
			loop
				a := state [i, 1]
				b := state [i, 2]
				c := state [i, 3]
				d := state [i, 4]

				state [i, 1] := multiply (a, 0x0e).bit_xor (multiply (b, 0x0b)).bit_xor (multiply (c, 0x0d)).bit_xor (multiply (d, 0x09))
				state [i, 2] := multiply (a, 0x09).bit_xor (multiply (b, 0x0e)).bit_xor (multiply (c, 0x0b)).bit_xor (multiply (d, 0x0d))
				state [i, 3] := multiply (a, 0x0d).bit_xor (multiply (b, 0x09)).bit_xor (multiply (c, 0x0e)).bit_xor (multiply (d, 0x0b))
				state [i, 4] := multiply (a, 0x0b).bit_xor (multiply (b, 0x0d)).bit_xor (multiply (c, 0x09)).bit_xor (multiply (d, 0x0e))

				i := i + 1
			end
		ensure
			state_size_unchanged: state.height = old state.height and state.width = old state.width
		end

	multiply (x, y: NATURAL_8): NATURAL_8
			-- Multiply two bytes in GF(2^8)
		local
			p, l_x, l_y: NATURAL_8
			i: INTEGER
			high_bit_set: BOOLEAN
		do
			l_x := x
			l_y := y
			from
				p := 0
				i := 0
			until
				i >= 8
			loop
				if l_y.bit_and (1) = 1 then
					p := p.bit_xor (l_x)
				end
				high_bit_set := l_x.bit_and (0x80) /= 0
				l_x := l_x |<< 1
				if high_bit_set then
					l_x := l_x.bit_xor (0x1B) -- x^8 + x^4 + x^3 + x + 1
				end
				l_y := l_y |>> 1
				i := i + 1
			end
			Result := p
		end

feature {NONE} -- Constants

	sbox: ARRAY [NATURAL_8]
			-- S-box for SubBytes operation
		once
			Result := {ARRAY [NATURAL_8]} <<
						-- 0     1    2      3     4    5     6     7      8    9     A      B    C     D     E     F
					0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
					0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
					0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
					0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
					0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
					0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
					0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
					0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
					0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
					0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
					0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
					0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
					0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
					0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
					0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
					0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
				>>
		ensure
			correct_size: Result.count = 256
		end

	rsbox: ARRAY [NATURAL_8]
			-- Inverse S-box for decryption
		once
			Result := {ARRAY [NATURAL_8]} <<
						-- 0     1    2      3     4    5     6     7      8    9     A      B    C     D     E     F
					0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
					0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
					0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e,
					0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25,
					0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92,
					0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84,
					0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06,
					0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b,
					0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73,
					0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e,
					0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b,
					0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4,
					0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f,
					0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef,
					0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61,
					0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d
				>>
		ensure
			correct_size: Result.count = 256
		end

	rcon: ARRAY [NATURAL_8]
			-- The round constant word array, Rcon[i], contains the values given by
			-- x to the power (i-1) being powers of x (x is denoted as {02}) in the field GF(2^8)
		once
			Result := {ARRAY [NATURAL_8]} <<
					0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36
				>>
		ensure
			correct_size: Result.count = 11
		end

feature {NONE} -- Helper functions

	array_to_state (arr: ARRAY [NATURAL_8]; state: ARRAY2 [NATURAL_8])
			-- Convert 1D array to 2D state array in row-major order
		local
			i, j, k: INTEGER
		do
			from i := 0 until i >= 4 loop
				from j := 0 until j >= 4 loop
					k := j + 4 * i + 1 -- Calculate index for row-major order
					state [i + 1, j + 1] := arr [k]
					j := j + 1
				end
				i := i + 1
			end
		end

	state_to_array (state: ARRAY2 [NATURAL_8]; arr: ARRAY [NATURAL_8])
			-- Convert 2D state array back to 1D array in row-major order
		local
			i, j, k: INTEGER
		do
			from i := 0 until i >= 4 loop
				from j := 0 until j >= 4 loop
					k := j + 4 * i + 1 -- Calculate index for row-major order
					arr [k] := state [i + 1, j + 1]
					j := j + 1
				end
				i := i + 1
			end
		end

	add_round_key (round: INTEGER; state: ARRAY2 [NATURAL_8]; a_round_key: ARRAY [NATURAL_8])
			-- Add round key to state
		local
			i, j: INTEGER
		do
			from i := 1 until i > 4 loop
				from j := 1 until j > 4 loop
					state [i,j] := state [i, j].bit_xor (a_round_key [(round * parameters.nb * 4) + (i - 1) * parameters.nb + j])
					j := j + 1
				end
				i := i + 1
			end
		end

	inv_shift_rows (state: ARRAY2 [NATURAL_8])
			-- Inverse shift rows operation
		require
			state_not_void: state /= Void
			state_correct_size: state.height = 4 and state.width = 4
		local
			temp: NATURAL_8
		do
				-- Rotate first row 1 column to right
			temp := state [4, 2]
			state [4, 2] := state [3, 2]
			state [3, 2] := state [2, 2]
			state [2, 2] := state [1, 2]
			state [1, 2] := temp

				-- Rotate second row 2 columns to right
			temp := state [1, 3]
			state [1, 3] := state [3, 3]
			state [3, 3] := temp

			temp := state [2, 3]
			state [2, 3] := state [4, 3]
			state [4, 3] := temp

				-- Rotate third row 3 columns to right
			temp := state [1, 4]
			state [1, 4] := state [2, 4]
			state [2, 4] := state [3, 4]
			state [3, 4] := state [4, 4]
			state [4, 4] := temp
		ensure
			state_size_unchanged: state.height = old state.height and state.width = old state.width
		end

	sub_bytes (state: ARRAY2 [NATURAL_8])
			-- SubBytes operation
		require
			state_correct_size: state.height = 4 and state.width = 4
		local
			i, j: INTEGER
		do
			from i := 1 until i > 4 loop
				from j := 1 until j > 4 loop
					state [i, j] := get_sbox_value (state [i, j])
					j := j + 1
				end
				i := i + 1
			end
		end

	shift_rows (state: ARRAY2 [NATURAL_8])
			-- ShiftRows operation
		require
			state_correct_size: state.height = 4 and state.width = 4
		local
			temp: NATURAL_8
		do
				-- Rotate first row 1 column to left
			temp := state [1, 2]
			state [1, 2] := state [2, 2]
			state [2, 2] := state [3, 2]
			state [3, 2] := state [4, 2]
			state [4, 2] := temp

				-- Rotate second row 2 columns to left
			temp := state [1, 3]
			state [1, 3] := state [3, 3]
			state [3, 3] := temp

			temp := state [2, 3]
			state [2, 3] := state [4, 3]
			state [4, 3] := temp

				-- Rotate third row 3 columns to left
			temp := state [1, 4]
			state [1, 4] := state [4, 4]
			state [4, 4] := state [3, 4]
			state [3, 4] := state [2, 4]
			state [2, 4] := temp
		end

	mix_columns (state: ARRAY2 [NATURAL_8])
			-- MixColumns operation
		require
			state_correct_size: state.height = 4 and state.width = 4
		local
			i: INTEGER
			a, b, c, d: NATURAL_8
		do
			from i := 1 until i > 4 loop
				a := state [i, 1]
				b := state [i, 2]
				c := state [i, 3]
				d := state [i, 4]

				state [i, 1] := multiply (a, 0x02).bit_xor (multiply (b, 0x03)).bit_xor (c).bit_xor (d)
				state [i, 2] := a.bit_xor (multiply (b, 0x02)).bit_xor (multiply (c, 0x03)).bit_xor (d)
				state [i, 3] := a.bit_xor (b).bit_xor (multiply (c, 0x02)).bit_xor (multiply (d, 0x03))
				state [i, 4] := multiply (a, 0x03).bit_xor (b).bit_xor (c).bit_xor (multiply (d, 0x02))

				i := i + 1
			end
		end

	cipher (state: ARRAY [NATURAL_8])
			-- Cipher operation (you need to implement this based on the AES algorithm)
		require
			state_correct_size: state.count = aes_blocklen
		local
			state_2d: ARRAY2 [NATURAL_8]
			round: INTEGER
		do
			create state_2d.make_filled (0, 4, 4)
			array_to_state (state, state_2d)

				-- Add the First round key to the state before starting the rounds
			add_round_key (0, state_2d, round_key)

				-- There will be Nr rounds
				-- The first Nr-1 rounds are identical
				-- These Nr rounds are executed in the loop below
			from
				round := 1
			until
				round > parameters.number_of_rounds
			loop
				sub_bytes (state_2d)
				shift_rows (state_2d)
				if round < parameters.number_of_rounds then
					mix_columns (state_2d)
				end
				add_round_key (round, state_2d, round_key)
				round := round + 1
			end

			state_to_array (state_2d, state)
		ensure
			state_size_unchanged: state.count = old state.count
		end

feature {NONE} -- Implementation

	make_from_natural_8_array (a_array: ARRAY [NATURAL_8]): STRING
			-- Convert an array of NATURAL_8 to a STRING using BYTE_ARRAY_CONVERTER
		local
			l_bac: BYTE_ARRAY_CONVERTER
		do
			create l_bac.make (a_array.count)
			across a_array as ic loop
				l_bac.extend (ic.item)
			end
			Result := l_bac.string
		end


feature {NONE} -- PKCS7 Padding

    pkcs7_pad (data: ARRAY [NATURAL_8]; block_size: INTEGER): ARRAY [NATURAL_8]
            -- Apply PKCS7 padding to the data
            --| PKCS7 padding scheme:
			--| When padding is applied, the value of each added byte is the number of bytes that are added.
			--|	For example, if 3 bytes of padding are needed, the padding will be [0x03, 0x03, 0x03].
			--| Last byte indicates padding length:
			--| The last byte of the padded data always indicates how many padding bytes were added.
			--| This is true even if the original data was already a multiple of the block size (in which case, a full block of padding is added).
        require
            valid_block_size: block_size > 0 and block_size <= 255
        local
            padding_length: INTEGER
            i: INTEGER
        do
            padding_length := block_size - (data.count \\ block_size)
            if padding_length = 0 then
                padding_length := block_size
            end

            create Result.make_filled (0, 1, data.count + padding_length)
            Result.subcopy (data, 1, data.count, 1)

            from
                i := data.count + 1
            until
                i > Result.count
            loop
                Result[i] := padding_length.to_natural_8
                i := i + 1
            end
        ensure
            correct_length: Result.count \\ block_size = 0
            padded: Result.count >= data.count + 1
        end

    pkcs7_unpad (data: ARRAY [NATURAL_8]): ARRAY [NATURAL_8]
            -- Remove PKCS7 padding from the data
            --| Unpadding process:
			--| Reads the last byte of the padded data.
			--| Interprets this value as the number of padding bytes.
			--| Verifies that all the padding bytes have the correct value.
			--| Removes the specified number of bytes from the end of the data.
        require
            not_empty: data.count > 0
        local
            padding_length: INTEGER
            i: INTEGER
        do
            padding_length := data.item (data.count).to_integer_32

            if padding_length > 0 and padding_length <= data.count then
                -- Verify padding
                from
                    i := data.count - padding_length + 1
                until
                    i > data.count or data.item (i).to_integer_32 /= padding_length
                loop
                    i := i + 1
                end

                if i > data.count then
                    -- Padding is valid, remove it
                    Result := data.subarray (1, data.count - padding_length)
                else
                    -- Invalid padding, return original data
                    Result := data.twin
                end
            else
                -- Invalid padding length, return original data
                Result := data.twin
            end
        ensure
            unpadded: Result.count <= data.count
        end

invariant
	round_key_size_valid: round_key.count = parameters.key_exp_size
	iv_size_valid: iv.count = aes_blocklen
	iv_correct_size: iv.count = aes_blocklen


end
