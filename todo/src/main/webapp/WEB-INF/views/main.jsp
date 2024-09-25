<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<link rel="stylesheet" type="text/css" media="all"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" />
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.min.js"></script>
	
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>todo</title>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<link rel="stylesheet" type="text/css" media="all"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" />
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.min.js"></script>
</head>
<body>
	<script type="text/javascript">
		$(document).ready(function() {
			$('#login').click(function() {
				$.ajax({
					url : "login",
					method : "POST",
					data : {
						id : $('#userid').val(),
						pw : $('#userpw').val()
					},
					
					success : function(response) {
						window.location.replace("http://localhost:8080/todo/todo.jsp");
					},
					error : function(error) {
						alert("로그인실패");
					}
				}); // ajax
			}); // click
		});
	</script>




	<h1>할일</h1>
	<form>
		<input id="userid" placeholder="id" class="input" value="">
		<input id="userpw" placeholder="pw" class="input" value="">
		<button type="button" id="login">로그인</button>
		<button type="button" onclick="location.href='newmember.jsp' ">회원가입</button>
	</form>
</body>
</html>