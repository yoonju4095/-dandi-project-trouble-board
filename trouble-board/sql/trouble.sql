-------
--게시판
-------
drop TABLE trouble_board;
drop sequence trouble_board_t_id_seq;

create table trouble_board(
t_id            number(10),         --게시글 번호
nickname        varchar2(30),       --닉네임
email           varchar2(50),       --이메일
t_category      varchar2(30),       --분류카테고리
contract        varchar2(30),       --근로계약서
wage            varchar2(20),       --계약임금
won             varchar2(20),       --원
hours           varchar2(20),       --근무시간
month           varchar2(20),       --개월
year            varchar2(20),       --년
title           varchar2(150),      --제목
t_content       clob,               --본문
hit             number(5) default 0,  --조회수
--ptrouble_id     number(10),         --부모 게시글번호
--bgroup          number(10),         --답글그룹
--step            number(3) default 0,   --답글단계
--bindent         number(3) default 0,   --답글들여쓰기
--status          char(1),               --답글상태  (삭제: 'D', 임시저장: 'I')
cdate           timestamp default systimestamp,      --생성일시
udate           timestamp default systimestamp       --수정일시
);

--기본키
alter table trouble_board add Constraint trouble_board_t_id_pk primary key (t_id);

--제약조건
alter table trouble_board modify t_category constraint trouble_board_t_category_nn not null;
alter table trouble_board modify title constraint trouble_board_title_nn not null;
alter table trouble_board modify email constraint trouble_board_email_nn not null;
alter table trouble_board modify nickname constraint trouble_board_nickname_nn not null;
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

insert into notice (id, title, content, hit, cdate, udate,)
values(notice_id_seq.nextval, '제목2', '내용2', '2', '23/04/09', '23/04/09');

--샘플데이터
insert into trouble_board (t_id, nickname, email, t_category, contract, wage, hours, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '카피바라', 'test1@test.com', '기타', '작성함', '시급', '2', '근로계약서 위반 사항 맞나요?',
'근로계약서에는 토요일 저녁근무, 일요일 오후근무 주말근무인데 제가 일이 서투르다는 이유로 목요일,일요일에 일 시키시다가 갑자기 또 한 번은 화요일 일요일에 일하라고 하시고
일요일은 원래 오후1시부터 일하는건데 또 오전에 일하라고 스케줄을 변경하셨거든요 후에 제가 일을 못한다고 잘랐습니다.
또 계약서엔 6시간 근무인데 한 번만 6시간 일 시키시고 나머지는 5시간 일하게 시키셨습니다. 근무 시키고 이거 근로계약서 위반인가요?', 5);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, hours, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '고등어', 'test2@test.com', '폭행', '작성안함', '월급', '7', '식당 서빙으로 일주일 출근하고 몸이 안좋아져서',
'한식당 홀서빙으로 일주일 출근하고 무거운걸 계속 들다보니 허리가 안좋아져서 디스크와서(예전에 급성디스크와서 한달가까이 못걷고 세달치료 받은적이있음)
오늘까지만 하고 관두겠다고 못하겠다고 했더니 디스크는 누구나 있다면서 안된다고 5월중순까지는 나오라고합니다
면접볼때 사장님이 관두게되면 한달전에 말해달라고 하긴했지만 일주일 해보고 너무힘들고 몸이아픈데 꼭 5월까지 아픈거 버텨가면서 나와야하나요
내일부터 도저히 안되겠다 못나온다고하면 이틀 더출근한거까지해서 8일치 월급은 못받는건가요', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, hours, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '고양이', 'test3@test.com', '임금', '작성안함', '월급', '6', '이럴 땐 실업급여 대상이 되나요?',
'1년 4개월동안 카페에서 일을 했고 하루 근무 8시간 휴게 1시간 총 9시간 정직원으로 근무했습니다
바로 말씀 드리자면 점주와 갈등이 있어 그만두게 되었습니다
2월까지 하겠다고 직원들과 말만 하고 따로 점주님께 보고는 안 드렸습니다 사람이 안 구해지고 그래서 연장했습니다
결국 5월31일까지 하겠다고 점주님께 말씀 드렸더니 안된다 본인이 서비스엉망이기에 업장에 방해된다고 3월31일까지 하라고 통보받았습니다
카카오톡으로 했기에 증거자료는 가지고 있습니다 근데 다만 제가 사직서에 개인 사유로 퇴사한다고 사인을 해버렸기에 받을 수 있는지
이게 권고사직인지 자진퇴사인지 궁금해서 글 적어봅니다 판단 부탁드려요 다들 권고사직이라고 하는데 저는 살짝 애매해서요
', 1);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, hours, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '오소리', 'test4@test.com', '임금', '작성안함', '시급', '5',
'주휴수당 유무', '안녕하세요! 혹시 2월 말부터 알바를 하는데 월(4) 목(5) 토(5) 일(5)해서 주에 19시간 일하고 있고 시급은 1만원 받고있습니다.
근로계약서 작성안했고 주휴수당 관련 얘기 없으셔서 그냥 월급날 시급의 20%를 주시나보다 생각했는데 딱 시급만큼만 계산해서 들어왔습니다.
이 경우 2달 치 주휴수당을 요구하면 받을 수 있나요? 받는다면 갑자기 최저시급의 20%에서 1만원을 뺀 1500원×시간만큼 준다고 할 수도 있나요?
시급 1만원의 20%인 2000원 만큼 주휴수당으로 받아야 하나요?? 받아야할 걸 당당히 요구해야 하는데 갈등생길까 봐 좀 걱정되네요.', 1);

commit;

select * from trouble_board;

select count(*) from trouble_board where t_id = 2;
update trouble_board set hit = 5 where t_id = 2;