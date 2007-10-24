indexing
	description: "Visitor for the program Flow - Sink"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PROGRAM_FLOW_SINK_VISITOR

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	visit_null_sink(null_sink: NULL_PROGRAM_FLOW_SINK) is
			--
		deferred end

	visit_recorder(recorder: RECORDER) is
			--
		deferred end

	visit_player(player: PLAYER) is
			--
		deferred end

	visit_logging_player(logging_player: LOGGING_PLAYER) is
			--
		deferred end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
