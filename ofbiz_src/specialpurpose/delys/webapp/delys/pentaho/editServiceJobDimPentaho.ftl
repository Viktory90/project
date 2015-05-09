<@jqGridMinimumLib/>

        <div class="widget-box transparent no-bottom-border">
            <div class="widget-body">
                <div style="padding-left:10px;padding-top:10px;">
                    <form class="form-horizontal" name="editServiceJobPentaho" id="editServiceJobPentaho">

                        <div class="row-fluid">
                            <div class="control-group no-left-margin ">
                                <label class="">
                                    <label for="editServiceJobPentaho_jobName" class="control-label" id="editServiceJobPentaho_jobName_title">Tên Job</label>
                                </label>
                                <div class="controls">
						            <span class="ui-widget">
                                        <input name="JOB_NAME" id="editServiceJobPentaho_jobName" type="text" placeholder="Job name" class="required" ></input>
					            	</span>
                                </div>
                            </div>

                            <div class="control-group no-left-margin ">
                                <label class="">
                                    <label for="editServiceJobPentaho_service_name" class="control-label" id="editServiceJobPentaho_service_name_tittle">Tên service</label>
                                </label>
                                <div class="controls">
						            <span class="ui-widget">
                                        <input name="SERVICE_NAME_SHOW" readonly type="text" value="${parameters.service_name?if_exists}" id="editServiceJobPentaho_service_name"></input>
                                        <input name="SERVICE_NAME" type="hidden" value="${parameters.service_name?if_exists}"></input>
                                        <input type="hidden" name="POOL_NAME" value="pool" size="25"/>
					            	</span>
                                </div>
                            </div>

                            <div class="control-group no-left-margin ">
                                <label class="">
                                    <label for="editServiceJobPentaho_service_time" class="control-label" id="editServiceJobPentaho_service_time_tittle">Start time/date</label>
                                </label>
                                <div class="controls">
						            <span class="ui-widget">
                                     <div id="editServiceJobPentaho_service_time"></div>
					            	</span>
                                </div>
                            </div>

                            <div class="control-group no-left-margin ">
                                <label class="">
                                    &nbsp;  </label>
                                <div class="controls">
                                    <button id="staticButton" type="button" class="btn btn-small btn-primary" name="submitButton" ><i class="icon-ok"></i>OK</button>

                                </div>
                            </div>

                        </div>


                    </form>
                </div>
            </div>
        </div>
<script type="text/javascript">

    $("#editServiceJobPentaho_service_time").jqxDateTimeInput({ width: '175px', height: '25px',  formatString: 'dd/MM/yyyy', theme:theme});
    $("#editServiceJobPentaho_service_time").jqxDateTimeInput('val','');

    $('#editServiceJobPentaho').validate({
        errorElement: 'span',
        errorClass: 'help-inline',
        focusInvalid: false,
        rules: {
            JOB_NAME: {
                required: true,
            }
        },

        messages: {
            JOB_NAME: {
                required: '<span class="label-center">${uiLabelMap.SettingValidateRequired}</span>',
            }
        },

        invalidHandler: function (event, validator) { //display error alert on form submit
            $('.alert-error', $('.login-form')).show();
        },

        highlight: function (e) {
            $(e).closest('.control-group').removeClass('info').addClass('error');
        },

        success: function (e) {
            $(e).closest('.control-group').removeClass('error').addClass('info');
            $(e).remove();
        },

        submitHandler: function (form) {
            form.submit();
        },
        invalidHandler: function (form) {
        }
    });
</script>