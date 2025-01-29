note
    description: "Manages console output in a thread-safe way"

class
    CONSOLE_MANAGER

feature -- Output

    print_message (msg: STRING)
            -- Print a message to console
        do
            print (msg)
        end

end
