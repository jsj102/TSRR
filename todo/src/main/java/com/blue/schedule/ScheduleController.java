package com.blue.schedule;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

@Controller
public class ScheduleController {
	
	@Autowired
	private ScheduleService scheduleService;
	//기본+todo 기반 스케줄링
	//페이지상 갱신되는 서버타임or클라이언트타임
	//api통신쓰고싶은데 어디다가 쓰지..?
	
	
	
	//db구성 항목 : seq, owner, title, starttimestamp, endtimestamp, place, alarm, comment, repeat(on이면 start,end의미없자나)
	//title, comment는 가져올수있음 끝이없음 상태이면 repeat on 나머진 default off
	
	
	//todo schedule recommand reservation
	
	//daily스케줄링 할것인가
	//주간&월간단위 스케줄링할것인가
	
	
	
	
	//기본 CRUD는 동일하게
	//추가 C -> 할일에서 가져오기
	//할일 새로 생성
	//음성입력기능 ( web speech to text)
	
	
	
}
