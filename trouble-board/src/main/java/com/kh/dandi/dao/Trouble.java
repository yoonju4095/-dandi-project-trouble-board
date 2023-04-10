package com.kh.dandi.dao;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Trouble {
  private Long tId;
  private String tCategory;
  private String title;
  private String email;
  private String nickname;
  private Long hit;
  private String tContent;
  private Long ptroubleId;
  private Long bGroup;
  private Long step;
  private Long bindent;
  private String status;
  private Long cDate;
  private Long uDate;
}
