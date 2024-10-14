package com.blue.todo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TodoController {

	@Autowired
	private TodoService todoService;
	
	@RequestMapping(value="/insertWork", method=RequestMethod.POST)
	public String addWork(@RequestBody TodoDTO todoDTO) {

		if(todoService.addWork(todoDTO)!=0) {
			return "success";
		}
		return "fail";
	}
	
	public void readWork() {
		
	}
	
	@RequestMapping(value="/readWorkList", method=RequestMethod.POST)
	public List<TodoDTO> readWorkList(@RequestParam("owner") int owner) {
		return todoService.readWorkList(owner);
	}
	
	@RequestMapping(value="/updateWork", method=RequestMethod.POST)
	public int updateWork(@RequestBody TodoDTO todoDTO) {
		return todoService.updateWork(todoDTO);
	}
	
	@RequestMapping(value="/deleteWork", method=RequestMethod.POST)
	public int deleteWork(@RequestParam("seq") int seq) {
		return  todoService.deleteWork(seq);
	}
	
}
