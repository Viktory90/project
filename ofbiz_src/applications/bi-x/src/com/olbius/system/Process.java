package com.olbius.system;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class Process {

	private ProcessBuilder processBuilder;
	
	private String dir;
	
	private List<String> command;
	
	public final static String os = System.getProperty("os.name");
	private java.lang.Process p;
	public Process() {
		processBuilder = new ProcessBuilder();
		command = new ArrayList<String>();
	}
	
	public void start() throws IOException {
		
		if(os.contains("Windows")) {
			command.add(0, "cmd");
			command.add(1, "/c");
			command.add(2, "start");
			command.add(3, "Pan.bat");
		}
		if(os.contains("Linux")) {
			command.add(0, "bash");
			command.add(1, "pan.sh");
		}
		
		processBuilder.command(command);
		if(dir != null && !dir.isEmpty()) {
			processBuilder.directory(new File(dir));
		}
		processBuilder.start();
	}
	
	public void startKitchen() throws IOException {
		
		if(os.contains("Windows")) {
			command.add(0, "cmd");
			command.add(1, "/c");
			command.add(2, "start");
			command.add(3, "Kitchen.bat");
		}
		if(os.contains("Linux")) {
			command.add(0, "bash");
			command.add(1, "kitchen.sh");
		}
		
		processBuilder.command(command);
		if(dir != null && !dir.isEmpty()) {
			processBuilder.directory(new File(dir));
		}
		p= processBuilder.start();
		
	}
	
	public void setDir(String dir) {
		this.dir = dir;
	}
	
	public void addCommand(String string) {
		command.add(string);
	}
	
	public void addCommand(String... string) {
		
		for(String s : string) {
			command.add(s);
		}
		
	}
	
	public void destroy(){
		p.destroy();
	}
	
}
