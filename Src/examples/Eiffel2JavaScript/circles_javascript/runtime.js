// -------------------------------------------------------
//	description : "JavaScript runtime for generated code"
//	author      : "Alexandru Dima <alex.dima@gmail.com>"
//	copyright   : "Copyright (C) 2011, Alexandru Dima"
// -------------------------------------------------------

if (typeof Object.create !== 'function') {
    Object.create = function (o) {
        function F() {}
        F.prototype = o;
        return new F();
    };
}

// This algorithm is exactly the one specified in ECMA-262, 5th edition
if (!Array.prototype.indexOf) {
	Array.prototype.indexOf = function(searchElement /*, fromIndex */) {
		"use strict";
		if (this === void 0 || this === null) {
			throw new TypeError();
		}

		var t = Object(this);
		var len = t.length >>> 0;
		if (len === 0) {
			return -1;
		}

		var n = 0;
		if (arguments.length > 0) {
			n = Number(arguments[1]);
			if (n !== n) { // shortcut for verifying if it's NaN
				n = 0;
			} else if (n !== 0 && n !== (1 / 0) && n !== -(1 / 0)) {
				n = (n > 0 || -1) * Math.floor(Math.abs(n));
			}
		}

		if (n >= len) {
			return -1;
		}

		var k = n >= 0 ? n : Math.max(len - Math.abs(n), 0);

		for (; k < len; k++) {
			if (k in t && t[k] === searchElement) {
				return k;
			}
		}
		return -1;
	};
}

// This algorithm is exactly the one specified in ECMA-262, 5th edition
if (!Array.prototype.eiffelForEach) {
	Array.prototype.eiffelForEach = function(fun /*, thisp */) {
		"use strict";

		if (this === void 0 || this === null) {
			throw new TypeError();
		}

		var t = Object(this);
		var len = t.length >>> 0;
		if (typeof fun !== "function") {
			throw new TypeError();
		}

		var thisp = arguments[1];
		for (var i = 1; i < len; i++) {
			if (i in t) {
				fun.call(thisp, t[i], i + t[0] - 1, t);
			}
		}
	};
}

// This algorithm is exactly the one specified in ECMA-262, 5th edition
if (!Array.prototype.eiffelSome) {
	Array.prototype.eiffelSome = function(fun /*, thisp */) {
		"use strict";

		if (this === void 0 || this === null) {
			throw new TypeError();
		}

		var t = Object(this);
		var len = t.length >>> 0;
		if (typeof fun !== "function") {
			throw new TypeError();
		}

		var thisp = arguments[1];
		for (var i = 1; i < len; i++) {
			if (i in t && fun.call(thisp, t[i], i + t[0] - 1, t)) {
				return true;
			}
		}

		return false;
	};
}

if (typeof console === "undefined") {
	var console = {
		info : function (an_obj) {
			// Do nothing
		}
	}
}

if (typeof eiffel_arguments === "undefined") {
	var eiffel_arguments = [];
}

var runtime = {
	_class_repository : [],
	_inherits_map: {},
	
	require1 : function (class_name) {
		if (this._class_repository[class_name] === undefined) {
			console.error('Missing ' + class_name);
		}
	},
	
	require2 : function (class_name) {
		// Whatever, we don't care :)
	},
	
	_remove_ending_regexp : /^(.*)_\d+$/,
	
	_array_2_map : function (arr) {
		var result = {}, i;
		for (i = 0; i < arr.length; i = i + 1) {
			result[arr[i]] = true;
		}
		return result;
	},
	
	_find_feature_starting_with : function (class_decl, looking_feature_name, onlyOwnProperty) {
		var feature, regex_matches, feature_name;
		for (feature in class_decl) {
			if (!onlyOwnProperty || class_decl.hasOwnProperty(feature)) {
				regex_matches = this._remove_ending_regexp.exec(feature);
				if (regex_matches && regex_matches.length === 2) {
					feature_name = regex_matches[1];
				} else {
					feature_name = feature;
				}
				
				if (feature_name === looking_feature_name) {
					return feature;
				}
			}
		}
		return null;
	},
	
	getProperties : function (obj, onlyOwnProperties) {
		var Result = [], i;
		for (i in obj) {
			if (onlyOwnProperties && !obj.hasOwnProperty(i)) {
				continue;
			}
			Result.push(i);
		}
		return Result;
	},
	
	__createProxy : function (feature_name) {
		return function() {
			return this[feature_name].apply (this, arguments);
		};
	},
	
	exportAPI : function(obj) {
		var regex_matches, feature, feature_name;
		for (feature in obj) {
			if (feature.charAt(0) !== '$') {
				regex_matches = this._remove_ending_regexp.exec(feature);
				if (regex_matches && regex_matches.length === 2) {
					feature_name = regex_matches[1];
					if (!(feature_name in obj)) {
						obj[feature_name] = obj[feature];
					}
				}
			}
		}
		return obj;
	},
	
	declare : function (class_name, parent_classes, class_decl) {
		var parent_decl, class_prototype, redefining_map, renaming_map, parent_deferred_map, 
			regex_matches, feature, found_feature, feature_name, i, j, inherits_map, parent_inherits_map,
			own_invariant;
		
		// Start off with an empty object
		class_prototype = {};
		
		// Add the properties from class_decl
		for (feature in class_decl) {
			if (class_decl.hasOwnProperty(feature)) {
				class_prototype[feature] = class_decl[feature];
				if (typeof class_decl[feature] === "function" && feature.charAt(0) != '$' && ! ("$"+feature in class_decl)) {
					class_prototype["$"+feature] = class_decl[feature];
				}
			}
		}
		own_invariant = this._find_feature_starting_with(class_decl, '$invariant', true);
		class_prototype['$invariant'] = class_prototype[own_invariant];
		
		inherits_map = {};
		inherits_map['EIFFEL_ANY'] = true;
		
		// Inherit properties from parents
		for (i=0; i<parent_classes.length; i++) {
			// Fetch the parent declaration from the repository
			parent_decl = this._class_repository[parent_classes[i].class_name];
			
			if (!parent_decl) {
				throw "Class " + class_name + " wants to inherit from " + parent_classes[i].class_name + ", but " + parent_classes[i].class_name + " doesn't seem to be declared !";
			}
			
			parent_inherits_map = this._inherits_map[parent_classes[i].class_name];
			for (inherits_from in parent_inherits_map) {
				if (parent_inherits_map.hasOwnProperty(inherits_from)) {
					inherits_map[inherits_from] = true;
				}
			}
			inherits_map[parent_classes[i].class_name] = true;
			
			// Build a map out of the list with features being redefined
			parent_classes[i].redefining = parent_classes[i].redefining || [];
			redefining_map = this._array_2_map(parent_classes[i].redefining);

			// Reference the map of features being renamed
			renaming_map = parent_classes[i].renaming || {};
			
			// Build a map out of the features from the parent being deferred
			parent_deferred_map = this._array_2_map(parent_decl.$deferred || []);
			
			// Copy parent's properties
			for (feature in parent_decl) {
				if (parent_decl.hasOwnProperty(feature) && feature !== '$deferred' && feature !== '$invariant' && feature !== '$class_name') {
					// Remove the feature id at the end to get the feature name
					regex_matches= this._remove_ending_regexp.exec(feature);
					if (regex_matches && regex_matches.length == 2) {
						feature_name = regex_matches[1];
					} else {
						feature_name = feature;
					}
					
					if (feature in class_prototype) {
						if (class_prototype[feature] !== parent_decl[feature]) {
							console.info ("Just so you know: Class " + class_name + " has a name clash for feature " + feature + " - it comes a second time from " + parent_classes[i].class_name);
						}
						continue;
					}
					
					if (redefining_map.hasOwnProperty(feature_name)) {
						// This feature needs to be redefined in order to point to the new implementation
						if (renaming_map.hasOwnProperty(feature_name)) {
							feature_name = renaming_map[feature_name];
						}
						found_feature = this._find_feature_starting_with(class_prototype, feature_name, true);
						if (!found_feature) {
							throw "Class " + class_name + " wants to redefine " + parent_classes[i].class_name + "." + feature_name + ", but doesn't actually do so !";
						}
						class_prototype[feature] = this.__createProxy (found_feature);
					} else {
						if (parent_deferred_map.hasOwnProperty(feature_name)) {
							// Try to see if class_prototype actually implements this deferred feature
							if (renaming_map.hasOwnProperty(feature_name)) {
								feature_name = renaming_map[feature_name];
							}
							found_feature = this._find_feature_starting_with(class_prototype, feature_name, true);
							if (found_feature) {
								class_prototype[feature] = this.__createProxy (found_feature);
							} else {
								class_prototype[feature] = parent_decl[feature];
							}
						} else {
							class_prototype[feature] = parent_decl[feature];
						}
					}
				}
			}
		}
		
		class_prototype.$class_name = class_name;
		this._class_repository[class_name] = class_prototype;
		this._inherits_map[class_name] = inherits_map;
		
		var $runtime = this;
		return function () {
			var result = Object.create (class_prototype), feature_name, args = Array.prototype.slice.apply(arguments, [0]);
			
			result.$generics = [];
			if (args.length > 0) {
				if (args[0] instanceof Array) {
					// First arguments is an array with the actual types of the generics
					result.$generics = args[0];
					args = args.slice(1);
				}
				if (args.length > 0) {
					// First argument is a method name to be called as a constructor
					feature_name = args[0];
					if (!(feature_name in class_prototype)) {
						feature_name = $runtime._find_feature_starting_with (result, feature_name, false);
					}
					class_prototype[feature_name].apply(result, args.slice(1));
				}
			}
			
			return result;
		};
	},
	
	_type_inherits: function(type1, type2) {
		var i;
		if (type1.attached === false && type2.attached === true) {
			return false;
		}
		if (type2.name === "EIFFEL_ANY") {
			return true;
		}
		if (type1.name === type2.name || (type1.name in this._inherits_map && type2.name in this._inherits_map[type1.name])) {
			if (type1.generics.length !== type2.generics.length) {
				return false;
			}
			for (i = 0; i < type1.generics.length; i ++) {
				if ( !this._type_inherits(type1.generics[i], type2.generics[i])) {
					return false;
				}
			}
			return true;
		}
		return false;
	},
	
	inherits: function (obj, type) {
		var i;

		if (obj === null) {
			return false;
		}
		
		if (typeof type === "string") {
			type = {
				name : type
			};
		}
		
		if (typeof type.attached === 'undefined') {
			type.attached = false;
		}
		type.generics = type.generics || [];
		
		if (type.name === "EIFFEL_ANY") {
			return true;
		}
		
		if (type.name === "EIFFEL_STRING") {
			return typeof obj === "string";
		}
		
		if (type.name === "EIFFEL_INTEGER" || type.name === "EIFFEL_REAL") {
			return typeof obj === "number";
		}
		
		if (type.name === "EIFFEL_BOOLEAN") {
			return typeof obj === "boolean";
		}
		
		if (obj.$class_name === type.name || (obj.$class_name in this._inherits_map && type.name in this._inherits_map[obj.$class_name])) {
			if (obj.$generics.length !== type.generics.length) {
				return false;
			}
			for (i = 0; i < obj.$generics.length; i ++) {
				if ( !this._type_inherits(obj.$generics[i], type.generics[i])) {
					return false;
				}
			}
			return true;
		}
		
		//if (!(obj.$class_name in this._inherits_map)) {
		//	console.info ("Object from outside the system: " + obj.$class_name);
		//	console.info (obj.$class_name);
		//}
		
		//if (!(type.name in this._inherits_map)) {
		//	console.info ("Type from outside the system: " + type.name);
		//	console.info (type);
		//}
		
		return false;
	},
	
	// Base types helper methods
	make_array_filled: function (element, eiffel_start_index, eiffel_end_index) {
		var result = [], i;
		result[0] = eiffel_start_index;
		for (i=1; i<=eiffel_end_index-eiffel_start_index+1; i++) {
			result[i] = element;
		}
		return result;
	}
}
