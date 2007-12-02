indexing
	description: "Objects that represent a tree node for features"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_FEATURE_NODE

inherit

	CDD_FILTER_NODE

feature {NONE} -- Initialization

	make_with_feature (a_feature: like efeature) is
			-- Create a feature node for `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
		do
			initialize
			efeature := a_feature
		ensure
			efeature_set: efeature = a_feature
		end

feature -- Access

	is_leaf: BOOLEAN is False
			-- Is `Current' a leave within the filter result tree?

	efeature: FEATURE_I
			-- Feature represented by `Current'

	tag: STRING is
			-- Tag for describing `Current'
		do
			Result := efeature.feature_name
		end

feature -- Processing

	process (a_visitor: CDD_FILTER_NODE_VISITOR) is
			-- Call appropriate processor for `Current'.
		do
			a_visitor.process_feature_node (Current)
		end

invariant

	efeature_not_void: efeature /= Void

end
