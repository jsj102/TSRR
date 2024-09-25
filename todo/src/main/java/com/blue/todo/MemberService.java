package com.blue.todo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberService {
	@Autowired
	private MemberDAO memberDAO;
	
	public int regist(String id,String pw) {
		MemberDTO memberDTO = new MemberDTO();
		memberDTO.setId(id);
		memberDTO.setPw(pw);
		return memberDAO.insert(memberDTO);
	}
	
	
	public MemberDTO login(String id, String pw) {
		MemberDTO memberDTO = new MemberDTO();
		memberDTO.setId(id);
		memberDTO.setPw(pw);
		memberDTO.setSeq(memberDAO.readOne(memberDTO));
		return memberDTO;
	}
}
