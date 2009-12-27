note
	description: "Summary description for {AFX_IMPLICATION_EXPR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_IMPLICATION_EXPR

inherit
	HASHABLE
		redefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_pre: like premise; a_con: like consequent; a_written_class: CLASS_C)
			-- Initialize Current.
		require
			a_pre_and_a_con_has_same_context: a_pre.has_same_context (a_con)
		do
			premise := a_pre
			consequent := a_con
			written_class := a_written_class
			text := "(" + premise.text + ") implies (" + consequent.text + ")"
			hash_code := text.hash_code
		ensure
			premise_set: premise = a_pre
			consequent_set: consequent = a_con
		end

feature -- Access

	premise: AFX_MODIFIED_EXPRESSION
			-- Premise of Current implication

	consequent: AFX_MODIFIED_EXPRESSION
			-- Consequent of Current implication

	feature_: FEATURE_I
			-- Feature returning to which current expression belongs
		do
			Result := premise.original_expression.feature_
		end

	class_: CLASS_C
			-- Contextc lass of `feature_'
		do
			Result := premise.original_expression.class_
		end

	written_class: CLASS_C
			-- Written class

	text: STRING
			-- Text of current implication

	as_expression: AFX_EXPRESSION
			-- Expression representation
		do
			create {AFX_AST_EXPRESSION} Result.make_with_text (class_, feature_, text, written_class)
		end

	as_conjuction: AFX_EXPRESSION
			-- Expression representing `premise' and `conseuent'
		do
			create {AFX_AST_EXPRESSION} Result.make_with_text (class_, feature_, "(" + premise.text + ") and (" + consequent.text + ")", written_class)
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result :=
				(premise ~ other.premise and then consequent ~ other.consequent) -- or
--				(premise ~ not other.consequent and then consequent ~ not other.premise)
		end

end
