indexing
	description: "Interface for event Serializers."
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CAPTURE_SERIALIZER

feature -- Access
	file: FILE deferred end --the log file

feature -- Basic operations

	write_incall (feature_name: STRING; target: ANY; arguments: TUPLE)
			-- Log an INCALL event for `target'.`feature'(`arguments').
		require
			feature_name_not_void: feature_name /= Void
			target_not_void: target /= Void
			arguments_not_void:	arguments /= Void
		deferred
		end

	write_incallret (the_result: ANY)
			-- Write the INCALLRET event for result `the_result'.
		deferred
		end

	write_outcall(feature_name: STRING; target: ANY; arguments: TUPLE)
			-- Write the OUTCALL event for `target'.`feature'(`arguments').
		require
			feature_name_not_void: feature_name /= Void
			target_not_void: target /= Void
			arguments_not_void:	arguments /= Void
		deferred
		end

	write_outcallret(the_result: ANY)
			-- Write the OUTCALLRET event for result `the_result'
		deferred
		end

	close_file
			-- Close `file'
		require
			file_open: file.is_open_write
		deferred
		ensure
			file_closed: not file.is_open_write
		end


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
invariant
	invariant_clause: True
end
