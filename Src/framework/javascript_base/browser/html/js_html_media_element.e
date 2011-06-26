-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLMediaElement"
class
	JS_HTML_MEDIA_ELEMENT

inherit
	JS_HTML_ELEMENT

feature -- error state

	error: JS_MEDIA_ERROR
			-- The error attribute, on getting, must return the MediaError object created
			-- for this last error, or null if there has not been an error.
		external "C" alias "error" end

feature -- network state

	src: STRING assign set_src
			-- The src IDL attribute on media elements must reflect the content attribute
			-- of the same name.
		external "C" alias "src" end

	set_src (a_src: STRING)
			-- See src
		external "C" alias "src=$a_src" end

	current_src: STRING
			-- Returns the address of the current media resource. Returns the empty string
			-- when there is no media resource.
		external "C" alias "currentSrc" end

	NETWORK_EMPTY: INTEGER
			-- The element has not yet been initialized. All attributes are in their
			-- initial states.
		external "C" alias "#0" end

	NETWORK_IDLE: INTEGER
			-- The element's resource selection algorithm is active and has selected a
			-- resource, but it is not actually using the network at this time.
		external "C" alias "#1" end

	NETWORK_LOADING: INTEGER
			-- The user agent is actively trying to download data.
		external "C" alias "#2" end

	NETWORK_NO_SOURCE: INTEGER
			-- The element's resource selection algorithm is active, but it has so not yet
			-- found a resource to use.
		external "C" alias "#3" end

	network_state: INTEGER
			-- Returns the current state of network activity for the element, from the
			-- codes in the list above.
		external "C" alias "networkState" end

	preload: STRING assign set_preload
			-- The preload IDL attribute must reflect the content attribute of the same
			-- name, limited to only known values.
		external "C" alias "preload" end

	set_preload (a_preload: STRING)
			-- See preload
		external "C" alias "preload=$a_preload" end

	buffered: JS_TIME_RANGES
			-- Returns a TimeRanges object that represents the ranges of the media resource
			-- that the user agent has buffered.
		external "C" alias "buffered" end

	load
			-- When the load() method on a media element is invoked, the user agent must
			-- run the media element load algorithm.
		external "C" alias "load()" end

	can_play_type (a_type: STRING): STRING
			-- The canPlayType(type) method must return the empty string if type is a type
			-- that the user agent knows it cannot render or is the type
			-- "application/octet-stream"; it must return "probably" if the user agent is
			-- confident that the type represents a media resource that it can render if
			-- used in with this audio or video element; and it must return "maybe"
			-- otherwise. Implementors are encouraged to return "maybe" unless the type can
			-- be confidently established as being supported or not. Generally, a user
			-- agent should never return "probably" for a type that allows the codecs
			-- parameter if that parameter is not present.
		external "C" alias "canPlayType($a_type)" end

feature -- ready state

	HAVE_NOTHING: INTEGER
			-- No information regarding the media resource is available. No data for the
			-- current playback position is available. Media elements whose networkState
			-- attribute are set to NETWORK_EMPTY are always in the HAVE_NOTHING state.
		external "C" alias "#0" end

	HAVE_METADATA: INTEGER
			-- Enough of the resource has been obtained that the duration of the resource
			-- is available. In the case of a video element, the dimensions of the video
			-- are also available. The API will no longer raise an exception when seeking.
			-- No media data is available for the immediate current playback position.
		external "C" alias "#1" end

	HAVE_CURRENT_DATA: INTEGER
			-- Data for the immediate current playback position is available, but either
			-- not enough data is available that the user agent could successfully advance
			-- the current playback position in the direction of playback at all without
			-- immediately reverting to the HAVE_METADATA state, or there is no more data
			-- to obtain in the direction of playback. For example, in video this
			-- corresponds to the user agent having data from the current frame, but not
			-- the next frame; and to when playback has ended.
		external "C" alias "#2" end

	HAVE_FUTURE_DATA: INTEGER
			-- Data for the immediate current playback position is available, as well as
			-- enough data for the user agent to advance the current playback position in
			-- the direction of playback at least a little without immediately reverting to
			-- the HAVE_METADATA state. For example, in video this corresponds to the user
			-- agent having data for at least the current frame and the next frame. The
			-- user agent cannot be in this state if playback has ended, as the current
			-- playback position can never advance in this case.
		external "C" alias "#3" end

	HAVE_ENOUGH_DATA: INTEGER
			-- All the conditions described for the HAVE_FUTURE_DATA state are met, and, in
			-- addition, the user agent estimates that data is being fetched at a rate
			-- where the current playback position, if it were to advance at the rate given
			-- by the defaultPlaybackRate attribute, would not overtake the available data
			-- before playback reaches the end of the media resource.
		external "C" alias "#4" end

	ready_state: INTEGER
			-- Returns a value that expresses the current state of the element with respect
			-- to rendering the current playback position, from the codes in the list
			-- above.
		external "C" alias "readyState" end

	seeking: BOOLEAN
			-- The seeking attribute must initially have the value false.
		external "C" alias "seeking" end

feature -- playback state

	current_time: REAL assign set_current_time
			-- Returns the current playback position, in seconds. Can be set, to seek to
			-- the given time. Will throw an INVALID_STATE_ERR exception if there is no
			-- selected media resource. Will throw an INDEX_SIZE_ERR exception if the given
			-- time is not within the ranges to which the user agent can seek.
		external "C" alias "currentTime" end

	set_current_time (a_current_time: REAL)
			-- See current_time
		external "C" alias "currentTime=$a_current_time" end

	initial_time: REAL
			-- Returns the initial playback position, that is, time to which the media
			-- resource was automatically seeked when it was loaded. Returns zero if the
			-- initial playback position is still unknown.
		external "C" alias "initialTime" end

	duration: REAL
			-- Returns the length of the media resource, in seconds, assuming that the
			-- start of the media resource is at time zero. Returns NaN if the duration
			-- isn't available. Returns Infinity for unbounded streams.
		external "C" alias "duration" end

	start_offset_time: JS_DATE
			-- The startOffsetTime attribute must return a new Date object representing the
			-- current timeline offset.
		external "C" alias "startOffsetTime" end

	paused: BOOLEAN
			-- Returns true if playback is paused; false otherwise.
		external "C" alias "paused" end

	default_playback_rate: REAL assign set_default_playback_rate
			-- Returns the default rate of playback, for when the user is not
			-- fast-forwarding or reversing through the media resource. Can be set, to
			-- change the default rate of playback. The default rate has no direct effect
			-- on playback, but if the user switches to a fast-forward mode, when they
			-- return to the normal playback mode, it is expected that the rate of playback
			-- will be returned to the default rate of playback.
		external "C" alias "defaultPlaybackRate" end

	set_default_playback_rate (a_default_playback_rate: REAL)
			-- See default_playback_rate
		external "C" alias "defaultPlaybackRate=$a_default_playback_rate" end

	playback_rate: REAL assign set_playback_rate
			-- Returns the current rate playback, where 1.0 is normal speed. Can be set, to
			-- change the rate of playback.
		external "C" alias "playbackRate" end

	set_playback_rate (a_playback_rate: REAL)
			-- See playback_rate
		external "C" alias "playbackRate=$a_playback_rate" end

	played: JS_TIME_RANGES
			-- Returns a TimeRanges object that represents the ranges of the media resource
			-- that the user agent has played.
		external "C" alias "played" end

	seekable: JS_TIME_RANGES
			-- The seekable attribute must return a new static normalized TimeRanges object
			-- that represents the ranges of the media resource, if any, that the user
			-- agent is able to seek to, at the time the attribute is evaluated.
		external "C" alias "seekable" end

	ended: BOOLEAN
			-- Returns true if playback has reached the end of the media resource.
		external "C" alias "ended" end

	autoplay: BOOLEAN assign set_autoplay
			-- The autoplay IDL attribute must reflect the content attribute of the same
			-- name.
		external "C" alias "autoplay" end

	set_autoplay (a_autoplay: BOOLEAN)
			-- See autoplay
		external "C" alias "autoplay=$a_autoplay" end

	js_loop: BOOLEAN assign set_js_loop
			-- The loop attribute is a boolean attribute that, if specified, indicates that
			-- the media element is to seek back to the start of the media resource upon
			-- reaching the end.
		external "C" alias "loop" end

	set_js_loop (a_js_loop: BOOLEAN)
			-- See js_loop
		external "C" alias "loop=$a_js_loop" end

	play
			-- Sets the paused attribute to false, loading the media resource and beginning
			-- playback if necessary. If the playback had ended, will restart it from the
			-- start.
		external "C" alias "play()" end

	pause
			-- Sets the paused attribute to true, loading the media resource if necessary.
		external "C" alias "pause()" end

feature -- controls

	controls: BOOLEAN assign set_controls
			-- The controls IDL attribute must reflect the content attribute of the same
			-- name.
		external "C" alias "controls" end

	set_controls (a_controls: BOOLEAN)
			-- See controls
		external "C" alias "controls=$a_controls" end

	volume: REAL assign set_volume
			-- Returns the current playback volume, as a number in the range 0.0 to 1.0,
			-- where 0.0 is the quietest and 1.0 the loudest. Can be set, to change the
			-- volume. Throws an INDEX_SIZE_ERR if the new value is not in the range 0.0 ..
			-- 1.0.
		external "C" alias "volume" end

	set_volume (a_volume: REAL)
			-- See volume
		external "C" alias "volume=$a_volume" end

	muted: BOOLEAN assign set_muted
			-- Returns true if audio is muted, overriding the volume attribute, and false
			-- if the volume attribute is being honored. Can be set, to change whether the
			-- audio is muted or not.
		external "C" alias "muted" end

	set_muted (a_muted: BOOLEAN)
			-- See muted
		external "C" alias "muted=$a_muted" end
end
