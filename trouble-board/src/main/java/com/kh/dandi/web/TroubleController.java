package com.kh.dandi.web;

import com.kh.dandi.domain.common.file.svc.UploadFileSVC;
import com.kh.dandi.domain.common.paging.FindCriteria;
import com.kh.dandi.domain.entity.UploadFile;
import com.kh.dandi.domain.troubleBoard.dao.Trouble;
import com.kh.dandi.domain.troubleBoard.dao.TroubleFilter;
import com.kh.dandi.domain.troubleBoard.svc.TroubleSVC;
import com.kh.dandi.web.common.AttachFileType;
import com.kh.dandi.web.form.trouble.DetailForm;
import com.kh.dandi.web.form.trouble.ListForm;
import com.kh.dandi.web.form.trouble.SaveForm;
import com.kh.dandi.web.form.trouble.UpdateForm;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.thymeleaf.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Slf4j
@Controller
@RequestMapping("/trouble")
@RequiredArgsConstructor
public class TroubleController {

  private final TroubleSVC troubleSVC;

  private final UploadFileSVC uploadFileSVC;

  @Autowired
  @Qualifier("fc10") //동일한 타입의 객체가 여러개있을때 빈이름을 명시적으로 지정해서 주입받을때
  private FindCriteria fc;


  // 등록양식
  @GetMapping("/add")
  public String saveForm(Model model){
    model.addAttribute("saveForm", new SaveForm());
    return "trouble/saveForm";
  }

  // 등록처리
  @PostMapping("/add")
  public String save(
      @Valid @ModelAttribute SaveForm saveForm,
      BindingResult bindingResult,
      RedirectAttributes redirectAttributes
    ){
    log.info("saveForm={}", saveForm);

    // 데이터 검증
    // 어노테이션 기반 검증
    if (bindingResult.hasErrors()){
      log.info("bindingResult={}", bindingResult);
      return "trouble/saveForm";
    }

    // 등록
    Trouble trouble = new Trouble();
//    trouble.setTId(saveForm.getTId());
    trouble.setNickname(saveForm.getNickname());
    trouble.setEmail(saveForm.getEmail());
    trouble.setTCategory(saveForm.getTCategory());
    trouble.setContract(saveForm.getContract());
    trouble.setWage(saveForm.getWage());
    trouble.setWon(saveForm.getWon());
    trouble.setHours(saveForm.getHours());
    trouble.setMonth(saveForm.getMonth());
    trouble.setYear(saveForm.getYear());
    trouble.setTitle(saveForm.getTitle());
    trouble.setTContent(saveForm.getTContent());

    List<UploadFile> imageFiles = uploadFileSVC.convert(saveForm.getImageFiles(), AttachFileType.F0101);

    Long saveId = troubleSVC.save(trouble, imageFiles);
    redirectAttributes.addAttribute("tId", saveId);

    return "redirect:/trouble/{tId}/detail";
  }

  // 조회
  @GetMapping("/{tId}/detail")
  public String findById(
          @PathVariable("tId") Long tId,
          Model model
  ){
    Optional<Trouble> findedTrouble = troubleSVC.findById(tId);
    Trouble trouble = findedTrouble.orElseThrow();

    DetailForm detailForm = new DetailForm();
    detailForm.setTId(trouble.getTId());
    detailForm.setNickname(trouble.getNickname());
    detailForm.setEmail(trouble.getEmail());
    detailForm.setTCategory(trouble.getTCategory());
    detailForm.setContract(trouble.getContract());
    detailForm.setWage(trouble.getWage());
    detailForm.setWon(trouble.getWon());
    detailForm.setHours(trouble.getHours());
    detailForm.setMonth(trouble.getMonth());
    detailForm.setYear(trouble.getYear());
    detailForm.setTitle(trouble.getTitle());
    detailForm.setTContent(trouble.getTContent());
    detailForm.setHit(trouble.getHit());
    detailForm.setCDate(trouble.getCDate());

    log.info("tId={}",tId);

//    List<UploadFile> imagedFiles = uploadFileSVC.findFilesByCodeWithRid(AttachFileType.F0101,tId);
//    detailForm.setImagedFiles(imagedFiles);

    //첨부파일조회
    List<UploadFile> imagedFiles = uploadFileSVC.findFilesByCodeWithRid(AttachFileType.F0101, tId);
    if(imagedFiles.size() > 0){
      log.info("ImagedFiles={}",imagedFiles);
      model.addAttribute("imagedFiles",imagedFiles);
    }

    model.addAttribute("detailForm", detailForm);
    return "trouble/detailForm";
  }

//   수정양식
  @GetMapping("/{tId}/edit")
  public String updateForm(
          @PathVariable("tId") Long tId,
          Model model
  ){
    Optional<Trouble> findedTrouble = troubleSVC.findById(tId);
    Trouble trouble = findedTrouble.orElseThrow();

    UpdateForm updateForm = new UpdateForm();
    updateForm.setNickname(trouble.getNickname());
    updateForm.setEmail(trouble.getEmail());
    updateForm.setTCategory(trouble.getTCategory());
    updateForm.setContract(trouble.getContract());
    updateForm.setWage(trouble.getWage());
    updateForm.setWon(trouble.getWon());
    updateForm.setHours(trouble.getHours());
    updateForm.setMonth(trouble.getMonth());
    updateForm.setYear(trouble.getYear());
    updateForm.setTitle(trouble.getTitle());
    updateForm.setTContent(trouble.getTContent());

    model.addAttribute("updateForm", updateForm);

    //첨부파일조회
    List<UploadFile> imagedFiles = uploadFileSVC.findFilesByCodeWithRid(AttachFileType.F0101, tId);
    if(imagedFiles.size() > 0){
      log.info("ImagedFiles={}",imagedFiles);
      model.addAttribute("imagedFiles",imagedFiles);
    }
    model.addAttribute("tId",tId);

    return "trouble/updateForm";
  }

  // 수정
  @PostMapping("/{tId}/edit")
  public String update(
          @PathVariable("tId") Long tId,
          @Valid @ModelAttribute UpdateForm updateForm,
          BindingResult bindingResult,
          RedirectAttributes redirectAttributes
  ){
    // 데이터 검증
    if (bindingResult.hasErrors()){
      log.info("bindingResult={}", bindingResult);
      return "trouble/updateForm";
    }

    // 정상처리
    Trouble trouble = new Trouble();
    trouble.setTId(tId);
    trouble.setNickname(updateForm.getNickname());
    trouble.setEmail(updateForm.getEmail());
    trouble.setTCategory(updateForm.getTCategory());
    trouble.setContract(updateForm.getContract());
    trouble.setWage(updateForm.getWage());
    trouble.setWon(updateForm.getWon());
    trouble.setHours(updateForm.getHours());
    trouble.setMonth(updateForm.getMonth());
    trouble.setYear(updateForm.getYear());
    trouble.setTitle(updateForm.getTitle());
    trouble.setTContent(updateForm.getTContent());

    troubleSVC.update(tId, trouble);

    redirectAttributes.addAttribute("tId", tId);
    return "redirect:/trouble/{tId}/detail";
  }

  // 삭제
  @GetMapping("/{tId}/del")
  public String deleteById(@PathVariable("tId") Long tId){

    troubleSVC.delete(tId);

    return "redirect:/trouble";
  }

  //목록
//  @GetMapping
//  public String findAll(Model model){
//    List<Trouble> troubles = troubleSVC.findAll();
//    model.addAttribute("troubles", troubles);
//    if (troubles.size() == 0) {
////      throw new BizException("등록된 상품정보가 없습니다");
//    }
//    return "trouble/all";
//  }

  // 검색...........


  @GetMapping({"/list",
          "/list/{reqPage}",
          "/list/{reqPage}//",
          "/list/{reqPage}/{searchType}/{keyword}"})
  public String listAndReqPage(
          @PathVariable(required = false) Optional<Integer> reqPage,
          @PathVariable(required = false) Optional<String> searchType,
          @PathVariable(required = false) Optional<String> keyword,
          @RequestParam(required = false) Optional<String> category,
          Model model) {
    log.info("/list 요청됨{},{},{},{}",reqPage,searchType,keyword,category);

    String cate = getCategory(category);

    //FindCriteria 값 설정
    fc.getRc().setReqPage(reqPage.orElse(1)); //요청페이지, 요청없으면 1
    fc.setSearchType(searchType.orElse(""));  //검색유형
    fc.setKeyword(keyword.orElse(""));        //검색어

    List<Trouble> list = null;
    //게시물 목록 전체
    if(category == null || StringUtils.isEmpty(cate)) {

      //검색어 있음
      if(searchType.isPresent() && keyword.isPresent()){
        TroubleFilter filterCondition = new TroubleFilter(
                "",fc.getRc().getStartRec(), fc.getRc().getEndRec(),
                searchType.get(),
                keyword.get());
        fc.setTotalRec(troubleSVC.totalCount(filterCondition));
        fc.setSearchType(searchType.get());
        fc.setKeyword(keyword.get());
        list = troubleSVC.findAll(filterCondition);

        //검색어 없음
      }else {
        //총레코드수
        fc.setTotalRec(troubleSVC.totalCount());
        list = troubleSVC.findAllPaging(fc.getRc().getStartRec(), fc.getRc().getEndRec());
      }

      //카테고리별 목록
    }else{
      //검색어 있음
      if(searchType.isPresent() && keyword.isPresent()){
        TroubleFilter filterCondition = new TroubleFilter(
                category.get(),fc.getRc().getStartRec(), fc.getRc().getEndRec(),
                searchType.get(),
                keyword.get());
        fc.setTotalRec(troubleSVC.totalCount(filterCondition));
        fc.setSearchType(searchType.get());
        fc.setKeyword(keyword.get());
        list = troubleSVC.findAll(filterCondition);
        //검색어 없음
      }else {
        fc.setTotalRec(troubleSVC.totalCount(cate));
        list = troubleSVC.findAll(cate, fc.getRc().getStartRec(), fc.getRc().getEndRec());
      }
    }

    List<ListForm> partOfList = new ArrayList<>();
    for (Trouble trouble : list) {
      ListForm listForm = new ListForm();
      BeanUtils.copyProperties(trouble, listForm);
      partOfList.add(listForm);
    }

    model.addAttribute("list", partOfList);
    model.addAttribute("fc",fc);
    model.addAttribute("category", cate);

    return "bbs/list";
  }

  //쿼리스트링 카테고리 읽기, 없으면 ""반환
  private String getCategory(Optional<String> category) {
    String cate = category.isPresent()? category.get():"";
    log.info("category={}", cate);
    return cate;
  }


  //구인글 목록 페이징
  @GetMapping({"", "/{reqPage}", "/{reqPage}//"})
  public String listPaging(
          @PathVariable(required = false) Optional<Integer> reqPage,
          Model model
  ) {

    fc.getRc().setReqPage(reqPage.orElse(1));
    fc.setTotalRec(troubleSVC.totalCount());
    List<Trouble> troubleListsPaging = troubleSVC.findAllPaging(fc.getRc().getStartRec(), fc.getRc().getEndRec());

    List<ListForm> partOfList = new ArrayList<>();
    for (Trouble trouble : troubleListsPaging) {
      ListForm listForm = new ListForm();
      BeanUtils.copyProperties(trouble, listForm);
      partOfList.add(listForm);
    }
    model.addAttribute("troubleLists", partOfList);
    model.addAttribute("fc", fc);

    return "trouble/all";
  }
}
