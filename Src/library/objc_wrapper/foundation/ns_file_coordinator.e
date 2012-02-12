note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_FILE_COORDINATOR

inherit
	NS_OBJECT
		redefine
			wrapper_objc_class_name
		end


create {NS_ANY}
	make_with_pointer,
	make_with_pointer_and_retain

create
	make_with_file_presenter_,
	make

feature {NONE} -- Initialization

	make_with_file_presenter_ (a_file_presenter_or_nil: detachable NS_FILE_PRESENTER_PROTOCOL)
			-- Initialize `Current'.
		local
			a_file_presenter_or_nil__item: POINTER
		do
			if attached a_file_presenter_or_nil as a_file_presenter_or_nil_attached then
				a_file_presenter_or_nil__item := a_file_presenter_or_nil_attached.item
			end
			make_with_pointer (objc_init_with_file_presenter_(allocate_object, a_file_presenter_or_nil__item))
			if item = default_pointer then
				-- TODO: handle initialization error.
			end
		end

feature {NONE} -- NSFileCoordinator Externals

	objc_init_with_file_presenter_ (an_item: POINTER; a_file_presenter_or_nil: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(NSFileCoordinator *)$an_item initWithFilePresenter:$a_file_presenter_or_nil];
			 ]"
		end

--	objc_coordinate_reading_item_at_ur_l__options__error__by_accessor_ (an_item: POINTER; a_url: POINTER; a_options: NATURAL_64; a_out_error: UNSUPPORTED_TYPE; a_reader: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSFileCoordinator *)$an_item coordinateReadingItemAtURL:$a_url options:$a_options error: byAccessor:];
--			 ]"
--		end

--	objc_coordinate_writing_item_at_ur_l__options__error__by_accessor_ (an_item: POINTER; a_url: POINTER; a_options: NATURAL_64; a_out_error: UNSUPPORTED_TYPE; a_writer: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSFileCoordinator *)$an_item coordinateWritingItemAtURL:$a_url options:$a_options error: byAccessor:];
--			 ]"
--		end

--	objc_coordinate_reading_item_at_ur_l__options__writing_item_at_ur_l__options__error__by_accessor_ (an_item: POINTER; a_reading_url: POINTER; a_reading_options: NATURAL_64; a_writing_url: POINTER; a_writing_options: NATURAL_64; a_out_error: UNSUPPORTED_TYPE; a_reader_writer: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSFileCoordinator *)$an_item coordinateReadingItemAtURL:$a_reading_url options:$a_reading_options writingItemAtURL:$a_writing_url options:$a_writing_options error: byAccessor:];
--			 ]"
--		end

--	objc_coordinate_writing_item_at_ur_l__options__writing_item_at_ur_l__options__error__by_accessor_ (an_item: POINTER; a_url1: POINTER; a_options1: NATURAL_64; a_url2: POINTER; a_options2: NATURAL_64; a_out_error: UNSUPPORTED_TYPE; a_writer: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSFileCoordinator *)$an_item coordinateWritingItemAtURL:$a_url1 options:$a_options1 writingItemAtURL:$a_url2 options:$a_options2 error: byAccessor:];
--			 ]"
--		end

--	objc_prepare_for_reading_items_at_ur_ls__options__writing_items_at_ur_ls__options__error__by_accessor_ (an_item: POINTER; a_reading_ur_ls: POINTER; a_reading_options: NATURAL_64; a_writing_ur_ls: POINTER; a_writing_options: NATURAL_64; a_out_error: UNSUPPORTED_TYPE; a_batch_accessor: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		external
--			"C inline use <Foundation/Foundation.h>"
--		alias
--			"[
--				[(NSFileCoordinator *)$an_item prepareForReadingItemsAtURLs:$a_reading_ur_ls options:$a_reading_options writingItemsAtURLs:$a_writing_ur_ls options:$a_writing_options error: byAccessor:];
--			 ]"
--		end

	objc_item_at_ur_l__did_move_to_ur_l_ (an_item: POINTER; a_old_url: POINTER; a_new_url: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSFileCoordinator *)$an_item itemAtURL:$a_old_url didMoveToURL:$a_new_url];
			 ]"
		end

	objc_cancel (an_item: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(NSFileCoordinator *)$an_item cancel];
			 ]"
		end

feature -- NSFileCoordinator

--	coordinate_reading_item_at_ur_l__options__error__by_accessor_ (a_url: detachable NS_URL; a_options: NATURAL_64; a_out_error: UNSUPPORTED_TYPE; a_reader: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_url__item: POINTER
--			a_out_error__item: POINTER
--		do
--			if attached a_url as a_url_attached then
--				a_url__item := a_url_attached.item
--			end
--			if attached a_out_error as a_out_error_attached then
--				a_out_error__item := a_out_error_attached.item
--			end
--			objc_coordinate_reading_item_at_ur_l__options__error__by_accessor_ (item, a_url__item, a_options, a_out_error__item, )
--		end

--	coordinate_writing_item_at_ur_l__options__error__by_accessor_ (a_url: detachable NS_URL; a_options: NATURAL_64; a_out_error: UNSUPPORTED_TYPE; a_writer: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_url__item: POINTER
--			a_out_error__item: POINTER
--		do
--			if attached a_url as a_url_attached then
--				a_url__item := a_url_attached.item
--			end
--			if attached a_out_error as a_out_error_attached then
--				a_out_error__item := a_out_error_attached.item
--			end
--			objc_coordinate_writing_item_at_ur_l__options__error__by_accessor_ (item, a_url__item, a_options, a_out_error__item, )
--		end

--	coordinate_reading_item_at_ur_l__options__writing_item_at_ur_l__options__error__by_accessor_ (a_reading_url: detachable NS_URL; a_reading_options: NATURAL_64; a_writing_url: detachable NS_URL; a_writing_options: NATURAL_64; a_out_error: UNSUPPORTED_TYPE; a_reader_writer: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_reading_url__item: POINTER
--			a_writing_url__item: POINTER
--			a_out_error__item: POINTER
--		do
--			if attached a_reading_url as a_reading_url_attached then
--				a_reading_url__item := a_reading_url_attached.item
--			end
--			if attached a_writing_url as a_writing_url_attached then
--				a_writing_url__item := a_writing_url_attached.item
--			end
--			if attached a_out_error as a_out_error_attached then
--				a_out_error__item := a_out_error_attached.item
--			end
--			objc_coordinate_reading_item_at_ur_l__options__writing_item_at_ur_l__options__error__by_accessor_ (item, a_reading_url__item, a_reading_options, a_writing_url__item, a_writing_options, a_out_error__item, )
--		end

--	coordinate_writing_item_at_ur_l__options__writing_item_at_ur_l__options__error__by_accessor_ (a_url1: detachable NS_URL; a_options1: NATURAL_64; a_url2: detachable NS_URL; a_options2: NATURAL_64; a_out_error: UNSUPPORTED_TYPE; a_writer: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_url1__item: POINTER
--			a_url2__item: POINTER
--			a_out_error__item: POINTER
--		do
--			if attached a_url1 as a_url1_attached then
--				a_url1__item := a_url1_attached.item
--			end
--			if attached a_url2 as a_url2_attached then
--				a_url2__item := a_url2_attached.item
--			end
--			if attached a_out_error as a_out_error_attached then
--				a_out_error__item := a_out_error_attached.item
--			end
--			objc_coordinate_writing_item_at_ur_l__options__writing_item_at_ur_l__options__error__by_accessor_ (item, a_url1__item, a_options1, a_url2__item, a_options2, a_out_error__item, )
--		end

--	prepare_for_reading_items_at_ur_ls__options__writing_items_at_ur_ls__options__error__by_accessor_ (a_reading_ur_ls: detachable NS_ARRAY; a_reading_options: NATURAL_64; a_writing_ur_ls: detachable NS_ARRAY; a_writing_options: NATURAL_64; a_out_error: UNSUPPORTED_TYPE; a_batch_accessor: UNSUPPORTED_TYPE)
--			-- Auto generated Objective-C wrapper.
--		local
--			a_reading_ur_ls__item: POINTER
--			a_writing_ur_ls__item: POINTER
--			a_out_error__item: POINTER
--		do
--			if attached a_reading_ur_ls as a_reading_ur_ls_attached then
--				a_reading_ur_ls__item := a_reading_ur_ls_attached.item
--			end
--			if attached a_writing_ur_ls as a_writing_ur_ls_attached then
--				a_writing_ur_ls__item := a_writing_ur_ls_attached.item
--			end
--			if attached a_out_error as a_out_error_attached then
--				a_out_error__item := a_out_error_attached.item
--			end
--			objc_prepare_for_reading_items_at_ur_ls__options__writing_items_at_ur_ls__options__error__by_accessor_ (item, a_reading_ur_ls__item, a_reading_options, a_writing_ur_ls__item, a_writing_options, a_out_error__item, )
--		end

	item_at_ur_l__did_move_to_ur_l_ (a_old_url: detachable NS_URL; a_new_url: detachable NS_URL)
			-- Auto generated Objective-C wrapper.
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
			objc_item_at_ur_l__did_move_to_ur_l_ (item, a_old_url__item, a_new_url__item)
		end

	cancel
			-- Auto generated Objective-C wrapper.
		local
		do
			objc_cancel (item)
		end

feature {NONE} -- Implementation

	wrapper_objc_class_name: STRING
			-- The class name used for classes of the generated wrapper classes.
		do
			Result := "NSFileCoordinator"
		end

end