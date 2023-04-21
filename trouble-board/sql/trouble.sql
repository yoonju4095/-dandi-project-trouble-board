drop table CODE CASCADE CONSTRAINTS;
drop table trouble_board CASCADE CONSTRAINTS;
drop table UPLOADFILE CASCADE CONSTRAINTS;
drop sequence trouble_board_t_id_seq;
drop sequence UPLOADFILE_UPLOADFILE_ID_SEQ;

-------
--코드
-------
create table code(
    code_id     varchar2(10),       --코드
    decode      varchar2(30),       --코드명
    discript    clob,               --코드설명
--    detail      clob,               --코드설명
    pcode_id    varchar2(10),       --상위코드
    useyn       char(1) default 'Y',            --사용여부 (사용:'Y',미사용:'N')
    cdate       timestamp default systimestamp,         --생성일시
    udate       timestamp default systimestamp          --수정일시
);
--기본키
alter table code add Constraint code_code_id_pk primary key (code_id);

--제약조건
alter table code modify decode constraint code_decode_nn not null;
alter table code modify useyn constraint code_useyn_nn not null;
alter table code add constraint code_useyn_ck check(useyn in ('Y','N'));

--샘플데이터 of code
insert into code (code_id,decode,pcode_id,useyn) values ('F0101','고민게시판','B01','Y');
commit;

------------
--업로드 파일
------------
CREATE TABLE UPLOADFILE(
  UPLOADFILE_ID             NUMBER,          --파일 아이디(내부관리용)
  CODE                      varchar2(11),    --분류 코드(커뮤니티: F0101, 병원후기: F0102, 회원프로필: F0103)
  RID                       varchar2(10),    --참조번호 --해당 첨부파일이 첨부된 게시글의 순번
  STORE_FILENAME            varchar2(50),    --보관파일명
  UPLOAD_FILENAME           varchar2(50),    --업로드파일명
  FSIZE                     varchar2(45),    --파일크기
  FTYPE                     varchar2(50),    --파일유형
  CDATE                     timestamp default systimestamp, --작성일
  UDATE                     timestamp default systimestamp  --수정일
);

--기본키생성
alter table UPLOADFILE add Constraint UPLOADFILE_UPLOADFILE_ID_pk primary key (UPLOADFILE_ID);
--외래키
alter table UPLOADFILE add constraint  UPLOADFILE_CODE_fk
    foreign key(CODE) references CODE(CODE_ID);

--제약조건
alter table UPLOADFILE modify CODE constraint UPLOADFILE_CODE_nn not null;
alter table UPLOADFILE modify RID constraint UPLOADFILE_RID_nn not null;
alter table UPLOADFILE modify STORE_FILENAME constraint UPLOADFILE_STORE_FILENAME_nn not null;
alter table UPLOADFILE modify UPLOAD_FILENAME constraint UPLOADFILE_UPLOAD_FILENAME_nn not null;
-- not null 제약조건은 add 대신 modify 명령문 사용

--시퀀스 생성
create sequence UPLOADFILE_UPLOADFILE_ID_SEQ;

--샘플데이터 of UPLOADFILE
insert into UPLOADFILE (UPLOADFILE_ID, CODE ,RID, STORE_FILENAME, UPLOAD_FILENAME, FSIZE, FTYPE)
 values(UPLOADFILE_UPLOADFILE_ID_SEQ.NEXTVAL ,'F0101','001', 'F0101.png', '고민게시글이미지첨부1.png','100','image/png');

COMMIT;

--테이블 구조 확인
DESC UPLOADFILE;

-------
--게시판
-------
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

--샘플데이터
insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '카피바라', 'test1@test.com', '기타', '작성함', '시급', '9620', '2', '2', '', '근로계약서 위반 사항 맞나요?',
'근로계약서에는 토요일 저녁근무, 일요일 오후근무 주말근무인데 제가 일이 서투르다는 이유로 목요일,일요일에 일 시키시다가 갑자기 또 한 번은 화요일 일요일에 일하라고 하시고

일요일은 원래 오후1시부터 일하는건데 또 오전에 일하라고 스케줄을 변경하셨거든요 후에 제가 일을 못한다고 잘랐습니다.

또 계약서엔 6시간 근무인데 한 번만 6시간 일 시키시고 나머지는 5시간 일하게 시키셨습니다.

근무 시키고 이거 근로계약서 위반인가요?', 5);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '고등어', 'test2@test.com', '폭행', '작성안함', '월급', '7,500,000', '7', '2', '', '식당 서빙으로 일주일 출근하고 몸이 안좋아져서',
'한식당 홀서빙으로 일주일 출근하고 무거운걸 계속 들다보니 허리가 안좋아져서 디스크와서(예전에 급성디스크와서 한달가까이 못걷고 세달치료 받은적이있음)

오늘까지만 하고 관두겠다고 못하겠다고 했더니 디스크는 누구나 있다면서 안된다고 5월중순까지는 나오라고합니다

면접볼때 사장님이 관두게되면 한달전에 말해달라고 하긴했지만 일주일 해보고 너무힘들고 몸이아픈데 꼭 5월까지 아픈거 버텨가면서 나와야하나요

내일부터 도저히 안되겠다 못나온다고하면 이틀 더출근한거까지해서 8일치 월급은 못받는건가요', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '수달', 'test3@test.com', '임금', '작성안함', '월급', '7,400,000', '7', '5', '1', '이럴 땐 실업급여 대상이 되나요?',
'1년 4개월동안 카페에서 일을 했고 하루 근무 8시간 휴게 1시간 총 9시간 정직원으로 근무했습니다.

바로 말씀 드리자면 점주와 갈등이 있어 그만두게 되었습니다.

2월까지 하겠다고 직원들과 말만 하고 따로 점주님께 보고는 안 드렸습니다 사람이 안 구해지고 그래서 연장했습니다.

결국 5월31일까지 하겠다고 점주님께 말씀 드렸더니 안된다 본인이 서비스엉망이기에 업장에 방해된다고 3월31일까지 하라고 통보받았습니다 .

카카오톡으로 했기에 증거자료는 가지고 있습니다. 근데 다만 제가 사직서에 개인 사유로 퇴사한다고 사인을 해버렸기에 받을 수 있는지

이게 권고사직인지 자진퇴사인지 궁금해서 글 적어봅니다 판단 부탁드려요.

다들 권고사직이라고 하는데 저는 살짝 애매해서요.
', 1);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '오소리', 'test4@test.com', '임금', '작성안함', '시급', '9620', '5', '5', '',
'주휴수당 유무', '안녕하세요! 혹시 2월 말부터 알바를 하는데 월(4) 목(5) 토(5) 일(5)해서 주에 19시간 일하고 있고 시급은 1만원 받고있습니다.

근로계약서 작성안했고 주휴수당 관련 얘기 없으셔서 그냥 월급날 시급의 20%를 주시나보다 생각했는데 딱 시급만큼만 계산해서 들어왔습니다.

이 경우 2달 치 주휴수당을 요구하면 받을 수 있나요? 받는다면 갑자기 최저시급의 20%에서 1만원을 뺀 1500원×시간만큼 준다고 할 수도 있나요?

시급 1만원의 20%인 2000원 만큼 주휴수당으로 받아야 하나요?? 받아야할 걸 당당히 요구해야 하는데 갈등생길까 봐 좀 걱정되네요.', 1);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '오리너구리', 'test5@test.com', '기타', '작성함', '시급', '9620', '8', '3', '',
'새로운 점주가 휴게수당 및 사대보험 보장을 해주지 않는다고 합니다',
'안녕하세요, 편의점에서 주 5일 8시간 근무하고 있는 알바생입니다.

이번 4월 27일에 새로운 점주님이 오신다는 소식을 듣고 저를 쭉 채용하는지 물어봤을때 채용하신다고 하셨습니다.

저는 현재 점주님이 휴게시간이 없는 대신 휴게수당을 챙겨받고 있고, 4대보험도 가입해주셨습니다.

그런데 바뀔 점주분께 여쭤보니 휴게수당을 왜 주냐, 주휴수당은 주지 않을 것이고 4대보험 가입 또한 없다.

대신, 3.3%는 뗄 것이라고 하셨는데 이 부분에서 문제가 될 만한 부분은 없나요?', 12);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '타조', 'test6@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'일당 2일치를 못받았어요',
'지금 가게 직원들이 그만두기전 직원 누나가 알바할래? 라고 해서 하기 시작했는데 2일치가 밀렸거든요

근데 오늘부로 직원들이 전부 그만뒀는데 원래는 3월 31일까지 정리해준다고 하였는데 아직도 얘기도없고 직원 누나한테 물어보니까 읽씹만 하시고 ,,

그 가게 직원들은 전부 바뀌었다는데 이제 전 누구한테 돈을 받아야할까여,,,', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '타조', 'test7@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'아르바이트 중 실수로 인한 손해 배상과 임금 체불 관련 상담 요청합니다',
'개인 카페에서 디저트 생산직 아르바이트를 했습니다. 처음 면접 볼 당시에 급여는 매주 월요일에 지급하는 것으로 전달 받았고 그동안 무단퇴사하는 직원들이 많아서 이를 방지하고자 일주일씩 미뤄서 알바비를 준다고 했습니다. (현재 4/10~4/17 근무한 돈을 받지 못한 상태)

이에 동의했고 일을 잘 하다가 4/16에 제가 만든 쿠키에 공정상 문제가 생겨 생산량을 모두 폐기해야 했습니다. 재료를 잘못 넣은 것이 원인이었고 다음날에 사장님이 문제를 확인하시고 저의 책임이라며 그냥 넘어가기 어렵다고 개당 3,000원씩 총 6만원 가량을 변상하라고 하셨습니다.

저는 제 실수로 피해를 본 것이 맞긴 하나 고의성이 전혀 없었다, 다음부터 주의하겠다고 당부드렸는데 이를 거절하셨습니다. 수차례 문자와 통화가 이어졌고 전 사장님이 요청한 변상 금액에 대해 납득이 안된다고 하니 그럼 쿠키를 만든 날의 일당을 제외하는 것이 어떻겠냐 하셨습니다.

저는 그 금액에 대해서도 부담이 되긴 했으나, 이 일로 이야기가 길어져서 피로했고 그만둘 게 아니라 앞으로도 계속 일을 해야 하니 그럼 일당 정도는 포기하겠단 의사를 밝혔는데 그 다음날에 해고를 당했습니다.
', 5);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '너구리', 'test8@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'근로계약서 미작성 상태에서 퇴사',
'현재 총 6일 4시간 정도 일했습니다 대학내 근로장학생으로 선발되어서 다음달 1일부터 근무하게 되는데

일주일만에 그만두게 되는거고 지속적으로 근로계약서 쓰자고했고 사장이 미루고 미루다가 금요일날 쓰는것으로 했습니다.

결국 근로계약서도 못쓰고 퇴사하게 되는데 돈 받을수있는걸까요? 그리고 사장님한테 퇴사한다고 말했는데 근로계약서 작성하는게 맞는걸까요?

더해서 근로계약서 안쓴 시점에 어떻게 급여 받을수있는지 궁금합니다', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '너구리', 'test8@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'1년 넘게 일하고 하루 만에 해고를 당하였습니다',
'동네의 한 프랜차이즈 카페에서 주말 알바로 1년이 넘게 일하였습니다.

토요일 일요일 각각 12시부터 17시까지 근무하다가, 올해 2월쯤 가게의 매출이 안 나온다는 이유로 근무 시간이 13시부터 17시로

토요일 일요일 각각 한 시간씩 단축되어 총 주에 8시간을 근무하였습니다. 물론 근로계약서 작성 12시부터 17시까지인 상태 그대로였습니다.

4월 16일 일요일 평상시와 똑같이 근무하고 퇴근을 하였는데, 다음날에 카톡이 오기를 사장이 주변에 대형 프랜차이즈 카페가 입점하기도 하였고

매출이 너무 안나와서 근무자를 정리해야 할것 같다며 이번주부터 출근을 하지 마라는 통보를 받았습니다.

저는 전날까지도 잘 출근을 하다가 전날이 마지막 근무날이 된 것입니다.

해고를 하려면 최소 한달 전에는 통보를 해야한다고 들었는데 저같은 경우에는 해고예고수당을 받을 수 있을까요?

근무 기간은 1년이 넘었고 주당 총 근무시간은 15시간이 넘지 못한 상태입니다 답변 부탁드립니다!', 8);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '다람쥐', 'test9@test.com', '임금', '작성안함', '시급', '9620', '8', '3', '',
'처음으로 알바를 하게 되어 궁금한 것들이 있습니다',
'4/17부터 한 주(월~금) 혹은 2주간 근무하게 됩니다.

질문

1. 근무시간이 오전8시부터 오후5시까지이며 휴게 1시간이 포함되어 있습니다. 휴게시간에는 임금이 발생하지 않아 하루에 8시간치의 시급을 받게되는 것이 맞는지 궁금합니다.

2. 4대보험 과 소득세 모두 내야하는지 궁금합니다

3. 주휴수당을 받을 수 있는 근무조건으로 판단되는데, "시급에 주휴수당이 포함되어있다" 라는 말이 성립할 수 있는지 궁금합니다.', 15);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '다람쥐', 'test9@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'업주가 바뀌면서 해고당했습니다',
'한 알바생이 가게를 인수하면서 기존 알바생 모두를 해고했습니다.

‘4월2일부터 1주일동안 인수 과정이 진행되었고, 새 사장이 4월10일부터 운영을 하고 싶다고 내일(4월9일)까지만 출근하라’고 기존 사장님께 통보받았습니다.

1. 이 경우 해고예고수당을 받을 수 있나요?
1-1. 기존 사장님께 받아야 하나요?

2. 수당 대신 한달 더 일하라고 하는 경우도 있나요?

2-1. 2번을 거절해도 해고예고수당이 나오나요?', 15);


insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '카피바라', 'test1@test.com', '기타', '작성함', '시급', '9620', '2', '2', '', '근로계약서 위반 사항 맞나요?',
'근로계약서에는 토요일 저녁근무, 일요일 오후근무 주말근무인데 제가 일이 서투르다는 이유로 목요일,일요일에 일 시키시다가 갑자기 또 한 번은 화요일 일요일에 일하라고 하시고

일요일은 원래 오후1시부터 일하는건데 또 오전에 일하라고 스케줄을 변경하셨거든요 후에 제가 일을 못한다고 잘랐습니다.

또 계약서엔 6시간 근무인데 한 번만 6시간 일 시키시고 나머지는 5시간 일하게 시키셨습니다.

근무 시키고 이거 근로계약서 위반인가요?', 5);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '고등어', 'test2@test.com', '폭행', '작성안함', '월급', '7,500,000', '7', '2', '', '식당 서빙으로 일주일 출근하고 몸이 안좋아져서',
'한식당 홀서빙으로 일주일 출근하고 무거운걸 계속 들다보니 허리가 안좋아져서 디스크와서(예전에 급성디스크와서 한달가까이 못걷고 세달치료 받은적이있음)

오늘까지만 하고 관두겠다고 못하겠다고 했더니 디스크는 누구나 있다면서 안된다고 5월중순까지는 나오라고합니다

면접볼때 사장님이 관두게되면 한달전에 말해달라고 하긴했지만 일주일 해보고 너무힘들고 몸이아픈데 꼭 5월까지 아픈거 버텨가면서 나와야하나요

내일부터 도저히 안되겠다 못나온다고하면 이틀 더출근한거까지해서 8일치 월급은 못받는건가요', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '수달', 'test3@test.com', '임금', '작성안함', '월급', '7,400,000', '7', '5', '1', '이럴 땐 실업급여 대상이 되나요?',
'1년 4개월동안 카페에서 일을 했고 하루 근무 8시간 휴게 1시간 총 9시간 정직원으로 근무했습니다.

바로 말씀 드리자면 점주와 갈등이 있어 그만두게 되었습니다.

2월까지 하겠다고 직원들과 말만 하고 따로 점주님께 보고는 안 드렸습니다 사람이 안 구해지고 그래서 연장했습니다.

결국 5월31일까지 하겠다고 점주님께 말씀 드렸더니 안된다 본인이 서비스엉망이기에 업장에 방해된다고 3월31일까지 하라고 통보받았습니다 .

카카오톡으로 했기에 증거자료는 가지고 있습니다. 근데 다만 제가 사직서에 개인 사유로 퇴사한다고 사인을 해버렸기에 받을 수 있는지

이게 권고사직인지 자진퇴사인지 궁금해서 글 적어봅니다 판단 부탁드려요.

다들 권고사직이라고 하는데 저는 살짝 애매해서요.
', 1);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '오소리', 'test4@test.com', '임금', '작성안함', '시급', '9620', '5', '5', '',
'주휴수당 유무', '안녕하세요! 혹시 2월 말부터 알바를 하는데 월(4) 목(5) 토(5) 일(5)해서 주에 19시간 일하고 있고 시급은 1만원 받고있습니다.

근로계약서 작성안했고 주휴수당 관련 얘기 없으셔서 그냥 월급날 시급의 20%를 주시나보다 생각했는데 딱 시급만큼만 계산해서 들어왔습니다.

이 경우 2달 치 주휴수당을 요구하면 받을 수 있나요? 받는다면 갑자기 최저시급의 20%에서 1만원을 뺀 1500원×시간만큼 준다고 할 수도 있나요?

시급 1만원의 20%인 2000원 만큼 주휴수당으로 받아야 하나요?? 받아야할 걸 당당히 요구해야 하는데 갈등생길까 봐 좀 걱정되네요.', 1);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '오리너구리', 'test5@test.com', '기타', '작성함', '시급', '9620', '8', '3', '',
'새로운 점주가 휴게수당 및 사대보험 보장을 해주지 않는다고 합니다',
'안녕하세요, 편의점에서 주 5일 8시간 근무하고 있는 알바생입니다.

이번 4월 27일에 새로운 점주님이 오신다는 소식을 듣고 저를 쭉 채용하는지 물어봤을때 채용하신다고 하셨습니다.

저는 현재 점주님이 휴게시간이 없는 대신 휴게수당을 챙겨받고 있고, 4대보험도 가입해주셨습니다.

그런데 바뀔 점주분께 여쭤보니 휴게수당을 왜 주냐, 주휴수당은 주지 않을 것이고 4대보험 가입 또한 없다.

대신, 3.3%는 뗄 것이라고 하셨는데 이 부분에서 문제가 될 만한 부분은 없나요?', 12);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '타조', 'test6@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'일당 2일치를 못받았어요',
'지금 가게 직원들이 그만두기전 직원 누나가 알바할래? 라고 해서 하기 시작했는데 2일치가 밀렸거든요

근데 오늘부로 직원들이 전부 그만뒀는데 원래는 3월 31일까지 정리해준다고 하였는데 아직도 얘기도없고 직원 누나한테 물어보니까 읽씹만 하시고 ,,

그 가게 직원들은 전부 바뀌었다는데 이제 전 누구한테 돈을 받아야할까여,,,', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '타조', 'test7@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'아르바이트 중 실수로 인한 손해 배상과 임금 체불 관련 상담 요청합니다',
'개인 카페에서 디저트 생산직 아르바이트를 했습니다. 처음 면접 볼 당시에 급여는 매주 월요일에 지급하는 것으로 전달 받았고 그동안 무단퇴사하는 직원들이 많아서 이를 방지하고자 일주일씩 미뤄서 알바비를 준다고 했습니다. (현재 4/10~4/17 근무한 돈을 받지 못한 상태)

이에 동의했고 일을 잘 하다가 4/16에 제가 만든 쿠키에 공정상 문제가 생겨 생산량을 모두 폐기해야 했습니다. 재료를 잘못 넣은 것이 원인이었고 다음날에 사장님이 문제를 확인하시고 저의 책임이라며 그냥 넘어가기 어렵다고 개당 3,000원씩 총 6만원 가량을 변상하라고 하셨습니다.

저는 제 실수로 피해를 본 것이 맞긴 하나 고의성이 전혀 없었다, 다음부터 주의하겠다고 당부드렸는데 이를 거절하셨습니다. 수차례 문자와 통화가 이어졌고 전 사장님이 요청한 변상 금액에 대해 납득이 안된다고 하니 그럼 쿠키를 만든 날의 일당을 제외하는 것이 어떻겠냐 하셨습니다.

저는 그 금액에 대해서도 부담이 되긴 했으나, 이 일로 이야기가 길어져서 피로했고 그만둘 게 아니라 앞으로도 계속 일을 해야 하니 그럼 일당 정도는 포기하겠단 의사를 밝혔는데 그 다음날에 해고를 당했습니다.
', 5);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '너구리', 'test8@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'근로계약서 미작성 상태에서 퇴사',
'현재 총 6일 4시간 정도 일했습니다 대학내 근로장학생으로 선발되어서 다음달 1일부터 근무하게 되는데

일주일만에 그만두게 되는거고 지속적으로 근로계약서 쓰자고했고 사장이 미루고 미루다가 금요일날 쓰는것으로 했습니다.

결국 근로계약서도 못쓰고 퇴사하게 되는데 돈 받을수있는걸까요? 그리고 사장님한테 퇴사한다고 말했는데 근로계약서 작성하는게 맞는걸까요?

더해서 근로계약서 안쓴 시점에 어떻게 급여 받을수있는지 궁금합니다', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '너구리', 'test8@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'1년 넘게 일하고 하루 만에 해고를 당하였습니다',
'동네의 한 프랜차이즈 카페에서 주말 알바로 1년이 넘게 일하였습니다.

토요일 일요일 각각 12시부터 17시까지 근무하다가, 올해 2월쯤 가게의 매출이 안 나온다는 이유로 근무 시간이 13시부터 17시로

토요일 일요일 각각 한 시간씩 단축되어 총 주에 8시간을 근무하였습니다. 물론 근로계약서 작성 12시부터 17시까지인 상태 그대로였습니다.

4월 16일 일요일 평상시와 똑같이 근무하고 퇴근을 하였는데, 다음날에 카톡이 오기를 사장이 주변에 대형 프랜차이즈 카페가 입점하기도 하였고

매출이 너무 안나와서 근무자를 정리해야 할것 같다며 이번주부터 출근을 하지 마라는 통보를 받았습니다.

저는 전날까지도 잘 출근을 하다가 전날이 마지막 근무날이 된 것입니다.

해고를 하려면 최소 한달 전에는 통보를 해야한다고 들었는데 저같은 경우에는 해고예고수당을 받을 수 있을까요?

근무 기간은 1년이 넘었고 주당 총 근무시간은 15시간이 넘지 못한 상태입니다 답변 부탁드립니다!', 8);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '다람쥐', 'test9@test.com', '임금', '작성안함', '시급', '9620', '8', '3', '',
'처음으로 알바를 하게 되어 궁금한 것들이 있습니다',
'4/17부터 한 주(월~금) 혹은 2주간 근무하게 됩니다.

질문

1. 근무시간이 오전8시부터 오후5시까지이며 휴게 1시간이 포함되어 있습니다. 휴게시간에는 임금이 발생하지 않아 하루에 8시간치의 시급을 받게되는 것이 맞는지 궁금합니다.

2. 4대보험 과 소득세 모두 내야하는지 궁금합니다

3. 주휴수당을 받을 수 있는 근무조건으로 판단되는데, "시급에 주휴수당이 포함되어있다" 라는 말이 성립할 수 있는지 궁금합니다.', 15);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '다람쥐', 'test9@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'업주가 바뀌면서 해고당했습니다',
'한 알바생이 가게를 인수하면서 기존 알바생 모두를 해고했습니다.

‘4월2일부터 1주일동안 인수 과정이 진행되었고, 새 사장이 4월10일부터 운영을 하고 싶다고 내일(4월9일)까지만 출근하라’고 기존 사장님께 통보받았습니다.

1. 이 경우 해고예고수당을 받을 수 있나요?
1-1. 기존 사장님께 받아야 하나요?

2. 수당 대신 한달 더 일하라고 하는 경우도 있나요?

2-1. 2번을 거절해도 해고예고수당이 나오나요?', 15);


insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '카피바라', 'test1@test.com', '기타', '작성함', '시급', '9620', '2', '2', '', '근로계약서 위반 사항 맞나요?',
'근로계약서에는 토요일 저녁근무, 일요일 오후근무 주말근무인데 제가 일이 서투르다는 이유로 목요일,일요일에 일 시키시다가 갑자기 또 한 번은 화요일 일요일에 일하라고 하시고

일요일은 원래 오후1시부터 일하는건데 또 오전에 일하라고 스케줄을 변경하셨거든요 후에 제가 일을 못한다고 잘랐습니다.

또 계약서엔 6시간 근무인데 한 번만 6시간 일 시키시고 나머지는 5시간 일하게 시키셨습니다.

근무 시키고 이거 근로계약서 위반인가요?', 5);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '고등어', 'test2@test.com', '폭행', '작성안함', '월급', '7,500,000', '7', '2', '', '식당 서빙으로 일주일 출근하고 몸이 안좋아져서',
'한식당 홀서빙으로 일주일 출근하고 무거운걸 계속 들다보니 허리가 안좋아져서 디스크와서(예전에 급성디스크와서 한달가까이 못걷고 세달치료 받은적이있음)

오늘까지만 하고 관두겠다고 못하겠다고 했더니 디스크는 누구나 있다면서 안된다고 5월중순까지는 나오라고합니다

면접볼때 사장님이 관두게되면 한달전에 말해달라고 하긴했지만 일주일 해보고 너무힘들고 몸이아픈데 꼭 5월까지 아픈거 버텨가면서 나와야하나요

내일부터 도저히 안되겠다 못나온다고하면 이틀 더출근한거까지해서 8일치 월급은 못받는건가요', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '수달', 'test3@test.com', '임금', '작성안함', '월급', '7,400,000', '7', '5', '1', '이럴 땐 실업급여 대상이 되나요?',
'1년 4개월동안 카페에서 일을 했고 하루 근무 8시간 휴게 1시간 총 9시간 정직원으로 근무했습니다.

바로 말씀 드리자면 점주와 갈등이 있어 그만두게 되었습니다.

2월까지 하겠다고 직원들과 말만 하고 따로 점주님께 보고는 안 드렸습니다 사람이 안 구해지고 그래서 연장했습니다.

결국 5월31일까지 하겠다고 점주님께 말씀 드렸더니 안된다 본인이 서비스엉망이기에 업장에 방해된다고 3월31일까지 하라고 통보받았습니다 .

카카오톡으로 했기에 증거자료는 가지고 있습니다. 근데 다만 제가 사직서에 개인 사유로 퇴사한다고 사인을 해버렸기에 받을 수 있는지

이게 권고사직인지 자진퇴사인지 궁금해서 글 적어봅니다 판단 부탁드려요.

다들 권고사직이라고 하는데 저는 살짝 애매해서요.
', 1);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '오소리', 'test4@test.com', '임금', '작성안함', '시급', '9620', '5', '5', '',
'주휴수당 유무', '안녕하세요! 혹시 2월 말부터 알바를 하는데 월(4) 목(5) 토(5) 일(5)해서 주에 19시간 일하고 있고 시급은 1만원 받고있습니다.

근로계약서 작성안했고 주휴수당 관련 얘기 없으셔서 그냥 월급날 시급의 20%를 주시나보다 생각했는데 딱 시급만큼만 계산해서 들어왔습니다.

이 경우 2달 치 주휴수당을 요구하면 받을 수 있나요? 받는다면 갑자기 최저시급의 20%에서 1만원을 뺀 1500원×시간만큼 준다고 할 수도 있나요?

시급 1만원의 20%인 2000원 만큼 주휴수당으로 받아야 하나요?? 받아야할 걸 당당히 요구해야 하는데 갈등생길까 봐 좀 걱정되네요.', 1);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '오리너구리', 'test5@test.com', '기타', '작성함', '시급', '9620', '8', '3', '',
'새로운 점주가 휴게수당 및 사대보험 보장을 해주지 않는다고 합니다',
'안녕하세요, 편의점에서 주 5일 8시간 근무하고 있는 알바생입니다.

이번 4월 27일에 새로운 점주님이 오신다는 소식을 듣고 저를 쭉 채용하는지 물어봤을때 채용하신다고 하셨습니다.

저는 현재 점주님이 휴게시간이 없는 대신 휴게수당을 챙겨받고 있고, 4대보험도 가입해주셨습니다.

그런데 바뀔 점주분께 여쭤보니 휴게수당을 왜 주냐, 주휴수당은 주지 않을 것이고 4대보험 가입 또한 없다.

대신, 3.3%는 뗄 것이라고 하셨는데 이 부분에서 문제가 될 만한 부분은 없나요?', 12);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '타조', 'test6@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'일당 2일치를 못받았어요',
'지금 가게 직원들이 그만두기전 직원 누나가 알바할래? 라고 해서 하기 시작했는데 2일치가 밀렸거든요

근데 오늘부로 직원들이 전부 그만뒀는데 원래는 3월 31일까지 정리해준다고 하였는데 아직도 얘기도없고 직원 누나한테 물어보니까 읽씹만 하시고 ,,

그 가게 직원들은 전부 바뀌었다는데 이제 전 누구한테 돈을 받아야할까여,,,', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '타조', 'test7@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'아르바이트 중 실수로 인한 손해 배상과 임금 체불 관련 상담 요청합니다',
'개인 카페에서 디저트 생산직 아르바이트를 했습니다. 처음 면접 볼 당시에 급여는 매주 월요일에 지급하는 것으로 전달 받았고 그동안 무단퇴사하는 직원들이 많아서 이를 방지하고자 일주일씩 미뤄서 알바비를 준다고 했습니다. (현재 4/10~4/17 근무한 돈을 받지 못한 상태)

이에 동의했고 일을 잘 하다가 4/16에 제가 만든 쿠키에 공정상 문제가 생겨 생산량을 모두 폐기해야 했습니다. 재료를 잘못 넣은 것이 원인이었고 다음날에 사장님이 문제를 확인하시고 저의 책임이라며 그냥 넘어가기 어렵다고 개당 3,000원씩 총 6만원 가량을 변상하라고 하셨습니다.

저는 제 실수로 피해를 본 것이 맞긴 하나 고의성이 전혀 없었다, 다음부터 주의하겠다고 당부드렸는데 이를 거절하셨습니다. 수차례 문자와 통화가 이어졌고 전 사장님이 요청한 변상 금액에 대해 납득이 안된다고 하니 그럼 쿠키를 만든 날의 일당을 제외하는 것이 어떻겠냐 하셨습니다.

저는 그 금액에 대해서도 부담이 되긴 했으나, 이 일로 이야기가 길어져서 피로했고 그만둘 게 아니라 앞으로도 계속 일을 해야 하니 그럼 일당 정도는 포기하겠단 의사를 밝혔는데 그 다음날에 해고를 당했습니다.
', 5);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '너구리', 'test8@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'근로계약서 미작성 상태에서 퇴사',
'현재 총 6일 4시간 정도 일했습니다 대학내 근로장학생으로 선발되어서 다음달 1일부터 근무하게 되는데

일주일만에 그만두게 되는거고 지속적으로 근로계약서 쓰자고했고 사장이 미루고 미루다가 금요일날 쓰는것으로 했습니다.

결국 근로계약서도 못쓰고 퇴사하게 되는데 돈 받을수있는걸까요? 그리고 사장님한테 퇴사한다고 말했는데 근로계약서 작성하는게 맞는걸까요?

더해서 근로계약서 안쓴 시점에 어떻게 급여 받을수있는지 궁금합니다', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '너구리', 'test8@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'1년 넘게 일하고 하루 만에 해고를 당하였습니다',
'동네의 한 프랜차이즈 카페에서 주말 알바로 1년이 넘게 일하였습니다.

토요일 일요일 각각 12시부터 17시까지 근무하다가, 올해 2월쯤 가게의 매출이 안 나온다는 이유로 근무 시간이 13시부터 17시로

토요일 일요일 각각 한 시간씩 단축되어 총 주에 8시간을 근무하였습니다. 물론 근로계약서 작성 12시부터 17시까지인 상태 그대로였습니다.

4월 16일 일요일 평상시와 똑같이 근무하고 퇴근을 하였는데, 다음날에 카톡이 오기를 사장이 주변에 대형 프랜차이즈 카페가 입점하기도 하였고

매출이 너무 안나와서 근무자를 정리해야 할것 같다며 이번주부터 출근을 하지 마라는 통보를 받았습니다.

저는 전날까지도 잘 출근을 하다가 전날이 마지막 근무날이 된 것입니다.

해고를 하려면 최소 한달 전에는 통보를 해야한다고 들었는데 저같은 경우에는 해고예고수당을 받을 수 있을까요?

근무 기간은 1년이 넘었고 주당 총 근무시간은 15시간이 넘지 못한 상태입니다 답변 부탁드립니다!', 8);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '다람쥐', 'test9@test.com', '임금', '작성안함', '시급', '9620', '8', '3', '',
'처음으로 알바를 하게 되어 궁금한 것들이 있습니다',
'4/17부터 한 주(월~금) 혹은 2주간 근무하게 됩니다.

질문

1. 근무시간이 오전8시부터 오후5시까지이며 휴게 1시간이 포함되어 있습니다. 휴게시간에는 임금이 발생하지 않아 하루에 8시간치의 시급을 받게되는 것이 맞는지 궁금합니다.

2. 4대보험 과 소득세 모두 내야하는지 궁금합니다

3. 주휴수당을 받을 수 있는 근무조건으로 판단되는데, "시급에 주휴수당이 포함되어있다" 라는 말이 성립할 수 있는지 궁금합니다.', 15);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '다람쥐', 'test9@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'업주가 바뀌면서 해고당했습니다',
'한 알바생이 가게를 인수하면서 기존 알바생 모두를 해고했습니다.

‘4월2일부터 1주일동안 인수 과정이 진행되었고, 새 사장이 4월10일부터 운영을 하고 싶다고 내일(4월9일)까지만 출근하라’고 기존 사장님께 통보받았습니다.

1. 이 경우 해고예고수당을 받을 수 있나요?
1-1. 기존 사장님께 받아야 하나요?

2. 수당 대신 한달 더 일하라고 하는 경우도 있나요?

2-1. 2번을 거절해도 해고예고수당이 나오나요?', 15);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '카피바라', 'test1@test.com', '기타', '작성함', '시급', '9620', '2', '2', '', '근로계약서 위반 사항 맞나요?',
'근로계약서에는 토요일 저녁근무, 일요일 오후근무 주말근무인데 제가 일이 서투르다는 이유로 목요일,일요일에 일 시키시다가 갑자기 또 한 번은 화요일 일요일에 일하라고 하시고

일요일은 원래 오후1시부터 일하는건데 또 오전에 일하라고 스케줄을 변경하셨거든요 후에 제가 일을 못한다고 잘랐습니다.

또 계약서엔 6시간 근무인데 한 번만 6시간 일 시키시고 나머지는 5시간 일하게 시키셨습니다.

근무 시키고 이거 근로계약서 위반인가요?', 5);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '고등어', 'test2@test.com', '폭행', '작성안함', '월급', '7,500,000', '7', '2', '', '식당 서빙으로 일주일 출근하고 몸이 안좋아져서',
'한식당 홀서빙으로 일주일 출근하고 무거운걸 계속 들다보니 허리가 안좋아져서 디스크와서(예전에 급성디스크와서 한달가까이 못걷고 세달치료 받은적이있음)

오늘까지만 하고 관두겠다고 못하겠다고 했더니 디스크는 누구나 있다면서 안된다고 5월중순까지는 나오라고합니다

면접볼때 사장님이 관두게되면 한달전에 말해달라고 하긴했지만 일주일 해보고 너무힘들고 몸이아픈데 꼭 5월까지 아픈거 버텨가면서 나와야하나요

내일부터 도저히 안되겠다 못나온다고하면 이틀 더출근한거까지해서 8일치 월급은 못받는건가요', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '수달', 'test3@test.com', '임금', '작성안함', '월급', '7,400,000', '7', '5', '1', '이럴 땐 실업급여 대상이 되나요?',
'1년 4개월동안 카페에서 일을 했고 하루 근무 8시간 휴게 1시간 총 9시간 정직원으로 근무했습니다.

바로 말씀 드리자면 점주와 갈등이 있어 그만두게 되었습니다.

2월까지 하겠다고 직원들과 말만 하고 따로 점주님께 보고는 안 드렸습니다 사람이 안 구해지고 그래서 연장했습니다.

결국 5월31일까지 하겠다고 점주님께 말씀 드렸더니 안된다 본인이 서비스엉망이기에 업장에 방해된다고 3월31일까지 하라고 통보받았습니다 .

카카오톡으로 했기에 증거자료는 가지고 있습니다. 근데 다만 제가 사직서에 개인 사유로 퇴사한다고 사인을 해버렸기에 받을 수 있는지

이게 권고사직인지 자진퇴사인지 궁금해서 글 적어봅니다 판단 부탁드려요.

다들 권고사직이라고 하는데 저는 살짝 애매해서요.
', 1);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '오소리', 'test4@test.com', '임금', '작성안함', '시급', '9620', '5', '5', '',
'주휴수당 유무', '안녕하세요! 혹시 2월 말부터 알바를 하는데 월(4) 목(5) 토(5) 일(5)해서 주에 19시간 일하고 있고 시급은 1만원 받고있습니다.

근로계약서 작성안했고 주휴수당 관련 얘기 없으셔서 그냥 월급날 시급의 20%를 주시나보다 생각했는데 딱 시급만큼만 계산해서 들어왔습니다.

이 경우 2달 치 주휴수당을 요구하면 받을 수 있나요? 받는다면 갑자기 최저시급의 20%에서 1만원을 뺀 1500원×시간만큼 준다고 할 수도 있나요?

시급 1만원의 20%인 2000원 만큼 주휴수당으로 받아야 하나요?? 받아야할 걸 당당히 요구해야 하는데 갈등생길까 봐 좀 걱정되네요.', 1);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '오리너구리', 'test5@test.com', '기타', '작성함', '시급', '9620', '8', '3', '',
'새로운 점주가 휴게수당 및 사대보험 보장을 해주지 않는다고 합니다',
'안녕하세요, 편의점에서 주 5일 8시간 근무하고 있는 알바생입니다.

이번 4월 27일에 새로운 점주님이 오신다는 소식을 듣고 저를 쭉 채용하는지 물어봤을때 채용하신다고 하셨습니다.

저는 현재 점주님이 휴게시간이 없는 대신 휴게수당을 챙겨받고 있고, 4대보험도 가입해주셨습니다.

그런데 바뀔 점주분께 여쭤보니 휴게수당을 왜 주냐, 주휴수당은 주지 않을 것이고 4대보험 가입 또한 없다.

대신, 3.3%는 뗄 것이라고 하셨는데 이 부분에서 문제가 될 만한 부분은 없나요?', 12);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '타조', 'test6@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'일당 2일치를 못받았어요',
'지금 가게 직원들이 그만두기전 직원 누나가 알바할래? 라고 해서 하기 시작했는데 2일치가 밀렸거든요

근데 오늘부로 직원들이 전부 그만뒀는데 원래는 3월 31일까지 정리해준다고 하였는데 아직도 얘기도없고 직원 누나한테 물어보니까 읽씹만 하시고 ,,

그 가게 직원들은 전부 바뀌었다는데 이제 전 누구한테 돈을 받아야할까여,,,', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '타조', 'test7@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'아르바이트 중 실수로 인한 손해 배상과 임금 체불 관련 상담 요청합니다',
'개인 카페에서 디저트 생산직 아르바이트를 했습니다. 처음 면접 볼 당시에 급여는 매주 월요일에 지급하는 것으로 전달 받았고 그동안 무단퇴사하는 직원들이 많아서 이를 방지하고자 일주일씩 미뤄서 알바비를 준다고 했습니다. (현재 4/10~4/17 근무한 돈을 받지 못한 상태)

이에 동의했고 일을 잘 하다가 4/16에 제가 만든 쿠키에 공정상 문제가 생겨 생산량을 모두 폐기해야 했습니다. 재료를 잘못 넣은 것이 원인이었고 다음날에 사장님이 문제를 확인하시고 저의 책임이라며 그냥 넘어가기 어렵다고 개당 3,000원씩 총 6만원 가량을 변상하라고 하셨습니다.

저는 제 실수로 피해를 본 것이 맞긴 하나 고의성이 전혀 없었다, 다음부터 주의하겠다고 당부드렸는데 이를 거절하셨습니다. 수차례 문자와 통화가 이어졌고 전 사장님이 요청한 변상 금액에 대해 납득이 안된다고 하니 그럼 쿠키를 만든 날의 일당을 제외하는 것이 어떻겠냐 하셨습니다.

저는 그 금액에 대해서도 부담이 되긴 했으나, 이 일로 이야기가 길어져서 피로했고 그만둘 게 아니라 앞으로도 계속 일을 해야 하니 그럼 일당 정도는 포기하겠단 의사를 밝혔는데 그 다음날에 해고를 당했습니다.
', 5);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '너구리', 'test8@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'근로계약서 미작성 상태에서 퇴사',
'현재 총 6일 4시간 정도 일했습니다 대학내 근로장학생으로 선발되어서 다음달 1일부터 근무하게 되는데

일주일만에 그만두게 되는거고 지속적으로 근로계약서 쓰자고했고 사장이 미루고 미루다가 금요일날 쓰는것으로 했습니다.

결국 근로계약서도 못쓰고 퇴사하게 되는데 돈 받을수있는걸까요? 그리고 사장님한테 퇴사한다고 말했는데 근로계약서 작성하는게 맞는걸까요?

더해서 근로계약서 안쓴 시점에 어떻게 급여 받을수있는지 궁금합니다', 2);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '너구리', 'test8@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'1년 넘게 일하고 하루 만에 해고를 당하였습니다',
'동네의 한 프랜차이즈 카페에서 주말 알바로 1년이 넘게 일하였습니다.

토요일 일요일 각각 12시부터 17시까지 근무하다가, 올해 2월쯤 가게의 매출이 안 나온다는 이유로 근무 시간이 13시부터 17시로

토요일 일요일 각각 한 시간씩 단축되어 총 주에 8시간을 근무하였습니다. 물론 근로계약서 작성 12시부터 17시까지인 상태 그대로였습니다.

4월 16일 일요일 평상시와 똑같이 근무하고 퇴근을 하였는데, 다음날에 카톡이 오기를 사장이 주변에 대형 프랜차이즈 카페가 입점하기도 하였고

매출이 너무 안나와서 근무자를 정리해야 할것 같다며 이번주부터 출근을 하지 마라는 통보를 받았습니다.

저는 전날까지도 잘 출근을 하다가 전날이 마지막 근무날이 된 것입니다.

해고를 하려면 최소 한달 전에는 통보를 해야한다고 들었는데 저같은 경우에는 해고예고수당을 받을 수 있을까요?

근무 기간은 1년이 넘었고 주당 총 근무시간은 15시간이 넘지 못한 상태입니다 답변 부탁드립니다!', 8);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '다람쥐', 'test9@test.com', '임금', '작성안함', '시급', '9620', '8', '3', '',
'처음으로 알바를 하게 되어 궁금한 것들이 있습니다',
'4/17부터 한 주(월~금) 혹은 2주간 근무하게 됩니다.

질문

1. 근무시간이 오전8시부터 오후5시까지이며 휴게 1시간이 포함되어 있습니다. 휴게시간에는 임금이 발생하지 않아 하루에 8시간치의 시급을 받게되는 것이 맞는지 궁금합니다.

2. 4대보험 과 소득세 모두 내야하는지 궁금합니다

3. 주휴수당을 받을 수 있는 근무조건으로 판단되는데, "시급에 주휴수당이 포함되어있다" 라는 말이 성립할 수 있는지 궁금합니다.', 15);

insert into trouble_board (t_id, nickname, email, t_category, contract, wage, won, hours, month, year, title, t_content, hit)
values(trouble_board_t_id_seq.nextval, '다람쥐', 'test9@test.com', '임금', '작성함', '시급', '9620', '8', '3', '',
'업주가 바뀌면서 해고당했습니다',
'한 알바생이 가게를 인수하면서 기존 알바생 모두를 해고했습니다.

‘4월2일부터 1주일동안 인수 과정이 진행되었고, 새 사장이 4월10일부터 운영을 하고 싶다고 내일(4월9일)까지만 출근하라’고 기존 사장님께 통보받았습니다.

1. 이 경우 해고예고수당을 받을 수 있나요?
1-1. 기존 사장님께 받아야 하나요?

2. 수당 대신 한달 더 일하라고 하는 경우도 있나요?

2-1. 2번을 거절해도 해고예고수당이 나오나요?', 15);


commit;

select * from trouble_board;
select * from UPLOADFILE;

select count(*) from trouble_board where t_id = 2;
update trouble_board set hit = 5 where t_id = 2;


select t1.*
from( SELECT rownum no,t_id,nickname,email,t_category,contract,
wage,won,hours,month,year,title,t_content, hit,cdate FROM trouble_board) t1;
--where no between :startRec and :endRec
