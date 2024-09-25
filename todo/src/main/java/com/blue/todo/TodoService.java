package com.blue.todo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TodoService {

	@Autowired
	private TodoDAO todoDAO;
	
	public int addWork(TodoDTO todoDTO) {
		if(!todoDTO.isEmpty()) {
			return todoDAO.insert(todoDTO);
		}
		return 0;
	}
	
	public List<TodoDTO> readWorkList(int owner){
		List<TodoDTO> list = todoDAO.readList(owner);
		
		return list;
		
	}
	
	public int updateWork(TodoDTO todoDTO) {
		return todoDAO.update(todoDTO);
	}
	
	public int deleteWork(int seq) {
		return todoDAO.delete(seq);
	}
	
	
}
