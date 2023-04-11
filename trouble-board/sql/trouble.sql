-------
--게시판
-------
drop TABLE trouble_board;
drop sequence trouble_board_t_id_seq;

create table trouble_board(
t_id            number(10),         --게시글 번호
nickname        varchar2(30),       --닉네임
email           varchar2(50),       --이메일
t_category      varchar2(11),       --분류카테고리
contract        varchar2(10),       --근로계약서
wage            varchar2(10),       --계약임금
hours           varchar2(10),       --근무시간
title           varchar2(150),      --제목
t_content       clob,               --본문
hit             number(5) default 0,  --조회수
ptrouble_id     number(10),         --부모 게시글번호
bgroup          number(10),         --답글그룹
step            number(3) default 0,   --답글단계
bindent         number(3) default 0,   --답글들여쓰기
status          char(1),               --답글상태  (삭제: 'D', 임시저장: 'I')
cdate           timestamp default systimestamp,      --생성일시
udate           timestamp default systimestamp       --수정일시
);

--기본키
alter table trouble_board add Constraint trouble_board_t_id_pk primary key (t_id);

--제약조건
--alter table trouble_board modify t_category constraint trouble_board_t_category_nn not null;
alter table trouble_board modify title constraint trouble_board_title_nn not null;
--alter table trouble_board modify email constraint trouble_board_email_nn not null;
--alter table trouble_board modify nickname constraint trouble_board_nickname_nn not null;
alter table trouble_board modify hit constraint trouble_board_hit_nn not null;
alter table trouble_board modify t_content constraint trouble_board_t_content_nn not null;

--시퀀스
create sequence trouble_board_t_id_seq
start with 1
increment by 1
minvalue 0
maxvalue 99999999
nocycle;

desc trouble_board;

commit;

select * from trouble_board;