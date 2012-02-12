note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NS_FILE_PRESENTER_PROTOCOL

inherit
	NS_OBJECT_PROTOCOL

feature -- Optional Methods

--	relinquish_presented_item_to_reader_ (a_reader: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		require
--			has_relinquish_presented_item_to_reader_: has_relinquish_presented_item_to_reader_
--		local
--		do
--			objc_relinquish_presented_item_to_reader_ (item, )
--		end

--	relinquish_presented_item_to_writer_ (a_writer: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		require
--			has_relinquish_presented_item_to_writer_: has_relinquish_presented_item_to_writer_
--		local
--		do
--			objc_relinquish_presented_item_to_writer_ (item, )
--		end

--	save_presented_item_changes_with_completion_handler_ (a_completion_handler: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		require
--			has_save_presented_item_changes_with_completion_handler_: has_save_presented_item_changes_with_completion_handler_
--		local
--		do
--			objc_save_presented_item_changes_with_completion_handler_ (item, )
--		end

--	accommodate_presented_item_deletion_with_completion_handler_ (a_completion_handler: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		require
--			has_accommodate_presented_item_deletion_with_completion_handler_: has_accommodate_presented_item_deletion_with_completion_handler_
--		local
--		do
--			objc_accommodate_presented_item_deletion_with_completion_handler_ (item, )
--		end

	presented_item_did_move_to_ur_l_ (a_new_url: detachable NS_URL)
			-- Auto generated Objective-C wrapper.
		require
			has_presented_item_did_move_to_ur_l_: has_presented_item_did_move_to_ur_l_
		local
			a_new_url__item: POINTER
		do
			if attached a_new_url as a_new_url_attached then
				a_new_url__item := a_new_url_attached.item
			end
			objc_presented_item_did_move_to_ur_l_ (item, a_new_url__item)
		end

	presented_item_did_change
			-- Auto generated Objective-C wrapper.
		require
			has_presented_item_did_change: has_presented_item_did_change
		local
		do
			objc_presented_item_did_change (item)
		end

	presented_item_did_gain_version_ (a_version: detachable NS_FILE_VERSION)
			-- Auto generated Objective-C wrapper.
		require
			has_presented_item_did_gain_version_: has_presented_item_did_gain_version_
		local
			a_version__item: POINTER
		do
			if attached a_version as a_version_attached then
				a_version__item := a_version_attached.item
			end
			objc_presented_item_did_gain_version_ (item, a_version__item)
		end

	presented_item_did_lose_version_ (a_version: detachable NS_FILE_VERSION)
			-- Auto generated Objective-C wrapper.
		require
			has_presented_item_did_lose_version_: has_presented_item_did_lose_version_
		local
			a_version__item: POINTER
		do
			if attached a_version as a_version_attached then
				a_version__item := a_version_attached.item
			end
			objc_presented_item_did_lose_version_ (item, a_version__item)
		end

	presented_item_did_resolve_conflict_version_ (a_version: detachable NS_FILE_VERSION)
			-- Auto generated Objective-C wrapper.
		require
			has_presented_item_did_resolve_conflict_version_: has_presented_item_did_resolve_conflict_version_
		local
			a_version__item: POINTER
		do
			if attached a_version as a_version_attached then
				a_version__item := a_version_attached.item
			end
			objc_presented_item_did_resolve_conflict_version_ (item, a_version__item)
		end

--	accommodate_presented_subitem_deletion_at_ur_l__completion_handler_ (a_url: detachable NS_URL; a_completion_handler: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		require
--			has_accommodate_presented_subitem_deletion_at_ur_l__completion_handler_: has_accommodate_presented_subitem_deletion_at_ur_l__completion_handler_
--		local
--			a_url__item: POINTER
--		do
--			if attached a_url as a_url_attached then
--				a_url__item := a_url_attached.item
--			end
--			objc_accommodate_presented_subitem_deletion_at_ur_l__completion_handler_ (item, a_url__item, )
--		end

	presented_subitem_did_appear_at_ur_l_ (a_url: detachable NS_URL)
			-- Auto generated Objective-C wrapper.
		require
			has_presented_subitem_did_appear_at_ur_l_: has_presented_subitem_did_appear_at_ur_l_
		local
			a_url__item: POINTER
		do
			if attached a_url as a_url_attached then
				a_url__item := a_url_attached.item
			end
			objc_presented_subitem_did_appear_at_ur_l_ (item, a_url__item)
		end

	presented_subitem_at_ur_l__did_move_to_ur_l_ (a_old_url: detachable NS_URL; a_new_url: detachable NS_URL)
			-- Auto generated Objective-C wrapper.
		require
			has_presented_subitem_at_ur_l__did_move_to_ur_l_: has_presented_subitem_at_ur_l__did_move_to_ur_l_
		local
			a_old_url__item: POINTER
			a_new_url__item: POINTER
		do
			if attached a_old_url as a_old_url_attached then
				a_old_url__item := a_old_url_attached.item
			end
			if attached a_new_url as a_new_url_attached then
				a_new_url__item := a_new_url_attached.item
			end
			objc_presented_subitem_at_ur_l__did_move_to_ur_l_ (item, a_old_url__item, a_new_url__item)
		end

	presented_subitem_did_change_at_ur_l_ (a_url: detachable NS_URL)
			-- Auto generated Objective-C wrapper.
		require
			has_presented_subitem_did_change_at_ur_l_: has_presented_subitem_did_change_at_ur_l_
		local
			a_url__item: POINTER
		do
			if attached a_url as a_url_attached then
				a_url__item := a_url_attached.item
			end
			objc_presented_subitem_did_change_at_ur_l_ (item, a_url__item)
		end

	presented_subitem_at_ur_l__did_gain_version_ (a_url: detachable NS_URL; a_version: detachable NS_FILE_VERSION)
			-- Auto generated Objective-C wrapper.
		require
			has_presented_subitem_at_ur_l__did_gain_version_: has_presented_subitem_at_ur_l__did_gain_version_
		local
			a_url__item: POINTER
			a_version__item: POINTER
		do
			if attached a_url as a_url_attached then
				a_url__item := a_url_attached.item
			end
			if attached a_version as a_version_attached then
				a_version__item := a_version_attached.item
			end
			objc_presented_subitem_at_ur_l__did_gain_version_ (item, a_url__item, a_version__item)
		end

	presented_subitem_at_ur_l__did_lose_version_ (a_url: detachable NS_URL; a_version: detachable NS_FILE_VERSION)
			-- Auto generated Objective-C wrapper.
		require
			has_presented_subitem_at_ur_l__did_lose_version_: has_presented_subitem_at_ur_l__did_lose_version_
		local
			a_url__item: POINTER
			a_version__item: POINTER
		do
			if attached a_url as a_url_attached then
				a_url__item := a_url_attached.item
			end
			if attached a_version as a_version_attached then
				a_version__item := a_version_attached.item
			end
			objc_presented_subitem_at_ur_l__did_lose_version_ (item, a_url__item, a_version__item)
		end

	presented_subitem_at_ur_l__did_resolve_conflict_version_ (a_url: detachable NS_URL; a_version: detachable NS_FILE_VERSION)
			-- Auto generated Objective-C wrapper.
		require
			has_presented_subitem_at_ur_l__did_resolve_conflict_version_: has_presented_subitem_at_ur_l__did_resolve_conflict_version_
		local
			a_url__item: POINTER
			a_version__item: POINTER
		do
			if attached a_url as a_url_attached then
				a_url__item := a_url_attached.item
			end
			if attached a_version as a_version_attached then
				a_version__item := a_version_attached.item
			end
			objc_presented_subitem_at_ur_l__did_resolve_conflict_version_ (item, a_url__item, a_version__item)
		end

feature -- Status Report

--	has_relinquish_presented_item_to_reader_: BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		do
--			Result := objc_has_relinquish_presented_item_to_reader_ (item)
--		end

--	has_relinquish_presented_item_to_writer_: BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		do
--			Result := objc_has_relinquish_presented_item_to_writer_ (item)
--		end

--	has_save_presented_item_changes_with_completion_handler_: BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		do
--			Result := objc_has_save_presented_item_changes_with_completion_handler_ (item)
--		end

--	has_accommodate_presented_item_deletion_with_completion_handler_: BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		do
--			Result := objc_has_accommodate_presented_item_deletion_with_completion_handler_ (item)
--		end

	has_presented_item_did_move_to_ur_l_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_presented_item_did_move_to_ur_l_ (item)
		end

	has_presented_item_did_change: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_presented_item_did_change (item)
		end

	has_presented_item_did_gain_version_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_presented_item_did_gain_version_ (item)
		end

	has_presented_item_did_lose_version_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_presented_item_did_lose_version_ (item)
		end

	has_presented_item_did_resolve_conflict_version_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_presented_item_did_resolve_conflict_version_ (item)
		end

--	has_accommodate_presented_subitem_deletion_at_ur_l__completion_handler_: BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		do
--			Result := objc_has_accommodate_presented_subitem_deletion_at_ur_l__completion_handler_ (item)
--		end

	has_presented_subitem_did_appear_at_ur_l_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_presented_subitem_did_appear_at_ur_l_ (item)
		end

	has_presented_subitem_at_ur_l__did_move_to_ur_l_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_presented_subitem_at_ur_l__did_move_to_ur_l_ (item)
		end

	has_presented_subitem_did_change_at_ur_l_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_presented_subitem_did_change_at_ur_l_ (item)
		end

	has_presented_subitem_at_ur_l__did_gain_version_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_presented_subitem_at_ur_l__did_gain_version_ (item)
		end

	has_presented_subitem_at_ur_l__did_lose_version_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_presented_subitem_at_ur_l__did_lose_version_ (item)
		end

	has_presented_subitem_at_ur_l__did_resolve_conflict_version_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_presented_subitem_at_ur_l__did_resolve_conflict_version_ (item)
		end

feature -- Status Report Externals

--	objc_has_relinquish_presented_item_to_reader_ (an_item: POINTER): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return [(id)$an_item respondsToSelector:@selector(relinquishPresentedItemToReader:)];
--			 ]"
--		end

--	objc_has_relinquish_presented_item_to_writer_ (an_item: POINTER): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return [(id)$an_item respondsToSelector:@selector(relinquishPresentedItemToWriter:)];
--			 ]"
--		end

--	objc_has_save_presented_item_changes_with_completion_handler_ (an_item: POINTER): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return [(id)$an_item respondsToSelector:@selector(savePresentedItemChangesWithCompletionHandler:)];
--			 ]"
--		end

--	objc_has_accommodate_presented_item_deletion_with_completion_handler_ (an_item: POINTER): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return [(id)$an_item respondsToSelector:@selector(accommodatePresentedItemDeletionWithCompletionHandler:)];
--			 ]"
--		end

	objc_has_presented_item_did_move_to_ur_l_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(presentedItemDidMoveToURL:)];
			 ]"
		end

	objc_has_presented_item_did_change (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(presentedItemDidChange)];
			 ]"
		end

	objc_has_presented_item_did_gain_version_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(presentedItemDidGainVersion:)];
			 ]"
		end

	objc_has_presented_item_did_lose_version_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(presentedItemDidLoseVersion:)];
			 ]"
		end

	objc_has_presented_item_did_resolve_conflict_version_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(presentedItemDidResolveConflictVersion:)];
			 ]"
		end

--	objc_has_accommodate_presented_subitem_deletion_at_ur_l__completion_handler_ (an_item: POINTER): BOOLEAN
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				return [(id)$an_item respondsToSelector:@selector(accommodatePresentedSubitemDeletionAtURL:completionHandler:)];
--			 ]"
--		end

	objc_has_presented_subitem_did_appear_at_ur_l_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(presentedSubitemDidAppearAtURL:)];
			 ]"
		end

	objc_has_presented_subitem_at_ur_l__did_move_to_ur_l_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(presentedSubitemAtURL:didMoveToURL:)];
			 ]"
		end

	objc_has_presented_subitem_did_change_at_ur_l_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(presentedSubitemDidChangeAtURL:)];
			 ]"
		end

	objc_has_presented_subitem_at_ur_l__did_gain_version_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(presentedSubitemAtURL:didGainVersion:)];
			 ]"
		end

	objc_has_presented_subitem_at_ur_l__did_lose_version_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(presentedSubitemAtURL:didLoseVersion:)];
			 ]"
		end

	objc_has_presented_subitem_at_ur_l__did_resolve_conflict_version_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(presentedSubitemAtURL:didResolveConflictVersion:)];
			 ]"
		end

feature {NONE} -- Optional Methods Externals

--	objc_relinquish_presented_item_to_reader_ (an_item: POINTER; a_reader: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(id <NSFilePresenter>)$an_item relinquishPresentedItemToReader:];
--			 ]"
--		end

--	objc_relinquish_presented_item_to_writer_ (an_item: POINTER; a_writer: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(id <NSFilePresenter>)$an_item relinquishPresentedItemToWriter:];
--			 ]"
--		end

--	objc_save_presented_item_changes_with_completion_handler_ (an_item: POINTER; a_completion_handler: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(id <NSFilePresenter>)$an_item savePresentedItemChangesWithCompletionHandler:];
--			 ]"
--		end

--	objc_accommodate_presented_item_deletion_with_completion_handler_ (an_item: POINTER; a_completion_handler: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(id <NSFilePresenter>)$an_item accommodatePresentedItemDeletionWithCompletionHandler:];
--			 ]"
--		end

	objc_presented_item_did_move_to_ur_l_ (an_item: POINTER; a_new_url: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSFilePresenter>)$an_item presentedItemDidMoveToURL:$a_new_url];
			 ]"
		end

	objc_presented_item_did_change (an_item: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSFilePresenter>)$an_item presentedItemDidChange];
			 ]"
		end

	objc_presented_item_did_gain_version_ (an_item: POINTER; a_version: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSFilePresenter>)$an_item presentedItemDidGainVersion:$a_version];
			 ]"
		end

	objc_presented_item_did_lose_version_ (an_item: POINTER; a_version: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSFilePresenter>)$an_item presentedItemDidLoseVersion:$a_version];
			 ]"
		end

	objc_presented_item_did_resolve_conflict_version_ (an_item: POINTER; a_version: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSFilePresenter>)$an_item presentedItemDidResolveConflictVersion:$a_version];
			 ]"
		end

--	objc_accommodate_presented_subitem_deletion_at_ur_l__completion_handler_ (an_item: POINTER; a_url: POINTER; a_completion_handler: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(id <NSFilePresenter>)$an_item accommodatePresentedSubitemDeletionAtURL:$a_url completionHandler:];
--			 ]"
--		end

	objc_presented_subitem_did_appear_at_ur_l_ (an_item: POINTER; a_url: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSFilePresenter>)$an_item presentedSubitemDidAppearAtURL:$a_url];
			 ]"
		end

	objc_presented_subitem_at_ur_l__did_move_to_ur_l_ (an_item: POINTER; a_old_url: POINTER; a_new_url: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSFilePresenter>)$an_item presentedSubitemAtURL:$a_old_url didMoveToURL:$a_new_url];
			 ]"
		end

	objc_presented_subitem_did_change_at_ur_l_ (an_item: POINTER; a_url: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSFilePresenter>)$an_item presentedSubitemDidChangeAtURL:$a_url];
			 ]"
		end

	objc_presented_subitem_at_ur_l__did_gain_version_ (an_item: POINTER; a_url: POINTER; a_version: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSFilePresenter>)$an_item presentedSubitemAtURL:$a_url didGainVersion:$a_version];
			 ]"
		end

	objc_presented_subitem_at_ur_l__did_lose_version_ (an_item: POINTER; a_url: POINTER; a_version: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSFilePresenter>)$an_item presentedSubitemAtURL:$a_url didLoseVersion:$a_version];
			 ]"
		end

	objc_presented_subitem_at_ur_l__did_resolve_conflict_version_ (an_item: POINTER; a_url: POINTER; a_version: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSFilePresenter>)$an_item presentedSubitemAtURL:$a_url didResolveConflictVersion:$a_version];
			 ]"
		end

end