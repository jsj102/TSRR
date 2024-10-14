package com.blue.todo;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponseWrapper;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MemberController {
	@Autowired
	private MemberService memberService;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String mainPage() {
		// http://주소/todo/
		// 첫페이지 띄워주기
		return "main";
	}

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public ResponseEntity<String> tryLogin(@RequestParam("id") String id, @RequestParam("pw") String pw,
			HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberDTO memberDTO = memberService.login(id, pw);
		if (memberDTO.getSeq() != 0) {
			// 로그인성공
			session.setAttribute("login", memberDTO.getSeq());
			return new ResponseEntity<String>(session.getAttribute("login").toString(), HttpStatus.OK);
		} else {// 로그인실패
			return new ResponseEntity<String>("fail", HttpStatus.BAD_REQUEST);
		}
	}

	@RequestMapping(value = "/logincheck", method = RequestMethod.POST)
	public ResponseEntity<String> loginCheck(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session != null && session.getAttribute("login") != null) {
			return new ResponseEntity<String>(session.getAttribute("login").toString(), HttpStatus.OK);
		} else {
			return new ResponseEntity<String>("fail", HttpStatus.BAD_REQUEST);
		}
	}

	// 로그아웃
	// session.invalidate();

	@RequestMapping(value = "/register", method = RequestMethod.POST)
	public ResponseEntity<String> registMember(@RequestParam("id") String id, @RequestParam("pw") String pw) {
		// 신규유저 생성
		int success = 0;
		success = memberService.regist(id, pw);
		if (success == 1) {
			return new ResponseEntity<String>("success", HttpStatus.OK);
		} else {
			return new ResponseEntity<String>("fail", HttpStatus.BAD_REQUEST);
		}
	}

}
