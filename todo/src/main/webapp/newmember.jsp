<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<link rel="stylesheet" type="text/css" media="all"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" />
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.min.js"></script>
<!-- <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet"> -->

<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>
	<script type="text/javascript">
		$(document).ready(function() {
			$('#register').click(function() {
				$.ajax({
					url : "register",
					method : "POST",
					data : {
						id : $('#userid').val(),
						pw : $('#userpw').val()
					},
					
					success : function(response) {
						alert(response);
						window.location.replace("http://localhost:8080/todo/");
						// rediect
					},
					error : function(error) {
						alert("가입실패");
					}
				}); // ajax
			}); // click
		});
	</script>
	<form>
		<input id="userid" placeholder="id" class="idinput" value="">
		<input id="userpw" placeholder="pw" class="pwinput" value="">
		<button type="button" id="register">가입</button>
		<button type="button" onclick="location.href='/todo' ">돌아가기</button>
	</form>
</body>
</html>