package com.blue.schedule;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ScheduleService {
	@Autowired
	private ScheduleDAO scheduleDAO;
	
	
	public int addEvent(ScheduleDTO scheduleDTO) {
		if(scheduleDTO.getSeq()!=0) {
			updateEvent(scheduleDTO);
			return scheduleDTO.getSeq();
		}else {
			int success = scheduleDAO.insert(scheduleDTO).getSeq();
			return success;
		}
	}
	
	public ScheduleDTO getEvent(int seq) {
		
		ScheduleDTO scheduleDTO = scheduleDAO.getEvent(seq);
		return scheduleDTO;
	}
	
	public List<ScheduleDTO> getEventList(int owner) {
		return scheduleDAO.getEventList(owner);
	}
	
	public List<ScheduleDTO> getEventListByTime(Timestamp startTime){
		ScheduleDTO scheduleDTO = new ScheduleDTO();
		scheduleDTO.setStartTime(startTime);
		return scheduleDAO.getEventByTime(scheduleDTO);
	}
	
	
	public int updateEvent(ScheduleDTO scheduleDTO) {
		
		return scheduleDAO.update(scheduleDTO);
	}
	
	public int removeEvent(int seq) {
		return scheduleDAO.remove(seq);
	}
	
	
}
