indexing
	description: "An evironment for the Ballet generation"
	author: "Bernd Schoeller and others"
	date: "$Date$"
	revision: "$Revision$"

class

	BPL_ENVIRONMENT

inherit

	KL_SHARED_STANDARD_FILES
		export
			{NONE} all
		end

create

	make

feature{NONE} -- Initialization

	make is
			-- Generate a BPL environment, generating code to `a_stream'.
		do
			create error_log.make
			out_stream := std.output
			next_free_label := 1
			last_label := "first_label"
		ensure
			stream_set: out_stream = std.output
			error_log_generated: error_log /= Void
			error_log_empty: not error_log.has_error
		end

feature -- Access

	error_log: BPL_ERROR_LOG
		-- Error log to report errors to

	out_stream: KI_TEXT_OUTPUT_STREAM
		-- Output stream for the generation of BoogiePL code

	last_string_id: INTEGER

	new_string_id is
			-- Generate a new string ID.
		do
			last_string_id := last_string_id + 1
		end

	usage_analyser: BPL_FEATURE_LIST_GENERATOR
		-- collect the lists of queries, which are defined and used in current class
	
feature -- Settors

	set_out_stream (a_stream: KI_TEXT_OUTPUT_STREAM) is
			-- Set the output stream to `a_stream'.
		require
			a_stream_not_void: a_stream /= Void
		do
			out_stream := a_stream
		ensure
			stream_set: out_stream = a_stream
		end

	set_usage_analyser (analyser: BPL_FEATURE_LIST_GENERATOR) is
			-- Set the usage_analyser to `analyser'
		require
			analyser_not_void: analyser /= Void
		do
			usage_analyser := analyser
		ensure
			analyser_set: usage_analyser = analyser
		end

feature -- Label handling

	last_label: STRING

	new_label (a_prefix: STRING) is
			-- Create a new label.
		require
			not_void: a_prefix /= Void
			not_empty: a_prefix.count >= 1
		do
			last_label := a_prefix+next_free_label.out
			next_free_label := next_free_label + 1
		end

	next_free_label: INTEGER
		-- Next label number to create

invariant
	error_log_not_void: error_log /= Void
	out_not_void: out_stream /= Void
	last_label_not_void: last_label /= Void
end
