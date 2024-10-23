note
    description: "AES-128 parameters"

class
    AES_128_PARAMETERS

inherit
    AES_PARAMETERS

feature -- Access

    key_length: INTEGER = 16

    key_exp_size: INTEGER = 176

    number_of_rounds: INTEGER = 10

    nk: INTEGER = 4
            -- The number of 32 bit words in a key.

end
