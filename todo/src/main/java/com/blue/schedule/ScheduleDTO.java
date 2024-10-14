package com.blue.schedule;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ScheduleDTO {
	private int seq;
	private int owner;
	private String title;
	private Timestamp startTime;
	private Timestamp endTime;
	private String place;
	private boolean alarm;
	private String comment;
	
	public ScheduleDTO() {
		this.seq = 0;
		this.alarm = false;
		this.title = "";
		this.place = "";
		this.comment = "";
	}
	

}
