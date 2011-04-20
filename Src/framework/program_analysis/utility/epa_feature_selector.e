note
	description: "Class to select features from a class"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FEATURE_SELECTOR

inherit
	ANY
		redefine
			default_create
		end

	SHARED_WORKBENCH
		undefine
			default_create
		end

create
	default_create

feature{NONE} -- Initialization

	default_create
			-- Initialize Current.
		do
			create criteria.make
		end

feature -- Access

	last_features: LINKED_LIST [FEATURE_I]
			-- Last selected features

feature -- Selection

	select_from_class (a_class: CLASS_C)
			-- Select features from `a_class' satisfying all the given criteria.
			-- Make results available in `last_features'.
		local
			l_feat_tbl: FEATURE_TABLE
			l_cursor: CURSOR
			l_feats: LINKED_LIST [FEATURE_I]
		do
			l_feat_tbl := a_class.feature_table
			l_cursor := l_feat_tbl.cursor
			create l_feats.make
			from
				l_feat_tbl.start
			until
				l_feat_tbl.after
			loop
				l_feats.extend (l_feat_tbl.item_for_iteration)
				l_feat_tbl.forth
			end
			l_feat_tbl.go_to (l_cursor)
			select_from_features (l_feats)
		end

	select_from_features (a_features: LINKED_LIST [FEATURE_I])
			-- Select features from `a_features' which satisfy all the given criteria.
			-- Make Result avaialbe in `last_features'.
		do
			create last_features.make
			if criteria.is_empty then
				a_features.do_all (agent last_features.extend)
			else
				across a_features as l_feats loop
					if across criteria as l_cris all l_cris.item.item ([l_feats.item]) end then
						last_features.extend (l_feats.item)
					end
				end
			end
		end

feature -- Feature selection criteria

	criteria: LINKED_LIST [FUNCTION [ANY, TUPLE [a_feature: FEATURE_I], BOOLEAN]]
			-- List of criteria to select a feature
			-- A feature is to be selected if and only if it passes
			-- all criteria. If no criterion is given, all features are passed by default.
			-- Do not modify this list, only use `add_xxx_selector' features.

feature -- Selection criterion setup

	add_selector (a_selector: FUNCTION [ANY, TUPLE [a_feature: FEATURE_I], BOOLEAN])
			-- Add `a_selector' into `crieria'.
		do
			criteria.extend (a_selector)
		end

	add_query_selector
			-- Add criterion to select queries into `criteria'.
		do
			add_selector (query_feature_selector)
		end

	add_command_selector
			-- Add criterion to select commands into `criteria'.
		do
			add_selector (command_feature_selector)
		end

	add_exported_feature_selector
			-- Add criterion to select features that are exported to {ANY}.
		do
			add_selector (exported_feature_selector)
		end

	add_argumented_feature_selector (a_min: INTEGER; a_max: INTEGER)
			-- Added a criterion to select features with at least
			-- `a_min' argument and at most `a_max' argument.
		do
			add_selector (argumented_feature_selector (a_min, a_max))
		end

feature -- Access/criteria

	query_feature_selector: FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]
			-- An agent to select features that are queries.
		do
			Result := agent (a_feat: FEATURE_I): BOOLEAN
				do
					Result := a_feat.has_return_value
				end
		end

	command_feature_selector: FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]
			-- An agent to select features that are commands.
		do
			Result := agent (a_feat: FEATURE_I): BOOLEAN
				do
					Result := not a_feat.has_return_value
				end
		end

	exported_feature_selector: FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]
			-- An agent to select features that are exported to {ANY}
		do
			Result := agent (a_feat: FEATURE_I): BOOLEAN
				do
					Result := a_feat.is_exported_for (system.any_class.compiled_representation)
				end
		end

	negated_feature_selector (a_selector: FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]): FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]
			-- A selector which negates `a_selector'
		do
			Result := agent (a_feat: FEATURE_I; a_sel: FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]): BOOLEAN
				do
					Result := not a_sel.item ([a_feat])
				end	(?, a_selector)
		end

	not_from_any_feature_selector: FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]
			-- An agent to select features that are not from {ANY}
		do
			Result := agent (a_feat: FEATURE_I): BOOLEAN
				do
					Result := a_feat.written_class.class_id /= system.any_class.compiled_representation.class_id
				end
		end

	argumented_feature_selector (a_min: INTEGER; a_max: INTEGER): FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]
			-- An agent to select features with at least `a_min' argument and
			-- at most `a_max' argument.
		do
			Result := agent (a_feat: FEATURE_I; a_lower: INTEGER; a_upper: INTEGER): BOOLEAN
				do
					Result := a_feat.argument_count >= a_lower and then a_feat.argument_count <= a_upper
				end	(?, a_min, a_max)
		end


end
