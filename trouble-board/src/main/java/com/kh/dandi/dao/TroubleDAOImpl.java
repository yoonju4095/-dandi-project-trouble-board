package com.kh.dandi.dao;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.namedparam.BeanPropertySqlParameterSource;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Slf4j
@Repository
@RequiredArgsConstructor
public class TroubleDAOImpl implements TroubleDAO {

  private final NamedParameterJdbcTemplate template;

  /**
   * 등록
   *
   * @param trouble
   * @return
   */
  @Override
  public Long save(Trouble trouble) {

    StringBuffer sb = new StringBuffer();
    sb.append("insert into trouble_board(t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content) ");
    sb.append("values(trouble_board_t_id_seq.nextval, :nickname, :email, :tCategory, :contract, :wage, :won, :hours, :month, :year, :title, :tContent) ");

    SqlParameterSource param = new BeanPropertySqlParameterSource(trouble);
    KeyHolder keyHolder = new GeneratedKeyHolder();
    template.update(sb.toString(),param,keyHolder,new String[]{"t_id"});

    long tId = keyHolder.getKey().longValue(); // 게시글 번호

    return tId;
  }

  /**
   * @param tId
   * @return
   */
  @Override
  public Optional<Trouble> findById(Long tId) {
    StringBuffer sb = new StringBuffer();
    sb.append("select t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, cdate");
    sb.append("  from trouble_board ");
    sb.append(" where t_id = :t_id ");

    try {
      Map<String, Long> param = Map.of("t_id", tId);

      Trouble trouble = template.queryForObject(
              sb.toString(), param, BeanPropertyRowMapper.newInstance(Trouble.class)
      );
      return Optional.of(trouble);
    }catch (EmptyResultDataAccessException e){
      return Optional.empty();
    }
  }

  /**
   * @param tId
   * @param trouble
   * @return
   */
  @Override
  public int update(Long tId, Trouble trouble) {
    StringBuffer sb = new StringBuffer();
    sb.append("update trouble_board ");
    sb.append("   set nickname = :nickname, ");
    sb.append("       email = :email, ");
    sb.append("       t_category = :tCategory, ");
//    sb.append("       contract = :contract, ");
    sb.append("       wage = :wage, ");
    sb.append("       hours = :hours, ");
    sb.append("       title = :title, ");
    sb.append("       t_content = :tContent ");
//    sb.append("       hit = :hit");
//    sb.append("       ptrouble_id = :ptroubleId");
//    sb.append("       bgroup = :bGroup");
//    sb.append("       step = :step");
//    sb.append("       bindent = :bindent");
//    sb.append("       status = :status");
//    sb.append("       cdate = :cdate");
//    sb.append("       udate = :udate");
    sb.append(" where t_id = :tId ");

    SqlParameterSource param = new MapSqlParameterSource()
            .addValue("nickname", trouble.getNickname())
            .addValue("email",trouble.getEmail())
            .addValue("tCategory", trouble.getTCategory())
            .addValue("contract", trouble.getContract())
            .addValue("wage", trouble.getWage())
            .addValue("hours", trouble.getHours())
            .addValue("title", trouble.getTitle())
            .addValue("tContent", trouble.getTContent())
            .addValue("tId", tId);
//            .addValue("hit", trouble.getHit())
//            .addValue("ptroubleId", trouble.getPtroubleId())
//            .addValue("bGroup", trouble.getBGroup())
//            .addValue("step", trouble.getStep())
//            .addValue("status", trouble.getStatus())
//            .addValue("cdate", trouble.getCDate())
//            .addValue("udate", trouble.getUDate());

    return template.update(sb.toString(),param);
  }

  /**
   * @param tId
   * @return
   */
  @Override
  public int delete(Long tId) {
    String sql = "delete from trouble_board where t_id = :t_id ";
    return template.update(sql,Map.of("t_id", tId));
  }

  /**
   * @return 고민목록
   */
  @Override
  public List<Trouble> findAll() {

    StringBuffer sb = new StringBuffer();
    sb.append("select t_id, nickname, title, hit, cdate ");
    sb.append("  from trouble_board ");

    List<Trouble> list = template.query(
            sb.toString(),
            BeanPropertyRowMapper.newInstance(Trouble.class)  // 레코드 컬럼과 자바객체 멤버필드가 동일한 이름일경우, camelcase지원
    );

    return list;
  }

  /**
   * @return 조회수
   */
  @Override
  public int updateHit(Long tId) {
    String sql = "update trouble_board set hit = NVL(hit, 0) + 1 where t_id = :tId ";
    MapSqlParameterSource params = new MapSqlParameterSource();
    params.addValue("tId", tId);

    // id에 해당하는 레코드가 notice 테이블에 존재하는지 확인
    String checkSql = "select count(*) from trouble_board where t_id = :tId ";
    int count = template.queryForObject(checkSql, params, Integer.class);
    if (count == 0) {
      throw new IllegalArgumentException("tId not found in trouble_board table");
    }

    int affectedRows = template.update(sql, params);
    return affectedRows;
  }

  /**
   * @return 고민 건수
   */
  @Override
  public int countOfRecord() {
    String sql = "select count(*) from trouble_board ";
    Map<String,String> param = new LinkedHashMap<>();
    Integer rows = template.queryForObject(sql, param, Integer.class);
    return rows;
  }

  //수동 매핑
//  private RowMapper<Trouble> noticeRowMapper() {
//    return (rs, rowNum) -> {
//      Trouble notice = new Trouble();
//      notice.setId(rs.getLong("id"));
//      notice.setTitle(rs.getString("title"));
//      notice.setContent(rs.getString("content"));
//      notice.setAuthor(rs.getString("author"));
//      notice.setHit(rs.getLong("hit"));
//      notice.setCDate(rs.getLong("cdate"));
//      notice.setUDate(rs.getLong("udate"));
//      return notice;
//    };
//  }
}
