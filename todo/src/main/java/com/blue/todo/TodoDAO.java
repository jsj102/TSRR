package com.blue.todo;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class TodoDAO {
	@Autowired
	private SqlSessionTemplate my;
	
	public int insert(TodoDTO todoDTO) {
		return my.insert("todo.insert", todoDTO);
	}
	
	
	public List<TodoDTO> readList(int owner) {
		return my.selectList("todo.readListByOwner", owner);
	}
	
	public int update(TodoDTO todoDTO) {
		return my.update("todo.update", todoDTO);
	}
	
	public int delete(int seq) {
		return my.delete("todo.delete", seq);
	}
	
}
