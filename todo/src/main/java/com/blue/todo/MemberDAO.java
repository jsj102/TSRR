package com.blue.todo;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDAO {
	@Autowired
	private SqlSessionTemplate my;
	
	public int insert(MemberDTO memberDTO) {
		return my.insert("member.insert", memberDTO);
	}
	
	public int readOne(MemberDTO memberDTO) {
		return my.selectOne("member.readOne",memberDTO);
	}
}
