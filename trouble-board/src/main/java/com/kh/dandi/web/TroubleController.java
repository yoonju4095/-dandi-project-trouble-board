package com.kh.dandi.web;

import com.kh.dandi.dao.Trouble;
import com.kh.dandi.svc.TroubleSVC;
import com.kh.dandi.web.form.trouble.DetailForm;
import com.kh.dandi.web.form.trouble.SaveForm;
import com.kh.dandi.web.form.trouble.UpdateForm;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Slf4j
@Controller
@RequestMapping("/trouble")
@RequiredArgsConstructor
public class TroubleController {

  private final TroubleSVC troubleSVC;

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

    Long saveId = troubleSVC.save(trouble);
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
    updateForm.setHours(trouble.getHours());
    updateForm.setTitle(trouble.getTitle());
    updateForm.setTContent(trouble.getTContent());

    model.addAttribute("updateForm", updateForm);
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
    trouble.setHours(updateForm.getHours());
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
  @GetMapping
  public String findAll(Model model){
    List<Trouble> troubles = troubleSVC.findAll();
    model.addAttribute("troubles", troubles);
    if (troubles.size() == 0) {
//      throw new BizException("등록된 상품정보가 없습니다");
    }
    return "trouble/all";
  }
}
