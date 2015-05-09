package com.olbius.delys.util;

import java.sql.Timestamp;

public class DateUtil {
	public static Timestamp getBiggerDateTime(Timestamp datetime1, Timestamp datetime2){
		if(datetime1 == null){
			return datetime2;
		}
		if (datetime2 == null) {
			return datetime1;
		}
		return datetime1.compareTo(datetime2) <= 0 ? datetime2 : datetime1;
	}
}
