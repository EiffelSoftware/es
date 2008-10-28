indexing
	description: "Given an AST node, this visitor will find the definition of the first feature used"
	author: "Bernd Schoeller"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_DEFINITION_SEARCH

inherit
	BPL_VISITOR
		redefine
			process_access_feat_as,
			process_access_id_as,
			process_nested_as,
			process_nested_expr_as,
			process_access_inv_as,
			process_binary_as,
			process_unary_as
		end

create
	make

feature -- Result Access

	last_feature: FEATURE_I

feature -- Process

	process_access_feat_as (l_as: ACCESS_FEAT_AS) is
			-- Process `l_as'.
		do
			last_feature := current_class.feature_named (l_as.access_name)
		end

	process_access_inv_as (l_as: ACCESS_INV_AS) is
			-- Process `l_as'.
		do
			last_feature := current_class.feature_named (l_as.access_name)
		end

	process_access_id_as (l_as: ACCESS_ID_AS) is
			-- Process `l_as'.
		do
			last_feature := current_class.feature_named (l_as.access_name)
		end

	process_nested_as (l_as: NESTED_AS) is
			-- Process `l_as'.
		local
			nested_expr_as: NESTED_EXPR_AS
		do
			nested_expr_as := nested_as_to_nested_expr_as (l_as)
			nested_expr_as.process (Current)
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS) is
			-- Process `l_as'.
		local
			type_a: TYPE_A
			access_feat_as: ACCESS_FEAT_AS
			access_id_as: ACCESS_ID_AS
		do
			type_a := type_for (l_as.target)
			access_feat_as ?= l_as.message
			access_id_as ?= l_as.message
			if access_feat_as /= Void then
				last_feature := type_a.associated_class.feature_named (access_feat_as.access_name)
			elseif access_id_as /= Void then
				last_feature := type_a.associated_class.feature_named (access_id_as.access_name)
			else
				check
					not_implemented: False
				end
			end
		end

	process_binary_as (l_as: BINARY_AS) is
			-- Process `l_as'.
		local
			type_a: TYPE_A
		do
			type_a := type_for(l_as.left)
			last_feature := type_a.associated_class.feature_named ("infix %"" + l_as.op_name.name + "%"")
		end

	process_unary_as (l_as: UNARY_AS) is
			-- Process `l_as'.
		local
			type_a: TYPE_A
		do
			type_a := type_for(l_as.expr)
			last_feature := type_a.associated_class.feature_named ("prefix %"" + l_as.operator_name + "%"")
		end

end
