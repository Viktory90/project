
<form id="" action="<@ofbizUrl>ListHolidayInYear</@ofbizUrl>" class="basic-form form-horizontal">
	<div class="row-fluid">
		<div class="control-group no-left-margin">
			<label class="">
				<label>${uiLabelMap.HolidayYear}</label>
				  
			</label>
			<div class="controls">
				<select name="year" onchange="this.form.submit()" style="width: 100px">
					<option value="2015" <#if year == '2015'>selected="selected"</#if>>2015</option>
					<option value="2014" <#if year == '2014'>selected="selected"</#if>>2014</option>
					<option value="2013" <#if year == '2013'>selected="selected"</#if>>2013</option>
					<option value="2012" <#if year == '2012'>selected="selected"</#if>>2012</option>
					<option value="2011" <#if year == '2011'>selected="selected"</#if>>2011</option>
				</select>
			</div>
		</div>
	</div>
</form>