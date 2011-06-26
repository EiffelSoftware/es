-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:TypeInfo"
class
	JS_TYPE_INFO

feature -- Introduced in DOM Level 3:

	type_name: STRING
			-- The name of a type declared for the associated element or attribute, or null
			-- if unknown.
		external "C" alias "typeName" end

	type_namespace: STRING
			-- The namespace of the type declared for the associated element or attribute
			-- or null if the element does not have declaration or if no namespace
			-- information is available.
		external "C" alias "typeNamespace" end

feature -- DerivationMethods

	DERIVATION_RESTRICTION: INTEGER
			-- If the document's schema is an XML Schema [XML Schema Part 1], this constant
			-- represents the derivation by restriction if complex types are involved, or a
			-- restriction if simple types are involved.  The reference type definition is
			-- derived by restriction from the other type definition if the other type
			-- definition is the same as the reference type definition, or if the other
			-- type definition can be reached recursively following the {base type
			-- definition} property from the reference type definition, and all the
			-- derivation methods involved are restriction.
		external "C" alias "#0x00000001" end

	DERIVATION_EXTENSION: INTEGER
			-- If the document's schema is an XML Schema [XML Schema Part 1], this constant
			-- represents the derivation by extension.  The reference type definition is
			-- derived by extension from the other type definition if the other type
			-- definition can be reached recursively following the {base type definition}
			-- property from the reference type definition, and at least one of the
			-- derivation methods involved is an extension.
		external "C" alias "#0x00000002" end

	DERIVATION_UNION: INTEGER
			-- If the document's schema is an XML Schema [XML Schema Part 1], this constant
			-- represents the union if simple types are involved.  The reference type
			-- definition is derived by union from the other type definition if there
			-- exists two type definitions T1 and T2 such as the reference type definition
			-- is derived from T1 by DERIVATION_RESTRICTION or DERIVATION_EXTENSION, T2 is
			-- derived from the other type definition by DERIVATION_RESTRICTION, T1 has
			-- {variety} union, and one of the {member type definitions} is T2. Note that
			-- T1 could be the same as the reference type definition, and T2 could be the
			-- same as the other type definition.
		external "C" alias "#0x00000004" end

	DERIVATION_LIST: INTEGER
			-- If the document's schema is an XML Schema [XML Schema Part 1], this constant
			-- represents the list.  The reference type definition is derived by list from
			-- the other type definition if there exists two type definitions T1 and T2
			-- such as the reference type definition is derived from T1 by
			-- DERIVATION_RESTRICTION or DERIVATION_EXTENSION, T2 is derived from the other
			-- type definition by DERIVATION_RESTRICTION, T1 has {variety} list, and T2 is
			-- the {item type definition}. Note that T1 could be the same as the reference
			-- type definition, and T2 could be the same as the other type definition.
		external "C" alias "#0x00000008" end

	is_derived_from (a_type_namespace_arg: STRING; a_type_name_arg: STRING; a_derivation_method: INTEGER): BOOLEAN
			-- This method returns if there is a derivation between the reference type
			-- definition, i.e. the TypeInfo on which the method is being called, and the
			-- other type definition, i.e. the one passed as parameters.
		external "C" alias "isDerivedFrom($a_type_namespace_arg, $a_type_name_arg, $a_derivation_method)" end
end
