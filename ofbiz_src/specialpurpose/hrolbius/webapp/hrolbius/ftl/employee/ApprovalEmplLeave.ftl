<div class="row-fluid">
	<#if viewEmplLeavePerm>
		<div class="row-fluid">
			<div class="span12 mgt20 boder-all-profile">
				<span class="text-header">${uiLabelMap.ApplicationLeave} ${uiLabelMap.CommonOf} ${employee.lastName?if_exists} ${employee.middleName?if_exists} ${employee.firstName?if_exists}</span>
				<div class="form-horizontal">
					<div class="span6">
						<div class="control-group no-left-margin">
							<label class="control-label">
								${uiLabelMap.EmployeeName}
							</label>
							<div class="controls">
								${employee.lastName?if_exists} ${employee.middleName?if_exists} ${employee.firstName?if_exists} [${parameters.partyIdLeave?if_exists}]
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label">
								${uiLabelMap.EmployeeCurrentDept}
							</label>
							<div class="controls">
								${currDept}
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label">
								${uiLabelMap.HREmployeePosition}
							</label>
							<div class="controls">
								${currPositionsStr}
							</div>
						</div>
						<div class="control-group no-left-margin ">
							<label class="control-label">
								${uiLabelMap.NbrDayLeaveInMonth}
							</label>
							<div class="controls">
								<#assign nbrDayLeaveInMonth = emplLeaveDayInfo.nbrDayLeavePaidInMonth + emplLeaveDayInfo.nbrDayLeavePaidInMonth> 
								${nbrDayLeaveInMonth}&nbsp;(${uiLabelMap.NbrDayLeaveUnPaid}: ${emplLeaveDayInfo.nbrDayLeaveUnPaidInMonth})
							</div>
						</div>
						
						<div class="control-group no-left-margin ">
							<label class="control-label">
								${uiLabelMap.NbrDayLeaveInYear}
							</label>
							<div class="controls">
								<#assign nbrDayLeaveInYear = emplLeaveDayInfo.nbrDayLeavePaidInYear + emplLeaveDayInfo.nbrDayLeaveUnPaidInYear> 
								${nbrDayLeaveInYear}&nbsp;(${uiLabelMap.NbrDayLeaveUnPaid}: ${emplLeaveDayInfo.nbrDayLeaveUnPaidInYear})
							</div>
						</div>
						<#if emplLeave.leaveUnpaid?exists && emplLeave.leaveUnpaid == "Y">
							<div class="control-group no-left-margin">
								<label class="control-label">
									${uiLabelMap.LeaveUnpaid}
								</label>
								<div class="controls">
									<input type="checkbox" id="id-disable-check" checked="checked" disabled="disabled"/>
									<label class="lbl" for="id-disable-check" style="height:15px; width: 10px; margin-top: 3px !important; margin-bottom: 0px !important">&nbsp;</label>
								</div>
							</div>
						</#if>
						<div class="control-group no-left-margin ">
							<label class="control-label">
								${uiLabelMap.DayLeaveRegulation}
							</label>
							<div class="controls">
								${emplLeaveDayInfo.dayLeaveRegulation?if_exists}
							</div>
						</div>
					</div>
					<div class="span6">
						<div class="control-group no-left-margin">
							<label class="control-label">
								${uiLabelMap.CommonFromDate}
							</label>
							<div class="controls">
								${emplLeave.fromDate?string["dd/MM/yyyy"]}
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label">
								${uiLabelMap.CommonThruDate}
							</label>
							<div class="controls">
								${emplLeave.thruDate?string["dd/MM/yyyy"]}
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label">
								${uiLabelMap.FormFieldTitle_leaveTypeId}
							</label>
							<div class="controls">
								<#assign leaveType = delegator.findOne("EmplLeaveType", Static["org.ofbiz.base.util.UtilMisc"].toMap("leaveTypeId", emplLeave.leaveTypeId), false)>
								${leaveType.description?if_exists}
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label">
								${uiLabelMap.FormFieldTitle_emplLeaveReasonTypeId}
							</label>
							<div class="controls">
								<#assign leaveReasonType = delegator.findOne("EmplLeaveReasonType", Static["org.ofbiz.base.util.UtilMisc"].toMap("emplLeaveReasonTypeId", emplLeave.emplLeaveReasonTypeId), false)>
								${leaveReasonType.description?if_exists}
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label">
								${uiLabelMap.CommonStatus}
							</label>
							<div class="controls">
								<#assign currStatus = delegator.findOne("StatusItem", Static["org.ofbiz.base.util.UtilMisc"].toMap("statusId", emplLeave.leaveStatus), false)>
								${currStatus.description}
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label">
								${uiLabelMap.DateApplication}
							</label>
							<div class="controls">
								${emplLeave.dateApplication?string["dd/MM/yyyy"]}
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label">
								${uiLabelMap.CommonDescription}
							</label>
							<div class="controls">
								<#if emplLeave.description?exists>
									${StringUtil.wrapString(emplLeave.description)}
								</#if>
								&nbsp;
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>		
		<#if listPartyApprovalEmplLeave?has_content>
			<div class="row-fluid">
				<div class="span12 mgt20 boder-all-profile">
					<span class="text-header">${uiLabelMap.DetailsApproveApplication}</span>				
					<div class="form-horizontal">
						<#list listPartyApprovalEmplLeave as tempApproval>
							<#if tempApproval_index%2 == 0 >
								<#if tempApproval_index &gt; 0>
									<hr/>
								</#if>							
								<div class="row-fluid">
									<div class="span12">
							</#if>
							<div class="span6">
								<div class="control-group no-left-margin">
									<label class="control-label">
										${uiLabelMap.HRApprover}
									</label>
									<div class="controls">
										<#assign partyApprover = delegator.findOne("Person", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", tempApproval.partyId), false)>
										${partyApprover.lastName?if_exists} ${partyApprover.middleName?if_exists} ${partyApprover.firstName?if_exists}
									</div>
								</div>
								<div class="control-group no-left-margin">
									<label class="control-label">${uiLabelMap.HREmployeePosition}</label>
									<div class="controls">
										${Static["com.olbius.util.PartyUtil"].getCurrPosTypeOfEmplOverview(delegator, tempApproval.partyId)}
									</div>
								</div>
								<div class="control-group no-left-margin">
									<label class="control-label">
										${uiLabelMap.CommonStatus}
									</label>
									<div class="controls">
										<#assign currStatus = delegator.findOne("StatusItem", Static["org.ofbiz.base.util.UtilMisc"].toMap("statusId", tempApproval.approvalStatusId), false)>
										${currStatus.description?if_exists}
									</div>
								</div>
								<div class="control-group no-left-margin">	
									<label class="control-label">${uiLabelMap.ApprovalDate}</label>
									<div class="controls">
										${tempApproval.approvalDate?string["dd/MM/yyyy"]}
									</div>
								</div>
								<#if tempApproval.comment?exists>
									<div class="control-group no-left-margin">
										<label class="control-label">${uiLabelMap.HRNotes}</label>
										<div class="controls">
											${tempApproval.comment}
										</div>
									</div>
								</#if>
							</div>	
							<#if tempApproval_index%2 == 1 || !tempApproval_has_next>
									</div>
								</div>
							</#if>
						</#list>
					</div>
				</div>
			</div>
		</#if>
		
		<#if updateEmplLeavePerm?exists && updateEmplLeavePerm && emplLeave.leaveStatus != "LEAVE_APPROVED" &&  emplLeave.leaveStatus != "LEAVE_REJECTED">
			<div class="row-fluid">
				<div class="span12 mgt20 boder-all-profile">
					<form method="post" action="<@ofbizUrl>updateEmplLeaveApproval</@ofbizUrl>" class="basic-form form-horizontal">
						<input type="hidden" name="ntfId" value="${parameters.ntfId}">
						<input type="hidden" name="partyIdLeave" value="${parameters.partyIdLeave}">
						<input type="hidden" name="leaveFromDate" value="${parameters.leaveFromDate}">
						<input type="hidden" name="leaveTypeId" value="${parameters.leaveTypeId}">
						<div class="control-group no-left-margin">	
							<label class="control-label">
								${uiLabelMap.HRApprove}
							</label>
							<div class="controls">
								<select name="approvalStatusId">
									<#list statusList as status>
										<option value="${status.statusId}">${status.description}</option>
									</#list>
								</select>
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label>
								<label>${uiLabelMap.HRNotes}</label>
							</label>
							<div class="controls">
								<input type="text" name="comments">
							</div>
						</div>
						<div class="control-group no-left-margin">
							<label class="control-label" for="">&nbsp;</label>
							<div class="controls">
								<button class="btn btn-small btn-primary icon-ok">
									${uiLabelMap.CommonSubmit}
								</button>
							</div>
						</div>
					</form>
				</div>
			</div>
			
		</#if>
	<#else>
		<div class="alert alert-info">
			<h4>${uiLabelMap.NotHavePermissionViewEmplLeave}</h4>
		</div>	
	</#if>	
</div>