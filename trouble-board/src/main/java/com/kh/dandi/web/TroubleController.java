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
    trouble.setTId(saveForm.getTId());
//    trouble.setTCategory(saveForm.getTCategory());
    trouble.setTitle(saveForm.getTitle());
//    trouble.setEmail(saveForm.getEmail());
//    trouble.setNickname(saveForm.getNickname());
//    trouble.setHit(saveForm.getHit());
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
//    detailForm.setTCategory(trouble.getTCategory());
    detailForm.setTitle(trouble.getTitle());
//    detailForm.setEmail(trouble.getEmail());
//    detailForm.setNickname(trouble.getNickname());
//    detailForm.setHit(trouble.getHit());
    detailForm.setTContent(trouble.getTContent());

    model.addAttribute("detailForm", detailForm);
    return "trouble/detailForm";
  }

//   수정양식
  @GetMapping("/{id}/edit")
  public String updateForm(
          @PathVariable("id") Long id,
          Model model
  ){
    Optional<Trouble> findedTrouble = troubleSVC.findById(id);
    Trouble notice = findedTrouble.orElseThrow();

    UpdateForm updateForm = new UpdateForm();
    updateForm.setTitle(notice.getTitle());
//    updateForm.setContent(notice.getContent());

    model.addAttribute("updateForm", updateForm);
    return "trouble/updateForm";
  }

  // 수정
  @PostMapping("/{id}/edit")
  public String update(
          @PathVariable("id") Long id,
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
//    notice.setId(id);
    trouble.setTitle(updateForm.getTitle());
//    notice.setContent(updateForm.getContent());

    troubleSVC.update(id, trouble);

    redirectAttributes.addAttribute("id", id);
    return "redirect:/trouble/{id}/detail";
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
