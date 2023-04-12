package com.kh.dandi.svc;

import com.kh.dandi.dao.Trouble;

import java.util.List;
import java.util.Optional;

public interface TroubleSVC {

  // 등록
  Long save(Trouble trouble);

  // 조회
  Optional<Trouble> findById(Long tId);

  // 수정
  int update(Long tId, Trouble trouble);

  // 삭제
  int delete(Long tId);

  // 목록
  List<Trouble> findAll();

  //조회수증가
  int increaseHit(Long tId);

}
