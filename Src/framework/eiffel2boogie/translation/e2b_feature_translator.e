note
	description: "Base class for feature translators."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_FEATURE_TRANSLATOR

inherit

	E2B_SHARED_CONTEXT

	SHARED_WORKBENCH
		export {NONE} all end

	SHARED_SERVER
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

	E2B_SHARED_BOOGIE_UNIVERSE

	IV_SHARED_TYPES

end
