package com.blue.todo;

import lombok.Data;

@Data
public class MemberDTO {
	private int seq;
	private String id;
	private String pw;
	
	public MemberDTO() {
		this.seq = 0;
	}
}
