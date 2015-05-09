function getCurrentDate() {
	var today = new Date();
	var dd = today.getDate();
	var mm = today.getMonth() + 1;
	// January is 0!

	var yyyy = today.getFullYear();
	if (dd < 10) {
		dd = '0' + dd;
	}
	if (mm < 10) {
		mm = '0' + mm;
	}
	today = dd + '-' + mm + '-' + yyyy;

	return today;
}

function getCurrentDateYMD() {
	var today = new Date();
	var dd = today.getDate();
	var mm = today.getMonth() + 1;
	// January is 0!

	var yyyy = today.getFullYear();
	if (dd < 10) {
		dd = '0' + dd;
	}
	if (mm < 10) {
		mm = '0' + mm;
	}
	today = yyyy + "-" + mm + '-' + dd;

	return today;
}

function formatDateDMY(date) {
	var today = new Date(date);
	var dd = today.getDate();
	var mm = today.getMonth() + 1;
	// January is 0!

	var yyyy = today.getFullYear();
	if (dd < 10) {
		dd = '0' + dd;
	}
	if (mm < 10) {
		mm = '0' + mm;
	}
	today = dd + '-' + mm + '-' + yyyy;
	return today;
}
function formatDateYMD(date) {
	var today = new Date(date);
	var dd = today.getDate();
	var mm = today.getMonth() + 1;
	// January is 0!

	var yyyy = today.getFullYear();
	if (dd < 10) {
		dd = '0' + dd;
	}
	if (mm < 10) {
		mm = '0' + mm;
	}
	today = yyyy + '-' + mm + '-' + dd;
	return today;
}

function setLastInsertId(key, id) {
	localStorage.setItem(key, id);
};
function getLastInsertId(key) {
	var id = 1;
	var lastInventoryId = $.parseJSON(localStorage.getItem(key));
	console.log("last insert id" + id);
	if (lastInventoryId) {
		id = parseInt(lastInventoryId) + 1;
	}
	localStorage.setItem(key, id);
	return id;
};
function log(msg, obj) {
	console.log(12312321312312);
	console.log("OLBIUS: " + msg + " ", obj);
}

function formatNumberBy3(num, decpoint, sep) {
	if (num) {
		// check for missing parameters and use defaults if so
		if (arguments.length == 2) {
			sep = ",";
		}
		if (arguments.length == 1) {
			sep = ",";
			decpoint = ".";
		}
		// need a string for operations
		var num = num.toString();
		// separate the whole number and the fraction if possible
		var a = num.split(decpoint);
		var x = a[0];
		// decimal
		var y = a[1];
		// fraction
		var z = "";

		if ( typeof (x) != "undefined") {
			// reverse the digits. regexp works from left to right.
			for (var i = x.length - 1; i >= 0; i--)
				z += x.charAt(i);
			// add seperators. but undo the trailing one, if there
			z = z.replace(/(\d{3})/g, "$1" + sep);
			if (z.slice(-sep.length) == sep)
				z = z.slice(0, -sep.length);
			x = "";
			// reverse again to get back the number
			for (var i = z.length - 1; i >= 0; i--)
				x += z.charAt(i);
			// add the fraction back in, if it was there
			if ( typeof (y) != "undefined" && y.length > 0)
				x += decpoint + y;
		}
		return x;

	}
};