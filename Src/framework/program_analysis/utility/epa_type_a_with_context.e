note
	description: "TYPE_A with possibly context class, and possibly context feature"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_TYPE_A_WITH_CONTEXT

inherit
	REFACTORING_HELPER

create
	make,
	make_with_class,
	make_with_class_and_feature

feature{NONE} -- Initialization

	make (a_type: like type)
			-- Initialize Current.
		do
			set_type (a_type)
		end

	make_with_class (a_type: like type; a_class: like context_class)
			-- Initialize Current.
		do
			make (a_type)
			set_context_class (a_class)
		end

	make_with_class_and_feature (a_type: like type; a_class: like context_class; a_feature: like context_feature)
			-- Initialize Current.
		do
			make_with_class (a_type, a_class)
			set_context_feature (a_feature)
		end

feature -- Access

	type: TYPE_A
			-- Type associated with Current

	context_class: detachable CLASS_C
			-- Context class

	context_feature: detachable FEATURE_I
			-- Context feature

	instantiated_type: TYPE_A
			-- Resolved type of `type' in `context_class' and `context_feature'
			-- Things that are resolved: anchored, formal generic parameter are replaced with the constrained type.
		do
			fixme ("To implement. 23.2.2010 Jasonw")
			Result := type
		end

	is_instantiated_equivalent (other: like Current): BOOLEAN
			-- Is `other'.`instantiated_type' equivalent to Current.`instantiated_type'?
		require
			other_attached: other /= Void
		do
			Result := instantiated_type.is_equivalent (other.instantiated_type)
		end

	is_conformant_to (other: like Current): BOOLEAN
			-- Is Current conformant to `other'?
		do
			if attached {CLASS_C} other.context_class as l_other_context_class then
				Result := type.conform_to (l_other_context_class, other.type)
			end
		end

feature -- Setting

	set_type (a_type: like type)
			-- Set `type' with `a_type'.
		do
			type := a_type
		ensure
			type_set: type = a_type
		end

	set_context_class (a_context_class: like context_class)
			-- Set `context_class' with `a_context_class'.
		do
			context_class := a_context_class
		ensure
			context_class_set: context_class = a_context_class
		end

	set_context_feature (a_context_feature: like context_feature)
			-- Set `context_feature' with `a_context_feature'.
		do
			context_feature := a_context_feature
		ensure
			context_feature_set: context_feature = a_context_feature
		end

end
