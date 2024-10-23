# aes-eiffel

aes-eiffel is an Eiffel implementation of the Advanced Encryption Standard (AES) algorithm, based on the [tiny-AES-c](https://github.com/kokke/tiny-AES-c) C implementation. This library provides a simple and efficient way to perform AES encryption and decryption in Eiffel applications.

## Features

- Supports AES-128, AES-192 and AES-256 encryption and decryption.
- Implements three modes of operation:
  - ECB (Electronic Codebook)
  - CBC (Cipher Block Chaining)
  - CTR (Counter)
- Provides string-based operations for easy encryption and decryption of text
- Includes PKCS7 padding for block alignment
- Designed for simplicity and ease of use

## Usage

The library provides three main methods for each mode of operation:

1. ECB Mode:
   - `ecb_encoding_string(plaintext, key): STRING`
   - `ecb_decoding_string(ciphertext, key): STRING`

2. CBC Mode:
   - `cbc_encoding_string(plaintext, key, iv): STRING`
   - `cbc_decoding_string(ciphertext, key, iv): STRING`

3. CTR Mode:
   - `ctr_encoding_string(plaintext, key, nonce): STRING`
   - `ctr_decoding_string(ciphertext, key, nonce): STRING`

Example usage:

```eiffel

    local
        aes: AES
        key, plaintext, encrypted, decrypted: STRING
    do
        create aes.make
        key := "Sixteen byte key"
        plaintext := "Hello, World!"
        encrypted := aes.ecb_encoding_string(plaintext, key)
        decrypted := aes.ecb_decoding_string(encrypted, key)
        check plaintext.is_equal(decrypted) end
    end
 ```   

## Security Considerations

- CTR (Counter) mode is generally considered more secure and preferable compared to ECB and CBC modes.[1][2]
- ECB mode is the least secure and should be avoided for most use cases, especially for data larger than a single block.[3]
- CTR mode offers advantages over CBC:
  - Better performance on multi-core systems due to easier parallelization.[1]
  - No risks associated with padding.[4]
- Key security considerations:
  - Proper key management is crucial for all modes.[5]
  - CTR mode requires unique nonces (IVs) for each encryption operation.[6]
  - For maximum security, authenticated encryption modes like GCM (which builds on CTR) are recommended.[7]
- While CTR is generally more secure than CBC or ECB, combining CTR with a proper authentication mechanism or using an authenticated encryption mode like GCM is the most secure approach.[8]
- Always use a secure method to generate keys and IVs/nonces.[9]

[1]: https://crypto.stackexchange.com/questions/6029/aes-cbc-mode-or-aes-ctr-mode-recommended
[2]: https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Counter_(CTR)
[3]: https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Electronic_Codebook_(ECB)
[4]: https://crypto.stackexchange.com/questions/3883/why-is-cbc-mode-vulnerable-to-padding-oracle-attacks
[5]: https://csrc.nist.gov/projects/key-management/cryptographic-key-management-systems
[6]: https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38a.pdf
[7]: https://en.wikipedia.org/wiki/Galois/Counter_Mode
[8]: https://www.cryptomathic.com/news-events/blog/advantages-of-authenticated-encryption-over-aes-cbc-mode
[9]: https://csrc.nist.gov/publications/detail/sp/800-90a/rev-1/final
