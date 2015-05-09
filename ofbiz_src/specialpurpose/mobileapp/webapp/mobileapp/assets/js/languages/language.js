/**
 * 
 */
function changeLanguage(pathToJSON, lang){
	//console.log(pathToJSON + " lang: " + lang);
	var retData = null;
	$.ajax({
		dataType:'json',
		async: false,
		url: pathToJSON,
		success: function(data){
			retData = data;
			for(var key in data){
				if($("." + key).length){
					$("."+ key).text(data[key][lang]);
				}else if($("#"+ key).length){
					$("#"+ key).text(data[key][lang]);
				}			
			}
		}
	});	
	return retData;
}