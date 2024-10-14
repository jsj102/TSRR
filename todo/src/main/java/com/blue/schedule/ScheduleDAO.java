package com.blue.schedule;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ScheduleDAO {
	@Autowired
	private SqlSessionTemplate my;
	//todo 기반 스케줄링
	//페이지상 갱신되는 서버타임or클라이언트타임
	
	public ScheduleDTO insert(ScheduleDTO scheduleDTO) {
		my.insert("schedule.insert",scheduleDTO);
		return scheduleDTO;
	}
	
	public ScheduleDTO getEvent(int seq) {
		ScheduleDTO scheduleDTO = my.selectOne("schedule.one", seq);
		return scheduleDTO;
	}
	
	public List<ScheduleDTO> getEventList(int owner) {
		List<ScheduleDTO> list = my.selectList("schedule.list", owner);
		return list;
	}
	
	public List<ScheduleDTO> getEventByTime(ScheduleDTO scheduleDTO){
		List<ScheduleDTO> list = my.selectList("schedule.listByTime",scheduleDTO);
		return list;
	}
	
	
	public int update(ScheduleDTO scheduleDTO) {
		return my.update("schedule.update", scheduleDTO);
	}
	
	public int remove(int seq) {
		return my.delete("schedule.delete", seq);
	}
	
}
