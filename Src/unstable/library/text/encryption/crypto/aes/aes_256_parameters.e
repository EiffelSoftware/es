note
    description: "AES-256 parameters"

class
    AES_256_PARAMETERS

inherit
    AES_PARAMETERS

feature -- Access

    key_length: INTEGER = 32

    key_exp_size: INTEGER = 240

    number_of_rounds: INTEGER = 14

    nk: INTEGER = 8
            -- The number of 32 bit words in a key.

end
