deferred class
	METRIC

inherit
	DEBUG_OUTPUT

	QL_VISITOR
	redefine
		process_feature,
		process_group,
		process_real_feature,
		process_invariant,
		process_quantity,
		process_line,
		process_local,
		process_assertion,
		process_domain,
		process_argument,
		process_target,
		process_class,
		process_generic
	end

feature

	last_result : QL_QUANTITY is
		deferred
		ensure
			result_set : Result /= Void
		end

	make (item : QL_ITEM) is
		require
			item_set : item /= Void
		deferred
		end

	evaluate is
		deferred
		end

feature {METRIC} -- Implementation (QL Visitor)

	process_feature (l_as : QL_FEATURE) is
		do
		end

	process_group (l_as : QL_GROUP) is
		do
		end

	process_real_feature (l_as : QL_REAL_FEATURE) is
		do
		end

	process_invariant (l_as : QL_INVARIANT) is
		do
		end

	process_quantity (l_as : QL_QUANTITY) is
		do
		end

	process_line (l_as : QL_LINE) is
		do
		end

	process_local (l_as : QL_LOCAL) is
		do
		end

	process_assertion (l_as : QL_ASSERTION) is
		do
		end

	process_domain (l_as : QL_DOMAIN) is
		do
		end

	process_argument (l_as : QL_ARGUMENT) is
		do
		end

	process_target (l_as : QL_TARGET) is
		do
		end

	process_class (l_as : QL_CLASS) is
		do
		end

	process_generic (l_as : QL_GENERIC) is
		do
		end

end
