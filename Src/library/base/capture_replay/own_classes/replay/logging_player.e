indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOGGING_PLAYER

inherit
	PLAYER
	rename
		setup_on_text_file as setup_player_on_textfile
	redefine
		methodbody_end,
		methodbody_start
	end

create
	make

feature -- Initialization

	setup_on_text_files(replay_filename:STRING; log_filename: STRING; a_caller: CALLER) is
			--
		do
			setup_player_on_textfile (replay_filename,a_caller)
			create recorder.make
			recorder.setup_on_text_serializer (log_filename)
		end

feature -- Access
	recorder: RECORDER

feature -- Measurement

feature -- Status report

feature -- Status setting
	set_recorder(a_recorder: RECORDER) is
			-- Set `recorder'
		require
			a_recorder_not_void: a_recorder /= Void
		do
			recorder := a_recorder
		end

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations
		methodbody_start (feature_name: STRING_8; target: ANY; arguments: TUPLE) is
				--
			do
				recorder.methodbody_start(feature_name,target,arguments)
				Precursor {PLAYER}(feature_name, target, arguments)
			end

		methodbody_end (res: ANY): ANY is
				--
			local
				ignore_result: ANY
			do
				Result := Precursor {PLAYER}(res)
				ignore_result := recorder.methodbody_end(Result)
			end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
