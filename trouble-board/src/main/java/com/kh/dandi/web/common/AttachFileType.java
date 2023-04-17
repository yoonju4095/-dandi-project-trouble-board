package com.kh.dandi.web.common;

public enum AttachFileType {

F0101("고민게시판 이미지");

  private String description;

  AttachFileType(String description) {
    this.description = description;
  }

  public String getDescription() {
    return description;
  }
}
