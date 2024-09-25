package com.blue.todo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class TodoDTO {
	private int seq;
	private String todo;
	private String state;
	private int owner;
	private String comment;
	
	public TodoDTO() {
		this.seq = 0;
	}
	public boolean isEmpty() {
		if(this.owner == 0 || this.todo==null || this.state==null) {
			return true;
		}else {return false;}
	}
	
	public String toString() {
		return "할일 : "+todo+"("+state+")" + "   "+comment+" - "+ owner; 
	}
}
