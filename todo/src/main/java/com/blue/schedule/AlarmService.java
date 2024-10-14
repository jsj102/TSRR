package com.blue.schedule;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import org.springframework.stereotype.Service;

@Service
public class AlarmService {
	
	
	public Timestamp getTimeNow() {
		
		 Timestamp t = new Timestamp(System.currentTimeMillis());
		 SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:00");

		 return Timestamp.valueOf(dateFormat.format(t));
	}
}
