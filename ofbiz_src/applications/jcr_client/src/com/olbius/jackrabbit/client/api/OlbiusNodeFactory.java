package com.olbius.jackrabbit.client.api;

import javax.jcr.Session;

import com.olbius.jackrabbit.client.core.OlbiusNode;

public class OlbiusNodeFactory {
	
	public OlbiusNode newInstance(Session session) {
		return new OlbiusNodeImpl(session);
	}
	
}
