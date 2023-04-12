package com.kh.dandi.dao;

import lombok.extern.slf4j.Slf4j;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Optional;

@Slf4j
@SpringBootTest
public class TroubleDAOImplTest {

  @Autowired
  private TroubleDAO troubleDAO;

  // 등록
  @Test
  @Order(1)
  @DisplayName("고민등록")
  void save(){
    Trouble trouble = new Trouble();

    trouble.setTitle("타이틀");
    trouble.setTContent("내용");

    Long save = troubleDAO.save(trouble);
  }

  //수정
  @Test
  @Order(2)
  @DisplayName("고민수정")
  void update(){
    Long tId = 1L;
    Trouble trouble = new Trouble();
    trouble.setTitle("제목22");
    trouble.setTContent("내용22");
    trouble.setTCategory("dd");
    int updatedRowCount = troubleDAO.update(tId, trouble);
    Optional<Trouble> findedTrouble = troubleDAO.findById(tId);

    Assertions.assertThat(updatedRowCount).isEqualTo(1);
    Assertions.assertThat(findedTrouble.get().getTitle()).isEqualTo(trouble.getTitle());
    Assertions.assertThat(findedTrouble.get().getTContent()).isEqualTo(trouble.getTContent());
  }
}
