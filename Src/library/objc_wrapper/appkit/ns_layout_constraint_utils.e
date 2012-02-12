note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_LAYOUT_CONSTRAINT_UTILS

inherit
	NS_OBJECT_UTILS
		redefine
			wrapper_objc_class_name,
			is_subclass_instance
		end


feature -- NSLayoutConstraint

	constraints_with_visual_format__options__metrics__views_ (a_format: detachable NS_STRING; a_opts: NATURAL_64; a_metrics: detachable NS_DICTIONARY; a_views: detachable NS_DICTIONARY): detachable NS_ARRAY
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_format__item: POINTER
			a_metrics__item: POINTER
			a_views__item: POINTER
		do
			if attached a_format as a_format_attached then
				a_format__item := a_format_attached.item
			end
			if attached a_metrics as a_metrics_attached then
				a_metrics__item := a_metrics_attached.item
			end
			if attached a_views as a_views_attached then
				a_views__item := a_views_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_constraints_with_visual_format__options__metrics__views_ (l_objc_class.item, a_format__item, a_opts, a_metrics__item, a_views__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like constraints_with_visual_format__options__metrics__views_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like constraints_with_visual_format__options__metrics__views_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	constraint_with_item__attribute__related_by__to_item__attribute__multiplier__constant_ (a_view1: detachable NS_OBJECT; a_attr1: INTEGER_64; a_relation: INTEGER_64; a_view2: detachable NS_OBJECT; a_attr2: INTEGER_64; a_multiplier: REAL_64; a_c: REAL_64): detachable NS_OBJECT
			-- Auto generated Objective-C wrapper.
		local
			result_pointer: POINTER
			l_objc_class: OBJC_CLASS
			a_view1__item: POINTER
			a_view2__item: POINTER
		do
			if attached a_view1 as a_view1_attached then
				a_view1__item := a_view1_attached.item
			end
			if attached a_view2 as a_view2_attached then
				a_view2__item := a_view2_attached.item
			end
			create l_objc_class.make_with_name (get_class_name)
			check l_objc_class_registered: l_objc_class.registered end
			result_pointer := objc_constraint_with_item__attribute__related_by__to_item__attribute__multiplier__constant_ (l_objc_class.item, a_view1__item, a_attr1, a_relation, a_view2__item, a_attr2, a_multiplier, a_c)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like constraint_with_item__attribute__related_by__to_item__attribute__multiplier__constant_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like constraint_with_item__attribute__related_by__to_item__attribute__multiplier__constant_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature {NONE} -- NSLayoutConstraint Externals

	objc_constraints_with_visual_format__options__metrics__views_ (a_class_object: POINTER; a_format: POINTER; a_opts: NATURAL_64; a_metrics: POINTER; a_views: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object constraintsWithVisualFormat:$a_format options:$a_opts metrics:$a_metrics views:$a_views];
			 ]"
		end

	objc_constraint_with_item__attribute__related_by__to_item__attribute__multiplier__constant_ (a_class_object: POINTER; a_view1: POINTER; a_attr1: INTEGER_64; a_relation: INTEGER_64; a_view2: POINTER; a_attr2: INTEGER_64; a_multiplier: REAL_64; a_c: REAL_64): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <AppKit/AppKit.h>"
		alias
			"[
				return (EIF_POINTER)[(Class)$a_class_object constraintWithItem:$a_view1 attribute:$a_attr1 relatedBy:$a_relation toItem:$a_view2 attribute:$a_attr2 multiplier:$a_multiplier constant:$a_c];
			 ]"
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSLayoutConstraint"
		end

	is_subclass_instance: BOOLEAN
			-- <Precursor>
		do
			Result := False
		end

end