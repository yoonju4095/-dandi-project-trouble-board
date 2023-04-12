package com.kh.dandi.dao;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Trouble {
  private Long tId;
  private String nickname;
  private String email;
  private String tCategory; // 고민유형
  private String contract;  // 근로계약서
  private String wage;      // 계약임금
  private String won;       // 원
  private String hours;     // 근무시간
  private String month;     // 월
  private String year;      // 년
  private String title;
  private String tContent;
  private Long hit;

  private Long ptroubleId;
  private Long bGroup;
  private Long step;
  private Long bindent;
  private String status;
  private String cDate;
  private Long uDate;
}
