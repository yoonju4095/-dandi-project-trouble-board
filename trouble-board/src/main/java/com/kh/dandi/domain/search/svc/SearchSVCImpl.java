package com.kh.dandi.domain.search.svc;

import com.kh.dandi.domain.search.dao.SearchDAO;
import com.kh.dandi.domain.troubleBoard.dao.Trouble;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class SearchSVCImpl implements SearchSVC {

  private final SearchDAO searchDAO;

  @Override
  public List<Trouble> searchWord(String keyword, int startRec, int endRec) {
    return searchDAO.searchWord(keyword,startRec,endRec);
  }
}
