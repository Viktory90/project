/*
 * Globalize Culture vi-VN
 *
 * http://github.com/jquery/globalize
 *
 * Copyright Software Freedom Conservancy, Inc.
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * This file was generated by the Globalize Culture Generator
 * Translation: bugs found in this file need to be fixed in the generator
 */

(function( window, undefined ) {

var Globalize;

if ( typeof require !== "undefined" &&
	typeof exports !== "undefined" &&
	typeof module !== "undefined" ) {
	// Assume CommonJS
	Globalize = require( "globalize" );
} else {
	// Global variable
	Globalize = window.Globalize;
}

Globalize.addCultureInfo( "vi-VN", "default", {
	name: "vi-VN",
	englishName: "Vietnamese (Vietnam)",
	nativeName: "Tiếng Việt (Việt Nam)",
	language: "vi",
	numberFormat: {
		",": ".",
		".": ",",
		percent: {
			",": ".",
			".": ","
		},
		currency: {
			pattern: ["-n $","n $"],
			",": ".",
			".": ",",
			symbol: "₫"
		}
	},
	calendars: {
		standard: {
			firstDay: 1,
			days: {
				names: ["CN","T2","T3","T4","T5","T6","T7"],
				namesAbbr: ["CN","Hai","Ba","Tư","Năm","Sáu","Bảy"],
				namesShort: ["C","H","B","T","N","S","B"]
			},
			months: {
				names: ["Tháng Giêng","Tháng Hai","Tháng Ba","Tháng Tư","Tháng Năm","Tháng Sáu","Tháng Bảy","Tháng Tám","Tháng Chín","Tháng Mười","Tháng Mười Một","Tháng Mười Hai",""],
				namesAbbr: ["Thg1","Thg2","Thg3","Thg4","Thg5","Thg6","Thg7","Thg8","Thg9","Thg10","Thg11","Thg12",""],
				namesShort: ["T1","T2","T3","T4","T5","T6","T7","T8","T9","T10","T11","T12"]
			},
			AM: ["SA","sa","SA"],
			PM: ["CH","ch","CH"],
			patterns: {
				d: "dd/MM/yyyy",
				D: "dd MMMM yyyy",
				f: "dd MMMM yyyy h:mm tt",
				F: "dd MMMM yyyy h:mm:ss tt",
				M: "dd MMMM",
				Y: "MMMM yyyy"
			}
		}
	}
});

}( this ));