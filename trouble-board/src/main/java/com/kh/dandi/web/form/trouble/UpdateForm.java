package com.kh.dandi.web.form.trouble;

import lombok.Data;

@Data
public class UpdateForm {
  private Long tId;
  private String tCategory;
  private String title;
  private String email;
  private String nickname;
  private Long hit;
  private String tContent;
//  private Long pTroubleId;
//  private Long bGroup;
//  private Long step;
//  private Long bindent;
//  private String status;
//  private Long cDate;
//  private Long uDate;
}
