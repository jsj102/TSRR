package com.blue.schedule;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ScheduleController {
	
	@Autowired
	private ScheduleService scheduleService;
	//api통신쓰고싶은데 어디다가 쓰지..? todo
	
	@RequestMapping(value="/saveSchedule", method= RequestMethod.POST)
	public int addEvent(@RequestBody ScheduleDTO scheduleDTO) {
		
		System.out.println("save"+scheduleDTO.toString());
		return scheduleService.addEvent(scheduleDTO);
	}
	
	@RequestMapping(value="/getSchedule", method= RequestMethod.POST)
	public ScheduleDTO getEvent(@RequestParam("seq") int seq) {
		return scheduleService.getEvent(seq);
	}

	@RequestMapping(value="/getScheduleList", method= RequestMethod.POST)
	public List<ScheduleDTO> getEventList(@RequestParam("owner") int owner) {
		return scheduleService.getEventList(owner);
	}
	
	@RequestMapping(value="/updateSchedule",method=RequestMethod.POST)
	public int updateEvent(@RequestBody ScheduleDTO scheduleDTO) {
		System.out.println("update"+scheduleDTO.toString());
		return scheduleService.updateEvent(scheduleDTO);
	}
	
	@RequestMapping(value="/removeSchedule", method= RequestMethod.POST)
	public int removeEvent(@RequestParam("seq") int seq) {
		return scheduleService.removeEvent(seq);
	}
	
	
}
