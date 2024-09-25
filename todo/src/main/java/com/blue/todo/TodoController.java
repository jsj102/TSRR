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

		//json형태로 들어오게 수정
			System.out.println(todoDTO.toString());		
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

	
	// C - 할일 , 목표일
	// R - 할일,목표일,상태(진행중, 완료, 만료)
	// U - 목표일, 상태(진행중, 완료, 만료)
	// D - 그냥 지움
	
	//스케줄러로 1일 지난건 만료 상태로 변경
	// gpt 짧막한 tip, 추천
	// 알람기능
	// 시계
	// todo -> 스케줄 -> 레코맨드 --(이사이쯤 virtual map)--> 레저베이션
	//ex) 영화보기를 등록하면 추천영화를 띄워준다
	// api통신(서버여러개 , 도커나 aws)
	//입력해킹 방지
	
}
