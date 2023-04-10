package com.kh.dandi.svc;

import com.kh.dandi.dao.Trouble;
import com.kh.dandi.dao.TroubleDAO;
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
    return troubleDAO.findById(tId);
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
}
