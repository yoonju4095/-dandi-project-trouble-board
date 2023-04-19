package com.kh.dandi.web.form.trouble;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Data
public class SaveForm {
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

  private List<MultipartFile> imageFiles;

//  private Long ptroubleId;
//  private Long bGroup;
//  private Long step;
//  private Long bindent;
//  private String status;
  private String cDate;
//  private Long uDate;
}
