<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

<script
	src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js"></script>

<meta charset="UTF-8">
<title>schedule</title>

<script>
	let calendar;
	document.addEventListener('DOMContentLoaded', function() {
		let calendarEl = document.getElementById('calendar');
		calendar = new FullCalendar.Calendar(calendarEl, {
			initialView : 'timeGridWeek',
			timeZone: 'UTC+9',
			headerToolbar : {
				left : 'prev,next',
				center : 'title',
				right : 'timeGridWeek,dayGridMonth' // user can switch between the two
			},
			 editable: true,
			 droppable: true,
			 eventClick : function(){
				 console.log("12");
			 }, 
			 dateClick : function(){
				 console.log("123");
			 },
			  events: [
				    {
				      id: 'a',
				      title: 'my event',
				      start: '2024-09-24T12:30:00',
				      end: '2024-09-25T12:30:00'
				    }
				  ]
			 //2024-06-01T12:30:00-09:00 

		});
		calendar.render();	
	calendar.addEvent( {'title':'evt', 'start':'2024-09-26', 'end':'2024-09-28'});
	});
	
</script>
</head>
<body>
	<div id='calendar'></div>
	
	
</body>
</html>