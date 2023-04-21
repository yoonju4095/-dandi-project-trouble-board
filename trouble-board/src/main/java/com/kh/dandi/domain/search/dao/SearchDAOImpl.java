package com.kh.dandi.domain.search.dao;

import com.kh.dandi.domain.troubleBoard.dao.Trouble;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;

import java.util.List;

@Slf4j
@Repository
@RequiredArgsConstructor
public class SearchDAOImpl implements SearchDAO {

  private final NamedParameterJdbcTemplate template;

  //검색-텍스트 입력
  @Override
  public List<Trouble> searchWord(String keyword, int startRec, int endRec) {
    StringBuffer sql = new StringBuffer();
    sql.append(" select t2.* ");
    sql.append(" from(select rownum no, t_id, ");
    sql.append(" nickname, email, ");
    sql.append(" t_category, contract, wage, ");
    sql.append(" won, hours, month, year, ");
    sql.append(" title, t_content, hit, cdate ");
    sql.append(" from trouble_board ");
    sql.append(" where title like '%'||:keyword||'%'");
    sql.append(" order by t_id DESC) t2 ");
    sql.append(" where no between :startRec and :endRec ");

    try {
      SqlParameterSource param = new MapSqlParameterSource()
        .addValue("keyword", keyword)
        .addValue("startRec", startRec)
        .addValue("endRec", endRec);

      List<Trouble> searchWordAll = template.query(
        sql.toString(),
        param,
        BeanPropertyRowMapper.newInstance(Trouble.class)
      );

      return searchWordAll;
    } catch (EmptyResultDataAccessException e) {

      return null;
    }
  }



}
