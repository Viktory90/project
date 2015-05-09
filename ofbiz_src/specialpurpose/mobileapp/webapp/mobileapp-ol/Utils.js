CommonUtils = {
	random : function(min, max) {
		return (Math.floor(Math.random() * (max - min + 1)) + min);
	},
	randomExceptList : function(a, min, max){
		var rand = Math.floor(Math.random() * (max - min + 1)) + min;
		while(this.contains(a, rand)){
			rand = Math.floor(Math.random() * (max - min + 1)) + min;
		}
		return rand;
	},
	clearAll : function(timeout, interval) {
		this.clearAllInterval(interval);
		this.clearAllTimeout(timeout);
	},
	clearAllInterval : function(interval) {
		for (var x in interval) {
			clearInterval(interval[x]);
		}
	},
	clearAllTimeout : function(timeout) {
		for (var x in timeout) {
			clearTimeout(timeout[x]);
		}
	},
	pauseAll : function(audio) {
		for (var x in audio) {
			if (audio[x] != null) {
				audio[x].pause();
				delete audio[x];
			}
		}
	},
	contains : function(a, obj) {
		for (var i = 0; i < a.length; i++) {
			if (a[i] === obj) {
				return true;
			}
		}
		return false;
	},
	getCurrentTime : function() {
		var d = new Date();
		return d.getTime();
	},
	shuffle : function(o) {//v1.0
		for (var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
		return o;
	},
	checkIntegerFinishWith : function(num, postNum) {
		if (num - postNum == 0 || (num - postNum) % 10 == 0) {
			return true;
		}
		return false;
	},
	generateSuggestion : function(key, obj, a) {
		var str = "<div class='berry'></div>";
		var length = 2 < a ? 2 : a;
		for (var i = 0; i < length; i++) {
			str += "<div class='berry " + key + "'><img src='.\/images\/berry.png'/></div>";
		}
		if (length == 2) {
			str += "<div class='berry'></div>";
			for (var x = length; x < a; x++) {
				str += "<div class='berry " + key + "'><img src='.\/images\/berry.png'/></div>";
			}
		}
		obj.html(str);
	},
	isNumeric : function(input) {
		var RE = /^-{0,1}\d*\.{0,1}\d+$/;
		return (RE.test(input));
	},
	compareArray : function(a, b){
		var length1 = a.length;
		var length2 = b.length;
		var count = 0;
		if(length1 != length2) return false;
		for(var x = 0; x< length1; x++){
			if(a[x] == b[x])
				count++;
		}		
		if(count == length1) return true;
	}
};