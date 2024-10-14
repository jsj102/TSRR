<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js"></script>


<link rel="stylesheet" type="text/css" media="all"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" />
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.min.js"></script>

<title>schedule</title>


<script>
//	const eventSource = new EventSource("url");
//	eventSource.onopen= function(event){
//		//연결시
//	};	
//	eventSource.onmessage = function(event){
//		//event data 로 알람정보가공 후 알람		
//	};	
//eventSource.addEventListener()
//eventSource.close();



	let eventSource;

	let tts = null;
	let voices = [];
	//.getVoices() return array
	
	
	let calendar;
	let EventModal = null;
	let scheduleList = null;

	let owner = 0;
	
	let utcDate = new Date();
	let utcOffset = utcDate.getTimezoneOffset();
	let utcHour = Math.abs(utcOffset/60);
	let utcMin = Math.abs(utcOffset%60);
	utcHour = String(utcHour).padStart(2,'0');
	utcMin = String(utcMin).padStart(2,'0');
	let timezone = '';
	if(utcOffset>0){
		timezone += '-';
	}else{
		timezone += '+';
	}
	timezone += utcHour + ':' + utcMin;
	
	

	$(document).ready(function() {
		$.ajax({
			url : "logincheck",
			method : "POST",
			success : function(response) {
				owner = parseInt(response);
				readScheduleList(owner);
			},
			error : function(e) {
				console.log(e);
				window.location.replace("http://localhost:8080/todo");
			}
		})//ajax 페이지 진입시 로그인체크후 미로그인시 초기사이트로 보내기
/*
 * 
 			알람 호출부
 
 */		
 		tts = window.speechSynthesis;
    	tts.onvoiceschanged = function(){
			voices = tts.getVoices();    		
    	}//빈값방지
    	
		
		function soundAlarm(source){
    		if(tts.speaking){
    			console.log("사운드알람 실행중/사운드 겹침 방지");
    		}
			let ttsSource = new SpeechSynthesisUtterance(source);
			ttsSource.lang = 'ko-KR';
			ttsSource.pitch = 1;
			//높이(음역)
			ttsSource.rate = 1.2;
			//속도
			ttsSource.volume = 1;
			voice = voices[0];
			tts.speak(ttsSource);
		}
		
		
		
    	eventSource = new EventSource('connectAlarm'); // SSE 요청

    	eventSource.onmessage = function(event) {
    		soundAlarm(event.data);
        	alert(event.data);
    	};

   		eventSource.onerror = function(event) {
        	console.log("SSE connection error");
    	};
		
    	window.addEventListener('beforeunload', function() {
    		eventSource.close();
    	});//종료시
		
		
    	/*
    	*					캘린더
    	*
    	*/
    	
    	
		function initCalendar(){
			let calendarEl = document.getElementById('calendar');
			EventModal = new bootstrap.Modal(document.getElementById('eventModal'));
			calendar = new FullCalendar.Calendar( calendarEl,
				{
					initialView : 'timeGridWeek',
					timeZone : 'UTC+9',
					headerToolbar : {
						left : 'prev,next',
						center : 'title',
						right : 'timeGridDay,timeGridWeek,dayGridMonth'
					},
					editable : true,
					droppable : true,
					eventClick : function(info) {
						$('#modalTitle').val('');
						$('#modalStartTime').val('');
						$('#modalEndTime').val('');
						$('#modalPlace').val('');
						$('#modalAlarm').prop('checked', false);
						$('#modalComment').val('');

						
						let seq = info.event.extendedProps.seq;			
						console.log("event Click : "+seq)
						$('#modalAlarm').prop('checked', false);
									
						$.ajax({
							url : "getSchedule",
							method : "POST",
							data : {
								seq : seq
							},
							success : function(response){
								setUpdateScheduleModal(response);
								EventModal.show();
							},
							error : function(e){
								console.log(e);
							}
						})
						
						document.getElementById('saveModal').setAttribute('type', 'hidden');
						document.getElementById('updateModal').setAttribute('type', 'button');
						document.getElementById('deleteModal').setAttribute('type', 'button');
					},//일정클릭시
					
					dateClick : function(info) {
						$('#modalTitle').val('');
						$('#modalStartTime').val('');
						$('#modalEndTime').val('');
						$('#modalPlace').val('');
						$('#modalAlarm').prop('checked', false);
						$('#modalComment').val('');
						
						let date = new Date();
						date.setMinutes(date.getMinutes() - utcOffset);//시간조정
						let now = date.toISOString().slice(0, 16); //date 형식 datetime-local에 맞게 변경
								
						
						if(now>info.dateStr){
							$('#modalStartTime').val(info.dateStr);
							$('#modalEndTime').val(now);
						}else{
							$('#modalStartTime').val(now);
							$('#modalEndTime').val(info.dateStr);
						}
								// 모달 띄우기
						document.getElementById('saveModal').setAttribute('type', 'button');
						document.getElementById('updateModal').setAttribute('type', 'hidden');
						document.getElementById('deleteModal').setAttribute('type', 'hidden');
						EventModal.show();
								
					},//일정외 시간클릭시

				});
				calendar.render();
				setScheduleList(scheduleList);		
		}//init			
						
						
						
				$('#saveModal').click(function() {
					let seq = 0;
					let title = $('#modalTitle').val();
					
					let stT = $('#modalStartTime').val();
					let startDate = new Date(stT);
					let startTime = startDate.toISOString().slice(0, 16);
					
					let edT = $('#modalEndTime').val();
					let endDate = new Date(edT);
					let endTime = endDate.toISOString().slice(0, 16);
					
					
					let place = $('#modalPlace').val();
					let alarm = $('#modalAlarm').prop('checked');
					let comment= $('#modalComment').val();
				
					let test = new Date(startTime);
					console.log(test);
					
				    let scheduleInfo = JSON.stringify({
			            seq : seq,
			            owner : owner,
			            title : title,
			            startTime : startTime,
			            endTime : endTime,
				        place : place,
			            alarm : alarm,
			            comment : comment
			        });
					        //startTime , endTime 가공해줘야함
					$.ajax({
			            url: "saveSchedule",
			            method: "POST",
			            contentType: "application/json",
		 	            data: scheduleInfo,
			            success: function(response) {
									seq = response;	
								
									calendar.addEvent({
										'id' : seq,
										'title' : title+'('+comment+')',
										'start' : stT,
										'end' : edT,
										'extendedProps' : {
								        	seq : seq
								    	}
									});

									console.log("calendar add"+''+startTime);
						
					            },
					            error: function(e) {
					            	alert("데이터 저장에 실패");
					            }
					});//ajax
					
					EventModal.hide();
				})//savemodal
						
						
				$('#updateModal').click(function(){
					let seq = $('#modalSeq').val();
					let title = $('#modalTitle').val();
					
					let stT = new Date($('#modalStartTime').val());
					let startTime = stT.toISOString().slice(0, 16); //date 형식 datetime-local에 맞게 변경
					stT.setMinutes(stT.getMinutes() - utcOffset);//시간조정
					let startTimeForEvent = stT.toISOString().slice(0, 16); //date 형식 datetime-local에 맞게 변경
				
					let edT = new Date($('#modalEndTime').val());
					let endTime = edT.toISOString().slice(0, 16); //date 형식 datetime-local에 맞게 변경
					edT.setMinutes(edT.getMinutes() - utcOffset);//시간조정
					let endTimeForEvent = edT.toISOString().slice(0, 16); //date 형식 datetime-local에 맞게 변경

					
					
					let place = $('#modalPlace').val();
					let alarm = $('#modalAlarm').prop('checked');
					let comment= $('#modalComment').val();
		
					let scheduleInfo = JSON.stringify({
			            seq : seq,
			            owner : owner,
			            title : title,
			            startTime : startTime,
			            endTime : endTime,
				        place : place,
			            alarm : alarm,
			            comment : comment
			        });
					
					$.ajax({
						url : "updateSchedule",
						method : "POST",
						data : scheduleInfo,
			            contentType: "application/json",
						success : function(success){
							if(success==0){alert("업데이트 실패");}
						},
						error : function(e){
							console.log(e);
						}

					})//ajax
					console.log("updateModal"+startTime)
					let schedule = calendar.getEventById(seq);
					schedule.setProp('title', title+'('+comment+')');
					schedule.setDates(startTimeForEvent, endTimeForEvent);
					
					EventModal.hide();
				})//updateModal
				
				
				
				
				
				
				
						
				$('#closeModal').click(function() {
					EventModal.hide();
				})//closemodal
				
				
				$('#deleteModal').click(function(){
					let seq = $('#modalSeq').val();
					$.ajax({
						url : "removeSchedule",
						method : "POST",
						data : {
							seq : seq
						},
						success : function(response){
							if(response==0){
								alert("삭제실패");
							}else{
								//event get by id , delete
								let schedule = calendar.getEventById(seq);
								schedule.remove();
							}
							
						},
						error : function(e){console.log(e)}
					})
					
					
					EventModal.hide();
				})//deleteModal
						
						
						//페이지 들어오면 read event해줘야함
				$('#modalTitle').on('input', function() {
					this.value = this.value.replace(/[^\wㄱ-ㅎㅏ-ㅣ가-힣,]/g, '');
				});//정규식을 사용하여 영우,숫자,한글, ','만 사용가능하도록 변경
						
				$('#modalPlace').on('input', function() {
					this.value = this.value.replace(/[^\wㄱ-ㅎㅏ-ㅣ가-힣,]/g, '');
				});
						
				$('#modalComment').on('input', function() {
					this.value = this.value.replace(/[^\wㄱ-ㅎㅏ-ㅣ가-힣,]/g, '');
				});
						
		
		function readScheduleList(holder){
			$.ajax({
				url : "getScheduleList",
				method : "POST",
				data : {
					owner : holder
				},
				success : function(response){
					scheduleList = response;
					initCalendar();
				},
				error : function(e){
					
				}
			})
		}//readlist - init
		
		function setScheduleList(scheduleList){
			for (let i = 0; i < scheduleList.length; i++) {
				let schedule = scheduleList[i];
				let seq = schedule.seq;

				let title = schedule.title;
				
				let stT = new Date(schedule.startTime);
				stT.setMinutes(stT.getMinutes() - utcOffset);//시간조정
				let startTime = stT.toISOString().slice(0, 16); //date 형식 datetime-local에 맞게 변경
			
				let edT = new Date(schedule.endTime);
				edT.setMinutes(edT.getMinutes() - utcOffset);//시간조정
				let endTime = edT.toISOString().slice(0, 16); //date 형식 datetime-local에 맞게 변경
			
				let place = schedule.place;
				let alarm = schedule.alarm;
				let comment= schedule.comment;
				calendar.addEvent({
					'id' : seq,
					'title' : title+'('+comment+')',
					'start' : startTime,
					'end' : endTime,
				    'extendedProps' : {
				        seq: seq
				    }
				});
				//timestamp 1000000->date time...
			}
		}//setList - init
		
		function setUpdateScheduleModal(schedule){
		
			let seq = schedule.seq;

			let title = schedule.title;
			
			let stT = new Date(schedule.startTime);
			stT.setMinutes(stT.getMinutes() - utcOffset);//시간조정
			let startTime = stT.toISOString().slice(0, 16); //date 형식 datetime-local에 맞게 변경
		
			let edT = new Date(schedule.endTime);
			edT.setMinutes(edT.getMinutes() - utcOffset);//시간조정
			let endTime = edT.toISOString().slice(0, 16); //date 형식 datetime-local에 맞게 변경
		
			let place = schedule.place;
			let alarm = schedule.alarm;
			let comment= schedule.comment;

			$('#modalSeq').val(seq);
			$('#modalTitle').val(title);
			$('#modalStartTime').val(startTime);
			$('#modalEndTime').val(endTime);	
			$('#modalPlace').val(place);
			if(alarm==true){			
				$('#modalAlarm').prop('checked', true);
			}
			$('#modalComment').val(comment);
			
			
			console.log("setUpdateScheduleModal"+startTime)
					
		}//setUpdateScheduleModal
		
	});//$(document).ready
			
			
</script>
</head>
<body>
	<div id='calendar'></div>


	<!-- Modal -->
	<div class="modal fade" id="eventModal" tabindex="-1"
		aria-labelledby="eventModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="eventModalLabel">일정</h5>
				</div>
				<div class="modal-body">
					<p>
						<input id="modalSeq" type="hidden"></input>
					</p>

					<p>
						일정명 : <input id="modalTitle"></input>
					</p>
					<p>
						시작일 : <input id="modalStartTime" type="datetime-local"></input>
					</p>
					<!-- timestamp -->
					<p>
						종료일 : <input id="modalEndTime" type="datetime-local"></input>
					</p>
					<!-- timestamp -->
					<p>
						장소 : <input id="modalPlace"></input>
					</p>
					<p>
						알람 : <input id="modalAlarm" type="checkbox"></input>
					</p>
					<!-- 체크박스 -->
					<p>
						메모 : <input id="modalComment"></input>
					</p>
				</div>
				<div class="modal-footer">
					<input type="button" class="btn btn-secondary" id="saveModal" value="저장"></input>
					<input type="hidden" class="btn btn-secondary" id="updateModal" value="수정"></input>
					<input type="hidden" class="btn btn-secondary" id="deleteModal" value="삭제"></input>
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="closeModal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- modal end -->
	
	<a href="http://localhost:8080/todo/todo.jsp">
		<button type="button" >Todo</button>
	</a>

</body>
</html>