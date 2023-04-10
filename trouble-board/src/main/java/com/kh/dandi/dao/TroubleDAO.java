package com.kh.dandi.dao;

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

}
