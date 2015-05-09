package com.olbius.system;

import java.io.IOException;
import java.sql.Timestamp;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.config.EntityConfigUtil;
import org.ofbiz.entity.config.model.Datasource;
import org.ofbiz.entity.config.model.InlineJdbc;
import org.ofbiz.entity.datasource.GenericHelperInfo;
import org.ofbiz.entity.util.EntityUtil;

public class ProcessPentaho {
	
	private Process process;
	
	private boolean log;
	
	private String file;
	
	private final static String OLBIUS = "OLBIUS";
	private final static String OLBIUS_HOST = "OLBIUS_HOST";
	private final static String OLBIUS_PORT = "OLBIUS_PORT";
	private final static String OLBIUS_USER = "OLBIUS_USER";
	private final static String OLBIUS_PWD = "OLBIUS_PWD";
	private final static String OLAP = "OLAP";
	private final static String OLAP_HOST = "OLAP_HOST";
	private final static String OLAP_PORT = "OLAP_PORT";
	private final static String OLAP_USER = "OLAP_USER";
	private final static String OLAP_PWD = "OLAP_PWD";
	
	private GenericHelperInfo ofbiz;
	
	private GenericHelperInfo olap;
	
	
	public ProcessPentaho(String file) {
		this.file = file;
		
		process = new Process();
		
		process.setDir("applications/bi-x/integration");
		
		process.addCommand("/file", file);
	}
	
	public void addParam(String name, String value) {
		
		process.addCommand("\"/param:".concat(name).concat("=").concat(value).concat("\""));
		
	}
	
	public void addLogFile(String file) {
		
		if(!log) {
			process.addCommand("/logfile");
			log = true;
			process.addCommand(file);
		}
		
	}
	
	public void setInfo(GenericHelperInfo ofbiz, GenericHelperInfo olap) {
		this.ofbiz = ofbiz;
		this.olap = olap;
	}
	
	public Timestamp getLastUpdate(Delegator delegator, String job) throws GenericEntityException {
		GenericValue value = null;
		
		value = EntityUtil.getFirst(delegator.findByAnd("SchedulePentaho", UtilMisc.toMap("job", job), UtilMisc.toList("-scheduleId"), false));
	
		Timestamp timestamp = null;
		if(value != null) {
			timestamp = value.getTimestamp("date");
		}
		return timestamp;
	}
	
	public void setDate(Delegator delegator, String name) throws GenericEntityException {
		GenericValue value = null;
		
		Timestamp timestamp = getLastUpdate(delegator, file);
		if(timestamp != null) {
			addParam(name, timestamp.toString());
		}
		value = delegator.makeValue("SchedulePentaho");
		String id = delegator.getNextSeqId("SchedulePentaho");
		value.set("scheduleId", id);
		value.set("job", file);
		timestamp = new Timestamp(System.currentTimeMillis());
		value.set("date", timestamp);
		value.create();
	}
	
	public void setDate(Delegator delegator, String name, long time) throws GenericEntityException {
		GenericValue value = delegator.makeValue("SchedulePentaho");
		String id = delegator.getNextSeqId("SchedulePentaho");
		value.set("scheduleId", id);
		value.set("job", file);
		Timestamp timestamp = new Timestamp(time);
		value.set("date", timestamp);
		value.create();
		addParam(name, timestamp.toString());
	}
	
	public void start() throws IOException {
		
		if(ofbiz != null && olap != null) {
			Datasource datasourceInfo = EntityConfigUtil.getDatasource(ofbiz.getHelperBaseName());
        	
        	InlineJdbc jdbcElement = (InlineJdbc)datasourceInfo.getInlineJdbc();
        	
        	String _uri_ofbiz = UtilValidate.isNotEmpty(ofbiz.getOverrideJdbcUri()) ? ofbiz.getOverrideJdbcUri() : jdbcElement.getJdbcUri();
        	String _user_ofbiz = UtilValidate.isNotEmpty(ofbiz.getOverrideUsername()) ? ofbiz.getOverrideUsername() : jdbcElement.getJdbcUsername();
        	String _pwd_ofbiz = UtilValidate.isNotEmpty(ofbiz.getOverridePassword()) ? ofbiz.getOverridePassword() : EntityConfigUtil.getJdbcPassword(jdbcElement);
        	

        	String _s = _uri_ofbiz.substring(_uri_ofbiz.indexOf("://")+3);
        	String[] tmp = _s.split("/");
        	
        	String _dbn_ofbiz = tmp[1];
        	
        	tmp = tmp[0].split(":");
        	
        	String _host_ofbiz = tmp[0];
        	String _port_ofbiz = "";
        	if(tmp.length < 2) {
        		if(jdbcElement.getJdbcDriver().equals("org.postgresql.Driver")) {
        			_port_ofbiz = "5432";
        		}
        	} else {
        		_port_ofbiz = tmp[1];
        	}
        	
        	addParam(OLBIUS, _dbn_ofbiz);
        	addParam(OLBIUS_HOST, _host_ofbiz);
        	if(!_port_ofbiz.isEmpty()) {
        		addParam(OLBIUS_PORT, _port_ofbiz);
        	}
        	addParam(OLBIUS_USER, _user_ofbiz);
        	addParam(OLBIUS_PWD, _pwd_ofbiz);
        	
        	datasourceInfo = EntityConfigUtil.getDatasource(olap.getHelperBaseName());
        	
        	jdbcElement = (InlineJdbc)datasourceInfo.getInlineJdbc();
        	
        	String _uri_olap = UtilValidate.isNotEmpty(olap.getOverrideJdbcUri()) ? olap.getOverrideJdbcUri() : jdbcElement.getJdbcUri();
        	String _user_olap = UtilValidate.isNotEmpty(olap.getOverrideUsername()) ? olap.getOverrideUsername() : jdbcElement.getJdbcUsername();
        	String _pwd_olap = UtilValidate.isNotEmpty(olap.getOverridePassword()) ? olap.getOverridePassword() : EntityConfigUtil.getJdbcPassword(jdbcElement);
        	
        	_s = _uri_olap.substring(_uri_olap.indexOf("://")+3);
        	tmp = _s.split("/");
        	
        	String _dbn_olap = tmp[1];
        	
        	tmp = tmp[0].split(":");
        	
        	String _host_olap = tmp[0];
        	String _port_olap = "";
        	if(tmp.length < 2) {
        		if(jdbcElement.getJdbcDriver().equals("org.postgresql.Driver")) {
        			_port_olap = "5432";
        		}
        	} else {
        		_port_olap = tmp[1];
        	}
        	
        	addParam(OLAP, _dbn_olap);
        	addParam(OLAP_HOST, _host_olap);
        	if(!_port_olap.isEmpty()) {
        		addParam(OLAP_PORT, _port_olap);
        	}
        	addParam(OLAP_USER, _user_olap);
        	addParam(OLAP_PWD, _pwd_olap);
		}
		
		process.start();
	}
	
public void destroy(){
	process.destroy();
}
public void startKitchen() throws IOException {
		
		if(ofbiz != null && olap != null) {
			Datasource datasourceInfo = EntityConfigUtil.getDatasource(ofbiz.getHelperBaseName());
        	
        	InlineJdbc jdbcElement = (InlineJdbc)datasourceInfo.getInlineJdbc();
        	
        	String _uri_ofbiz = UtilValidate.isNotEmpty(ofbiz.getOverrideJdbcUri()) ? ofbiz.getOverrideJdbcUri() : jdbcElement.getJdbcUri();
        	String _user_ofbiz = UtilValidate.isNotEmpty(ofbiz.getOverrideUsername()) ? ofbiz.getOverrideUsername() : jdbcElement.getJdbcUsername();
        	String _pwd_ofbiz = UtilValidate.isNotEmpty(ofbiz.getOverridePassword()) ? ofbiz.getOverridePassword() : EntityConfigUtil.getJdbcPassword(jdbcElement);
        	

        	String _s = _uri_ofbiz.substring(_uri_ofbiz.indexOf("://")+3);
        	String[] tmp = _s.split("/");
        	
        	String _dbn_ofbiz = tmp[1];
        	
        	tmp = tmp[0].split(":");
        	
        	String _host_ofbiz = tmp[0];
        	String _port_ofbiz = "";
        	if(tmp.length < 2) {
        		if(jdbcElement.getJdbcDriver().equals("org.postgresql.Driver")) {
        			_port_ofbiz = "5432";
        		}
        	} else {
        		_port_ofbiz = tmp[1];
        	}
        	
        	addParam(OLBIUS, _dbn_ofbiz);
        	addParam(OLBIUS_HOST, _host_ofbiz);
        	if(!_port_ofbiz.isEmpty()) {
        		addParam(OLBIUS_PORT, _port_ofbiz);
        	}
        	addParam(OLBIUS_USER, _user_ofbiz);
        	addParam(OLBIUS_PWD, _pwd_ofbiz);
        	
        	datasourceInfo = EntityConfigUtil.getDatasource(olap.getHelperBaseName());
        	
        	jdbcElement = (InlineJdbc)datasourceInfo.getInlineJdbc();
        	
        	String _uri_olap = UtilValidate.isNotEmpty(olap.getOverrideJdbcUri()) ? olap.getOverrideJdbcUri() : jdbcElement.getJdbcUri();
        	String _user_olap = UtilValidate.isNotEmpty(olap.getOverrideUsername()) ? olap.getOverrideUsername() : jdbcElement.getJdbcUsername();
        	String _pwd_olap = UtilValidate.isNotEmpty(olap.getOverridePassword()) ? olap.getOverridePassword() : EntityConfigUtil.getJdbcPassword(jdbcElement);
        	
        	_s = _uri_olap.substring(_uri_olap.indexOf("://")+3);
        	tmp = _s.split("/");
        	
        	String _dbn_olap = tmp[1];
        	
        	tmp = tmp[0].split(":");
        	
        	String _host_olap = tmp[0];
        	String _port_olap = "";
        	if(tmp.length < 2) {
        		if(jdbcElement.getJdbcDriver().equals("org.postgresql.Driver")) {
        			_port_olap = "5432";
        		}
        	} else {
        		_port_olap = tmp[1];
        	}
        	
        	addParam(OLAP, _dbn_olap);
        	addParam(OLAP_HOST, _host_olap);
        	if(!_port_olap.isEmpty()) {
        		addParam(OLAP_PORT, _port_olap);
        	}
        	addParam(OLAP_USER, _user_olap);
        	addParam(OLAP_PWD, _pwd_olap);
		}
		
		process.startKitchen();
	}
}
