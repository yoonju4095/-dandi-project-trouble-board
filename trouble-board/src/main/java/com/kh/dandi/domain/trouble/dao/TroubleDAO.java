package com.kh.dandi.domain.trouble.dao;

import java.util.List;
import java.util.Optional;

public interface TroubleDAO {

  // 고민 등록
  Long save(Trouble trouble);

  // 고민 조회
  Optional<Trouble> findById(Long tId);

  // 고민 수정
  int update(Long tId, Trouble trouble);

  // 고민 삭제
  int delete(Long tId);

  // 고민 목록
  List<Trouble> findAll();

  List<Trouble> findAll(String category);

  List<Trouble> findAllPaging(int startRec, int endRec);
  List<Trouble> findAll(String tCategory, int startRec, int endRec);

  // 고민 검색
  List<Trouble> findAll(TroubleFilter troubleFilter);

  // 조회수 증가
  int updateHit(Long tId);

  // 등록된 고민 건수
//  int countOfRecord();


//  전체건수
  int totalCount();
  int totalCount(String tCategory);
  int totalCount(TroubleFilter troubleFilter);
}
