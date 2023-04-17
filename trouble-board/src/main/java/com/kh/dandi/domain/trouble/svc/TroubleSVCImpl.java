package com.kh.dandi.domain.trouble.svc;

import com.kh.dandi.domain.common.file.svc.UploadFileSVC;
import com.kh.dandi.domain.entity.UploadFile;
import com.kh.dandi.domain.trouble.dao.Trouble;
import com.kh.dandi.domain.trouble.dao.TroubleDAO;
import com.kh.dandi.domain.trouble.dao.TroubleFilter;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TroubleSVCImpl implements TroubleSVC {

  private final TroubleDAO troubleDAO;

  private final UploadFileSVC uploadFileSVC;


  @Override
  public Long save(Trouble trouble) {
    return troubleDAO.save(trouble);
  }

  @Transactional
  @Override
  public Long save(Trouble trouble, List<UploadFile> uploadFiles) {
//    entityManager.persist(bbsh);
//    Long bbshId = bbsh.getBbshId();
//    if(uploadFiles.size() > 0) {
//      uploadFiles.stream().forEach(file -> file.setRid(bbshId));
//      uploadFileSVC.addFiles(uploadFiles);
//    }
//    return bbshId;
    Long tId = save(trouble);
    if(uploadFiles.size() > 0) {
      uploadFiles.stream().forEach(file-> file.setRid(tId));
      uploadFileSVC.addFiles(uploadFiles);
    }
    return tId;
  }

  @Override
  public Optional<Trouble> findById(Long tId) {
    Optional<Trouble> trouble = troubleDAO.findById(tId);
    troubleDAO.updateHit(tId);
    return trouble;
  }

  @Override
  public List<Trouble> findAll() {
    return troubleDAO.findAll();
  }

  @Override
  public List<Trouble> findAllPaging(int startRec, int endRec) {
    return troubleDAO.findAllPaging(startRec, endRec);
  }

  @Override
  public List<Trouble> findAll(String category, int startRec, int endRec) {
    return troubleDAO.findAll(category,startRec,endRec);
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


//  조회수
  @Override
  public int increaseHit(Long tId) { return troubleDAO.updateHit(tId); }

//  전체건수
  @Override
  public int totalCount() {
    return troubleDAO.totalCount();
  }

  @Override
  public int totalCount(String bcategory) {
    return troubleDAO.totalCount(bcategory);
  }

  @Override
  public int totalCount(TroubleFilter troubleFilter) {
    return troubleDAO.totalCount(troubleFilter);
  }
}
