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
			log(res.data);
			return res.data;
		});
	};
	return sync;
});
//transform object data to request
function transformRequest(obj, callback) {
	if (callback) {
		callback();
	}
	var str = [];
	for (var p in obj)
	str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
	return str.join("&");
};
function checkLogin(obj, $location) {
	if (obj.login === "FALSE") {
		localStorage.setItem("login", "false");
		$location.path('login');
	} else {
		localStorage.setItem("login", "true");
	}
};
olbius.service("aSynchronizeService",function($http,$location,$q,SqlService){
	var rs = {};
	var defer = $q.defer();
		rs.loadSync = function(datas){
			var dataRequest = [];
			var products = [""];
			var i = 0;
			var info = {
				totalOrder : 0,
				totalSuccess : 0,
				error : false
			};
			angular.forEach(datas,function(data){
				info.totalOrder++;
				for(var product in data.products){
					if (product != 0) {
						products[i] += "||";
					}
					products[i] += data.products[product].productId + "%%" + data.products[product].quantity;
				};
				if(data.customerId){
					dataRequest.push(
						$http({
						url : baseUrl + "submitOrder",
						method : "POST",
						transformRequest : function(obj) {
							return transformRequest(obj);
						},
						async : true,
						data : {
							customerId : data.customerId,
							products : products[i]
						},
						dataType : "json",
						headers : {
							'Content-Type' : 'application/x-www-form-urlencoded'
						}
//						timeout : setTimeout(function(){
//							console.log('Server not response');
//						}, 10000)
					}).then(function(res){
						console.log('loading request to server ' + JSON.stringify(res));
						info.totalSuccess++;
					})
					);
				}
				i++;
			});
			return $q.all(dataRequest).then(function(results){
				defer.resolve(console.log('results load async Ajax : '+JSON.stringify(results)));
				i = 0;
				return info;
			},function(errs){
				info.error = true;
				return info;
			});	
		};
		//sync customer
		rs.loadSyncCustomer = function(dataCust){
			var infoSucess = {
				info : [{}],
				total : 0,
				totalSucess : 0
			};
			var total = 0;
			var numberError = 0;
			var promiseCust = [];
			angular.forEach(dataCust,function(cust){
				infoSucess.total++;
				total++;
				promiseCust.push(
							$http({
								url : baseUrl + "createCustomerSalesMan",
								method : "POST",
								transformRequest : function(obj) {
									return transformRequest(obj);
								},
								async : true,
								data : cust,
								dataType : "json",
								headers : {
									'Content-Type' : 'application/x-www-form-urlencoded'
								}
							}).then(function(res) {
								infoSucess.info.push(res.config.data);
								infoSucess.totalSucess++;
								console.log('data customer load success' + JSON.stringify(res.config.data.customerId));
								var id = res.config.data.customerId;
								var where = 'customerId =' + id; 
								// SqlService.deleteRow('customer',where);
								checkLogin(res.data, $location);
							})
						);
				});
				return $q.all(promiseCust).then(function(rs){
					defer.resolve(JSON.stringify(rs));
					return infoSucess;
				},function(err){
					console.log('errrr' + JSON.stringify(err.config.data));
					// for(var key in err.config.data){
						// numberError++;
					// }
					// var tmp = {
						// success : total - numberError,
						// error : numberError,
						// infoError : err.config.data
					// };
					// numberError = 0 ;
					// total = 0 ;
					return  err.config.data;
				});
		};
		//service check inventory
		rs.loadSyncInventory = function(data){
			var promiseInventory = [];
			var info = {
				totalInventory : 0,
				success : 0,
				error : 0,
				infoInventory : {}
			};
			console.log('ivv into' + JSON.stringify(data));
			angular.forEach(data,function(dt){
				info.totalInventory++;
				promiseInventory.push(
					$http({
						url : baseUrl + 'updateInventoryCus',
						transformRequest : function(obj) {
							return transformRequest(obj);
						},
						dataType : "json",
						method : "POST",
						data : {
							inventory : JSON.stringify(dt.inventory),
							party_id : dt.party_id
						},
						headers : {
							'Content-Type' : 'application/x-www-form-urlencoded'
						}
					}).then(function(res) {
						info.success++;
						console.log('ivv success' + JSON.stringify(res));
						var where = 'ivid = '+res.config.data.ivid;
						// SqlService.deleteRow('inventories',where);
						checkLogin(res.data, $location);
						return res.data;
					})
				);
			});
			return $q.all(promiseInventory).then(function(data){
					console.log('ivv all' + JSON.stringify(info));
					defer.resolve(data);
					return info;
				},function(err){
					defer.reject(err);
					info.error = info.totalInventory - info.totalInventorySuccess;
					return info;
				});
				
			};
		rs.loadSyncCommon = function(data,subUrl){
				var promise = [];
				var info = {
					total  : 0,
					totalSuccess : 0
				};
				angular.forEach(data,function(d){
					console.log('dd' + JSON.stringify(d));
					info.total++;
					promise.push(
						$http({
							url : baseUrl + subUrl,
							method : "POST",
							dataType : "json",
							transformRequest : function(obj) {
								return transformRequest(obj);
							},
							data : d,
							headers : {
								'Content-Type' : 'application/x-www-form-urlencoded'							
							}
						}).then(function(success){
							info.totalSuccess++;
							console.log('Synchronize Success');
						},function(err){
							console.log('synchronize error');
						})
					);
				});
				return $q.all(promise).then(function(success){
					return info;
				},function(error){
					console.log('synchronize error');
					return info;//
				});
				
			};
	return rs;
});
olbius.service("SqlService", function($http, $location, $cordovaSQLite) {
	this.db = 
	$cordovaSQLite.openDB({
		name : "olbius.delys",
		bgType : 1
	}); 

	this.query = function(query) {
		return $cordovaSQLite.execute(this.db, query, []).then(function(data) {
			var res = Array();
			for (var i = 0; i < data.rows.length; i++) {
				var result = data.rows.item(i);
				res.push(result);
			}
			//console.log("select data: " + res);
			return res;
		});
	};
	this.getTable = function(name) {
		return $http.get('data/' + name + '.json').then(function(res) {
			console.log("table fields " + name + JSON.stringify(res.data));
			return res.data;
		}, function(res) {
			console.log("cannot get table fields " + name + JSON.stringify(res));
		});
	};

	this.dropTable = function(name) {
		var query = 'DROP TABLE IF EXISTS ' + name;
		log("DROP table" + name, query);
		$cordovaSQLite.execute(this.db, query).then(function(res) {
			log("create table " + name, res);
		}, function(err) {
			log("create table " + name, err);
		});
	};
	this.createTable = function(name, fields) {
		// for opening a background db:
		var query = "CREATE TABLE IF NOT EXISTS " + name + " (";
		var end = fields.length - 1;
		for (var x in fields) {
			query += fields[x].name + " " + fields[x].type;
			if (fields[x].primary) {
				query += " primary key";
			}
			if (x != end) {
				query += ",";
			}
		}
		query += ")";
		console.log(query);
		return $cordovaSQLite.execute(this.db, query, []);
	};
	this.createTableOrder = function(name, fields) {
		// for opening a background db:
		var query = "CREATE TABLE IF NOT EXISTS " + name + " (";
		var end = fields.length - 1;
		for (var x in fields) {
			query += fields[x].name + " " + fields[x].type;
			if (fields[x].primary) {
				query += " primary key";
			}
			if(fields[x].autoincrement){
				query +=" autoincrement";
			}
			if (x != end) {
				query += ",";
			}
		}
		query += ")";
		console.log(query);
		return $cordovaSQLite.execute(this.db, query, []);
	};
	this.insert = function(table, fields, data) {
		console.log('data'+JSON.stringify(data));
		var fieldsCl = "";
		var values = "";
		var ef = fields.length - 1;
		for (var k in fields) {
			fieldsCl += fields[k];
			if (k != ef) {
				fieldsCl += ",";
			}
		}
		log("fields output: " + fieldsCl);
		var sql = "INSERT INTO " + table + "(" + fieldsCl + ") VALUES ";
		var end = data.length;
		if (data.length && end) {
			i = 1;
			console.log('sql'+JSON.stringify(data));
			for (var x in data) {
				values = " (";
				var cur = data[x];
				for (var y = 0; y <= ef; y++) {
					if (cur[y]) {
						values += "'" + cur[y] + "'";
					} else {
						values += "NULL";
					}

					if (ef != y) {
						values += ",";
					}
				}
				values += ") ";
				if (i != end) {
					values += ",";
				}
				i++;
				sql += values;
			}
			console.log('sql'+sql);
			return $cordovaSQLite.execute(this.db, sql, []);
		}
	};
	this.select = function(table, join, where, fields, order, groupby, having) {
		var query = " SELECT ";
		var from = " FROM ";
		var fieldsCl = " ";
		var whereCl = " WHERE ";
		var orderCl = " ";
		var groupbyCl = " ";
		var havingCl = " ";
		var joinCl = " ";
		if (!fields) {
			fieldsCl += table + ".*";
		} else {
			fieldsCl = fields;
		}
		if (join) {
			joinCl += join.type + " " + join.table + " ON " + join.condition;
		}
		if (where) {
			whereCl += where;
		} else {
			whereCl += "1=1";
		}
		if (order) {
			orderCl = " ORDER BY " + order;
		} else {
			orderCl = " ";
		}
		if (groupby) {
			groupbyCl = " GROUP BY " + groupby;
		} else {
			groupbyCl = " ";
		}
		if (having) {
			havingCl = " HAVING " + having;
		} else {
			havingCl = " ";
		}
		query += fieldsCl + " " + from + " " + table + " " + joinCl + " " + whereCl + " " + groupbyCl + " " + orderCl + " " + havingCl;
		return $cordovaSQLite.execute(this.db, query, []).then(function(data) {
			var res = Array();
			for (var i = 0; i < data.rows.length; i++) {
				var result = data.rows.item(i);
				res.push(result);
			}
			//console.log("select data: " + res);
			return res;
		});
	};
	this.deleteRow = function(table, where) {
		var sql = "DELETE FROM " + table;
		if (where) {
			sql += " WHERE " + where;
		}
		log("Delete command: " + sql);
		return $cordovaSQLite.execute(this.db, sql, []).then(function(res) {
			log("execute delete " + table, res);
		}, function(err) {
			log("execute delete " + table, err);
		});
	};
	this.deleteAll = function(table) {
		var sql = "DELETE FROM " + table;
		return $cordovaSQLite.execute(this.db, sql, []).then(function(res) {
			log("delete all row in table:" + table, res);
		}, function(err) {
			log("delete all row in table:" + table, err);
		});
	};
	this.closeDB = function() {
		this.db.close();
	};
});
