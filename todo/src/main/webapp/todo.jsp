<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>todo</title>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<link rel="stylesheet" type="text/css" media="all"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" />
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.min.js"></script>

<style type="text/css">
	.todo-list {
    	cursor: pointer;
	}

	.todo-list:hover {
    	background-color: #f0f0f0;
	}
</style>


</head>
<body>
	<a href="http://localhost:8080/todo/schedule.jsp">
		<button type="button" >Schedule</button>
	</a>
	<button id="recordStart" type="button">녹음</button>
	<form>
		<div>
			<input id="todo" placeholder="무엇을 해야하나요?" class="todoinput" value="">
			진행상태 : <select name="state" id="state">
				<option value="끝이없음">끝이없음</option>
				<option value="예정">예정</option>
				<option value="진행중">진행중</option>
				<option value="완료">완료</option>
				<option value="만료">만료</option>
			</select>
			 특이사항 : <input id="comment" placeholder="메모" class="todoinput"value="">
			<button type="button" id="addWork">추가</button>
		</div>
	</form>
	<form id="needWork">>할일</form>
	<form id="doWork">>한것</form>
	<form id="expiredWork">>만료</form>
	<br>
	<br>
	<br>
	<form id="todoEditForm" style="display: none;">
		수정 / 
			
			<input type="hidden" id="editSeq" /> 
			할일 : <input type="text" id="editTodo" /> 
			진행상태 : <select name="editState" id="editState">
				<option value="끝이없음">끝이없음</option>
				<option value="예정">예정</option>
				<option value="진행중">진행중</option>
				<option value="완료">완료</option>
				<option value="만료">만료</option>
			</select> 특이사항 : <input id="editComment" placeholder="메모" class="todoinput"value="">
			<button type="button" id="update">저장</button>
			<button type="button" id="delete">삭제</button>			
	</form>




<script type="text/javascript">
	
	SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
	//브라우저 호환성문제 해결
	let stt;
	if ('SpeechRecognition' in window) {
		//브라우저 지원문제 확인
		stt = new SpeechRecognition();
        stt.lang = 'ko-KR';
        stt.interimResults = false;
        stt.maxAlternatives = 1;
        //위 2개 옵션 default
        stt.continuous = false;
        //문장마다 인식종료(한호흡)
        $('#recordStart').click(function(){
			stt.start();
		})
		stt.onspeechend = function(){
        	stt.stop();
        }
        stt.onresult = function(event){
        	$('#todo').val(event.results[0][0].transcript);
        }
	}
	
	
	/*
	공통
	SpeechRecognition.start();
	SpeechRecognition.stop();
	SpeechRecognition.abort();
	SpeechRecognition.onstart
	SpeechRecognition.onend
	SpeechRecognition.onresult
	SpeechRecognition.onerror
	SpeechRecognition.onspeechstart
	SpeechRecognition.onspeechend
	
	webkitSpeechRecognitio에서
	SpeechRecognition.onsoundstart
	SpeechRecognition.onsoundend
	SpeechRecognition.onaudiostart
	SpeechRecognition.onaudioend
	*/
	
	
	let owner = 0;
	$(document).ready(function() {
		let seq = -1;
		$.ajax({
			url : "logincheck",
			method : "POST",
			success : function(response) {
				seq = parseInt(response);
				owner = seq;
				readWorkList(seq);
			},
			error : function(e) {
				console.log(e);
				window.location.replace("http://localhost:8080/todo");
			}
		})//ajax 페이지 진입시 로그인체크후 미로그인시 초기사이트로 보내기

		$('#todo').on('input', function() {
			this.value = this.value.replace(/[^\wㄱ-ㅎㅏ-ㅣ가-힣,]/g, '');
		});//정규식을 사용하여 영우,숫자,한글, ','만 사용가능하도록 변경(취약점방어)
		$('#comment').on('input', function() {
			this.value = this.value.replace(/[^\wㄱ-ㅎㅏ-ㅣ가-힣,]/g, '');
		});//정규식을 사용하여 영우,숫자,한글, ','만 사용가능하도록 변경

		$('#addWork').click(function() {
			let startDate = null;
			let endDate = null;
			let willToDo = JSON.stringify({
				seq : 0,
				todo : $('#todo').val(),
				state : $('#state').val(),
				owner : seq,
				comment : $('#comment').val()
			});//json stringify
			$.ajax({
				url : "insertWork",
				method : "POST",
				contentType : 'application/json',
				data : willToDo,
				success : function(response) {
					alert(response)
				},
				error : function(e) {
				}
			})//ajax
		})//click 저장소에 Todo추가
	})//document.ready

	function readWorkList(seq) {
		$.ajax({
			url : "readWorkList",
			method : "POST",
			data : {
				owner : seq
			},
			success : function(list) {
				//리스트 받아서 할일 한것 만료 구분하고
				//클릭이나 수정 넣어서 아래폼에 수정폼 뜨게한다음에 수정시키고 저장하면 변동되게하기
				classifyList(list);

			},
			error : function(e) {
			}
		})//ajax 저장된 Todo리스트 받아오기
	}//readWorkList
	
	function classifyList(list) {

		let needWorkListForm = $('#needWork');
		let doWorkListForm = $('#doWork');
		let expiredWorkListForm = $('#expiredWork');
		needWorkListForm.empty();
		doWorkListForm.empty();
		expiredWorkListForm.empty();
		needWorkListForm.append("<br><br>할일 - 상태 - 메모<br><br>")
		doWorkListForm.append("<br><br>한일 - 상태 - 메모<br><br>");
		expiredWorkListForm.append("<br><br>만료 - 상태 -메모<br><br>");
		for (let i = 0; i < list.length; i++) {
		    let todo = list[i]; // 배열의 각 항목을 가져옴
		    let todoSeq = todo.seq;
		    let todoTodo = todo.todo;
		    let todoState = todo.state;
		    let todoComment = todo.comment;
		    let tempString = '<div class="todo-list" data-seq="'+todoSeq+'"><span class="todo-todo">'+todoTodo+'</span>-<span class="todo-state">'+todoState+'</span>'+" - "+'<span class="todo-comment">'+todoComment+'</span></div>';
		    if(todoState=="끝이없음"||todoState=="진행중"||todoState=="예정"){		
		    	needWorkListForm.append(tempString);
		    }
		    if(todoState=="완료"){
		    	doWorkListForm.append(tempString);
		    }
		    if(todoState=="만료"){
		    	expiredWorkListForm.append(tempString);
		    }
		    
		        
		}//for Todo리스트 페이지에 상태 분류별로 나눠주기

		$('.todo-list').click(function() {
		    let parentDiv = $(this);
		    let seq = parentDiv.data('seq'); //data-* *에서 값가져옴 여기서는 *=seq
		    let todoTodo = parentDiv.find('.todo-todo').text();
		    let todoState = parentDiv.find('.todo-state').text();
		    let todoComment = parentDiv.find('.todo-comment').text();
		    $('#editSeq').val(seq);
		    $('#editTodo').val(todoTodo);
		    $('#editState').val(todoState);
		    $('#editComment').val(todoComment);
		    
		    $('#todoEditForm').show();//수정폼 열기
		});//click Todo클릭시 수정폼 열어주는 함수 등록
		

	}//classifyList
    $('#update').click(function() {
    	let seq = $('#editSeq').val();
        let updateTodo = JSON.stringify({
            seq : seq,
            todo : $('#editTodo').val(),
            state : $('#editState').val(),
            comment : $('#editComment').val()
        });

        $.ajax({
            url: "updateWork",
            method: "POST",
            contentType: "application/json",
            data: updateTodo,
            success: function(response) {
            	if(response==1){
            		console.log("success");
            	}
                readWorkList(owner);
                $('#todoEditForm').hide();//수정폼 닫기
            },
            error: function(e) {
            }
        });//ajax
    });//click 수정 버튼 클릭시 이벤트
    
    $('#delete').click(function(){
    	let seq = parseInt($('#editSeq').val());
        $.ajax({
            url: "deleteWork",
            method: "POST",
            data: {
            	seq : seq
            },
            success: function(response) {
            	if(response==1){
            		console.log("success");
            	}
                readWorkList(owner);
                $('#todoEditForm').hide();//수정폼 닫기
            },
            error: function(e) {
            }
        });//ajax
    })//click 삭제 버튼 클릭시 이벤트
</script>
</body>
</html>