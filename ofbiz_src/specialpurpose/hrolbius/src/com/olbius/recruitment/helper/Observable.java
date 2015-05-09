package com.olbius.recruitment.helper;

import java.util.List;
import java.util.Map;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.ofbiz.entity.GenericEntityException;

public abstract class Observable {
	protected List<Observer> observerList = FastList.newInstance();
	protected Map<String, Object> mapTmp = FastMap.newInstance();
	
	public void registerObserver(Observer obs) {
		observerList.add(obs);
		
	}

	public void unregisterObserver(Observer obs) {
		observerList.remove(obs);
		
	}

	public void notifyObserver() throws GenericEntityException {
		for(Observer item : observerList){
			item.updateStatus(mapTmp);
		}
		
	}
}
