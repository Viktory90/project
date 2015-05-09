package com.olbius.recruitment.helper;

import java.util.Map;

import org.ofbiz.service.DispatchContext;



public class RecruitmentTestPlanHelper {
	
	public static void rateExam(DispatchContext dpctx,
			Map<String, ? extends Object> context) throws Exception{
		WorkEffortStatus weStatus = new WorkEffortStatus();
		RecruitmentPlanStatus rpStatus = new RecruitmentPlanStatus();
		weStatus.registerObserver(rpStatus);
		ExamRating subject = new ExamRating();
		subject.registerObserver(weStatus);
		subject.rateExam(dpctx, context);
	}
	
	public static void rateFirstInterview(DispatchContext dpctx,
			Map<String, ? extends Object> context) throws Exception{
		WorkEffortStatus weStatus = new WorkEffortStatus();
		RecruitmentPlanStatus rpStatus = new RecruitmentPlanStatus();
		weStatus.registerObserver(rpStatus);
		FirstIntvRating subject = new FirstIntvRating();
		subject.registerObserver(weStatus);
		subject.rateFirstInterview(dpctx, context);
	}
	
	public static void rateSecondInterview(DispatchContext dpctx,
			Map<String, ? extends Object> context) throws Exception{
		WorkEffortStatus weStatus = new WorkEffortStatus();
		RecruitmentPlanStatus rpStatus = new RecruitmentPlanStatus();
		weStatus.registerObserver(rpStatus);
		SecondIntvRating subject = new SecondIntvRating();
		subject.registerObserver(weStatus);
		subject.rateSecondInterview(dpctx, context);
	}
}

