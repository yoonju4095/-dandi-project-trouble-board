package com.kh.dandi.domain.trouble.svc;

import com.kh.dandi.domain.trouble.dao.Trouble;
import com.kh.dandi.domain.trouble.dao.TroubleDAO;
import com.kh.dandi.domain.trouble.dao.TroubleFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TroubleSVCImpl implements TroubleSVC {

  private final TroubleDAO troubleDAO;

  @Override
  public Long save(Trouble trouble) {
    return troubleDAO.save(trouble);
  }

  @Override
  public Optional<Trouble> findById(Long tId) {
    Optional<Trouble> trouble = troubleDAO.findById(tId);
    troubleDAO.updateHit(tId);
    return trouble;
  }

  @Override
  public List<Trouble> findAll(TroubleFilter troubleFilter) {
    return troubleDAO.findAll(troubleFilter);
  }

  @Override
  public int update(Long tId, Trouble trouble) {
    return troubleDAO.update(tId, trouble);
  }

  @Override
  public int delete(Long tId) {
    return troubleDAO.delete(tId);
  }

  @Override
  public List<Trouble> findAll() {
    return troubleDAO.findAll();
  }

  @Override
  public int increaseHit(Long tId) { return troubleDAO.updateHit(tId); }
}
