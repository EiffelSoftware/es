note
    description: "Strategy class for AES parameters"
    date: "$Date$"
    revision: "$Revision$"

deferred class
    AES_PARAMETERS

feature -- Access

    key_length: INTEGER
        deferred
        end

    key_exp_size: INTEGER
        deferred
        end

    number_of_rounds: INTEGER
        deferred
        end

    nk: INTEGER
        deferred
        end

feature -- Constants

    nb: INTEGER = 4
            -- The number of columns comprising a state in AES. This is a constant in AES.

end
