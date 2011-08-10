note
	description: "Class that represents a fragment in a snippet"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_FRAGMENT

inherit
	DEBUG_OUTPUT

create
	make,
	make_as_start,
	make_as_end

feature{NONE} -- Initialization

	make (a_position: INTEGER; a_basic_block_id: INTEGER; a_token: like token)
			-- Initialize Current.
		do
			set_position (a_position)
			set_basic_block_id (a_basic_block_id)
			set_token (a_token)
		end

	make_as_start (a_position: INTEGER; a_basic_block_id: INTEGER)
			-- Initialize Current as a fragment containing a start token.
		do
			make (a_position, a_basic_block_id, create {EXT_START_TOKEN})
		end

	make_as_end (a_position: INTEGER; a_basic_block_id: INTEGER)
			-- Initialize Current as a fragment containing an end token.
		do
			make (a_position, a_basic_block_id, create {EXT_END_TOKEN})
		end

feature -- Access

	position: INTEGER
			-- 1-based position of current fragment in a snippet
			-- Position indicates where a fragment appears in its
			-- hosting snippet.
			-- Different fragments can be in the same position.
			-- For example, multiple features can be mentioned in
			-- a hole, then they all have the same position.			

	basic_block_id: INTEGER
			-- The Id of the basic block from which current fragment
			-- comes. This basic block id used to identify fragments
			-- that come from the same basic block.

	token: EXT_TOKEN
			-- Token of current fragment. This is either a feature call,
			-- a keyword or an auxiliary token such as the snippet start
			-- token or the snippet end token.

	fragment_count: INTEGER
			-- The number of fragments in the hosting snippet

	basic_block_count: INTEGER
			-- The number of basic blocks in the hosting snippet

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (36)
			Result.append_character ('(')
			Result.append_integer (position)
			Result.append_character (',')
			Result.append_character (' ')
			Result.append_integer (basic_block_id)
			Result.append_character (',')
			Result.append_character (' ')
			Result.append (token.debug_output)
			Result.append_character (')')
		end

feature -- Settings

	set_position (a_position: INTEGER)
			-- Set `position' with `a_position'.
		do
			position := a_position
		end

	set_basic_block_id (a_basic_block_id: INTEGER)
			-- Set `basic_block_id' with `a_basic_block_id'.
		do
			basic_block_id := a_basic_block_id
		end

	set_token (a_token: like TOKEN)
			-- Set `token' with `a_token'.
		do
			token := a_token
		end

	set_fragment_count (a_fragment_count: INTEGER)
			-- Set `fragment_count' with `a_fragment_count'.
		do
			fragment_count := a_fragment_count
		end

	set_basic_block_count (a_basic_block_count: INTEGER)
			-- Set `basic_block_count' with `a_basic_block_count'.
		do
			basic_block_count := a_basic_block_count
		end

end
