package com.olbius.jackrabbit.webdav;

import javax.jcr.Repository;
import javax.jcr.RepositoryException;

import org.apache.jackrabbit.webdav.DavSessionProvider;
import org.apache.jackrabbit.webdav.simple.SimpleWebdavServlet;

import com.olbius.jackrabbit.client.JcrClientProvider;

public class OlbiusSimpleWebdavServlet extends SimpleWebdavServlet {
	private static final long serialVersionUID = 1L;
	private Repository repository;
	private DavSessionProvider davSessionProvider;
	
	@Override
	public Repository getRepository() {
		// TODO Auto-generated method stub
		if (repository == null){
			try {
				repository = JcrClientProvider.getInstance().getRepositoryWebDav();
			} catch (RepositoryException e) {
				return null;
			}
		}
		return repository;
	}
	 
	@Override
    public synchronized DavSessionProvider getDavSessionProvider() {
        if (davSessionProvider == null) {
            davSessionProvider = new OlbiusDavSessionProvider(getRepository(), getSessionProvider());
        }
        return davSessionProvider;
    }

}
