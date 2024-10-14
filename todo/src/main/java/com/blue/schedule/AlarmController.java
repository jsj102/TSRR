package com.blue.schedule;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@RestController
public class AlarmController {

	private Map<Integer, SseEmitter> alarmMap = new ConcurrentHashMap<Integer, SseEmitter>();
	// 동시성 보장을 위해 HashMap대신 ConcurrentHashMap사용
	//->여러 스레드에서 같은 값을 동시에 참조할일이 없어서 HashMap으로 대체가능함.
	@Autowired
	private ScheduleService scheduleService;
	@Autowired
	private AlarmService alarmService;



	@Scheduled(cron = "0 0/1 * * * ?") // 매1분마다 스케줄러실행
	public void alarm() {
		if(alarmMap.isEmpty()) {
			return;
		}

		Timestamp nowDate = alarmService.getTimeNow();
		List<ScheduleDTO> list = scheduleService.getEventListByTime(nowDate);
		// 현재시각, 알람체크되어있는 스케줄리스트

		for (ScheduleDTO scheduleDTO : list) {
			if (alarmMap.containsKey(scheduleDTO.getOwner())) {
				String message = "data: " + scheduleDTO.getTitle() + "시작" + "\n";
				SseEmitter emitter = alarmMap.get(scheduleDTO.getOwner());
				try {
					emitter.send(message);
				} catch (IOException e) {
					System.out.println("alarm sse IOException");
					emitter.completeWithError(e);
				}
			}
		}

	}

	// db구성 항목 : seq, owner, title, starttimestamp, endtimestamp, place,
	// alarm,comment
	// 음성입력기능 ( web speech to text)
	// todo -> 스케줄 -> 레코맨드 --(이사이쯤 virtual map)--> 레저베이션

	@RequestMapping(value = "/connectAlarm", method = RequestMethod.GET, produces = MediaType.TEXT_EVENT_STREAM_VALUE)
	//sse,get
	public SseEmitter connectAlarm(HttpServletRequest request) {
		SseEmitter emitter = new SseEmitter(10800000L);
		
		// complete()
		// send()
		// onTimeout(Runnable callback)
		// SseEmitter.event()
		
		// http polling , long pulling, websocket, webrtc
		
		int id = (int) request.getSession().getAttribute("login");
		alarmMap.put(id, emitter);

		// timeout 3시간(ms) long타입

		emitter.onCompletion(() -> {
			System.out.println("알람 연결종료");
			alarmMap.remove(id);
		});//람다식

		emitter.onTimeout(new Runnable() {
			@Override
			public void run() {
				System.out.println("타임아웃");
				emitter.complete(); // SseEmitter 종료
			}
		});//Runnable interface구현
		/* callback함수 구현법
		 * Runnable 인터페이스와 익명 클래스 
		 * 람다식
		 * 자신만의 콜백 인터페이스 정의 및 구현
		 * 메서드 참조
		 * 기타 함수형 인터페이스 (예: Callable)
		 */

		return emitter;
	}
	
}
