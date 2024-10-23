note
    description: "AES-192 parameters"

class
    AES_192_PARAMETERS

inherit
    AES_PARAMETERS

feature -- Access

    key_length: INTEGER = 24

    key_exp_size: INTEGER = 208

    number_of_rounds: INTEGER = 12

    nk: INTEGER = 6
            -- The number of 32 bit words in a key.

end
