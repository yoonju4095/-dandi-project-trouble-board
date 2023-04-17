package com.kh.dandi.domain.trouble.svc;

import com.kh.dandi.domain.entity.UploadFile;
import com.kh.dandi.domain.trouble.dao.Trouble;
import com.kh.dandi.domain.trouble.dao.TroubleFilter;

import java.util.List;
import java.util.Optional;

public interface TroubleSVC {

  // 등록
  Long save(Trouble trouble);

  Long save(Trouble trouble, List<UploadFile> uploadFiles);

  // 조회
  Optional<Trouble> findById(Long tId);

  // 수정
  int update(Long tId, Trouble trouble);

  // 삭제
  int delete(Long tId);

  // 목록
  List<Trouble> findAll();

  List<Trouble> findAllPaging(int startRec, int endRec);

  List<Trouble>  findAll(String category,int startRec, int endRec);

  // 검색
  List<Trouble> findAll(TroubleFilter troubleFilter);

  //조회수증가
  int increaseHit(Long tId);

  //전체건수
  int totalCount();
  int totalCount(String bcategory);
  int totalCount(TroubleFilter troubleFilter);

}
