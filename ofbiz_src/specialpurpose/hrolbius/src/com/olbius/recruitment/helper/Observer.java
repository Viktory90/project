package com.olbius.recruitment.helper;

import java.util.Map;

import org.ofbiz.entity.GenericEntityException;

public interface Observer {
	public void updateStatus(Map<String, Object> context) throws GenericEntityException;
}
