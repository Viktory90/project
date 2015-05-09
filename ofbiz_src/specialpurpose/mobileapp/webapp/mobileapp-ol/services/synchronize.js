/*list of service synchronize*/
/*
 * 
 * 
 * CREATE TABLE 
    checklist (
        _id INTEGER PRIMARY KEY AUTOINCREMENT, 
        checklist_title TEXT,
        description TEXT,
        created_on INTEGER, 
        modified_on INTEGER
    );

CREATE TABLE 
    item (
        _id INTEGER PRIMARY KEY AUTOINCREMENT,  
        checklist_id INTEGER,
        item_text TEXT, 
        item_hint TEXT, 
        item_order INTEGER, 
        created_on INTEGER, 
        modified_on INTEGER,
        FOREIGN KEY(checklist_id) REFERENCES checklist(_id)
    );
*/

olbius.factory('SynchronizeService', function($http, $location) {
	var sync = {};
	/* get all promotions today from server */
	sync.getPromotions = function() {
		return $http({
			url : baseUrl + 'getPromotions',
			dataType : "json",
			method : "POST",
			headers : {
				'Content-Type' : 'application/x-www-form-urlencoded'
			}
		}).then(function(res) {
			console.log(res.data);
			return res.data;
		});
	};
	return sync;
});
olbius.factory("SqlService", function($http, $location){
	var sync = {};
	sync.getPromotionTable = function(){
		return $http.get('data/promotions.json').then(function(res) {
			return res.data;
		});
	};
	sync.createTable = function(name, fields){
		  // for opening a background db:
	    var query =  "CREATE TABLE IF NOT EXISTS "+ name + " (";
	    var end = fields.length - 1;
	    for(var x in fields){
	    	query += fields[x].name + " " + fields[x].type;
	    	if(fields[x].primary){
	    		query += " primary key";
	    	}
	    	if(x != end){
	    		query += ",";
	    	}
	    }
	    query += ")";
	    console.log(query);return;
	    $cordovaSQLite.execute(db, query).then(function(res) {
	      console.log("create table "+ name, res);
	      db.close();
	    }, function (err) {
	      console.error("create table "+ name, err);
	      db.close();
	    });
	};
	sync.insert = function(table, fields, data){
		var fields = "";
		var values = "";
		var ef = fields.length - 1;
		for(var k in fields){
			fields += fields[k];
			if(k != ef){
				fields += ",";
			}
		}
		var sql = "INSERT INTO " + table + "(" + fields + ") VALUES ";
		var end = data.length;
		if(data && end){
			var j = 0;
			for(var x in data){
				i = 0;
				j++;
				values = " (";
				var cur = data[x];
				for(var y = 0; y <= ef; y++){
					fields += "'" + x +  "'";
					values +=  "'" + cur[fields[y]] + "'";
					if(ef != y){
						values += ",";
					}
				}
				values += ") ";
				if(i != end){
					values += ",";
				}
				sql += values;
			}
		}
		$cordovaSQLite.execute(db, sql, []).then(function(res) {
			console.log("execute insert in to"+ table, res);
	    }, function (err) {
	      console.error("execute insert in to"+ table, err);
	    });
	};
	sync.select = function(table, join, where, fields, order, groupby, having){
		var query = "SELECT ";
		var from = "FROM ";
		var whereCl = "WHERE ";
		var orderCl = "ORDER BY ";
		var groupbyCl = "GROUP BY ";
		var havingCl = "HAVING ";
		var joinCl = "";
		if(!fields){
			from += table + ".*" ;
		}else{
			for(var x in fields){
				from += table + "." + fields[x];
			}
		}
		if(join){
			joinCl += join.type + " "+ join.table + " ON " + join.condition;
		}
		if(where){
			whereCl += where;
		}else {
			whereCl = "";
		}
		if(order){
			orderCl += order;
		}else{
			orderCl = "";
		}
		if(groupby){
			groupbyCl += groupby;
		}else{
			groupbyCl = "";
		}
		if(having){
			havingCl += having;
		}else{
			havingCl = "";
		}
		query += from + " " + fields + " " + joinCl + " " + whereCl + " " + groupbyCl + " " + orderCl + " " + havingCl;
		$cordovaSQLite.execute(db, sql, []).then(function(res) {
			console.log("execute insert in to"+ table, res);
		    }, function (err) {
		      console.error("execute insert in to"+ table, err);
		    });	
	};
	sync.deleteRow = function(table, where){
		var sql = "DELETE FROM " + table + " WHERE " + where;
		$cordovaSQLite.execute(db, sql, []).then(function(res) {
			console.log("execute insert in to"+ table, res);
		    }, function (err) {
		      console.error("execute insert in to"+ table, err);
		    });	
	};
	sync.deleteAll = function(table){
		var sql = "DELETE FROM " + table;
		$cordovaSQLite.execute(db, sql, []).then(function(res) {
			console.log("delete all row in table:"+ table, res);
	    }, function (err) {
	      console.error("delete all row in table:"+ table, err);
	    });
	};
	sync.closeDB = function(db){
		db.close();
	};
	return sync;
});