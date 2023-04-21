package com.kh.dandi.domain.search.dao;

import com.kh.dandi.domain.troubleBoard.dao.Trouble;

import java.util.List;

public interface SearchDAO {

  //검색
  List<Trouble> searchWord(String keyword, int startRec, int endRec);
}
