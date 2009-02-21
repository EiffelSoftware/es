indexing
	description:
		"[
			Boogie code writer for attributes.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_ATTRIBUTE_WRITER

inherit

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

feature -- Basic operations

	write_attribute (a_feature: !FEATURE_I)
			-- Write Boogie code for `a_feature'.
		require
			is_attribute: a_feature.is_attribute
		local
			l_field_name: STRING
			l_type: STRING
		do
			l_field_name := name_generator.attribute_name (a_feature)
			l_type := type_mapper.boogie_type_for_type (a_feature.type)

			put_comment_line ("Attribute name")
			put_line ("const unique " + l_field_name + ": Field " + l_type + ";")
			put_new_line

			-- TODO: make this more generic
			if a_feature.type.is_natural then
				put_comment_line ("Axiom for type NATURAL")
				put_line ("axiom (forall heap: HeapType, $o: ref ::");
				put_line ("            { heap[$o, " + l_field_name + "] }");
				put_line ("        IsHeap(heap) ==> heap[$o, " + l_field_name + "] >= 0);");
			elseif a_feature.type.is_attached and not a_feature.type.is_expanded then
				put_comment_line ("Axiom for type NATURAL")
				put_line ("axiom (forall heap: HeapType, $o: ref ::");
				put_line ("            { heap[$o, " + l_field_name + "] }");
				put_line ("        IsHeap(heap) && IsAllocatedAndNotVoid(heap, $o) ==> IsAllocatedAndNotVoid(heap, heap[$o, " + l_field_name + "]));");
			end
		end

end
