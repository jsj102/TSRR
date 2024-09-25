package com.blue.schedule;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ScheduleDAO {
	@Autowired
	private SqlSessionTemplate my;
	//todo 기반 스케줄링
	//페이지상 갱신되는 서버타임or클라이언트타임
	
	
	
}
