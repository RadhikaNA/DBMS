Table Creation--

create table student
(
usn varchar(10) primary key,
sname varchar(25),
address varchar(25),
phone number (10),
gender varchar (1)
);

create table semsec
(
ssid varchar(5) primary key,
sem number (2),
sec varchar(1)
);

create table class
(
usn varchar(10),
ssid varchar(5),
foreign key(usn) references student(usn),
foreign key(ssid) references semsec(ssid),
primary key (usn, ssid)
);

create table course
(
subcode varchar(8) primary key,
title varchar(20),
sem number(2),
credits number(2)
);

create table iamarks 
(
usn varchar(10),
subcode varchar(8),
ssid varchar(5),
test1 number(2),
test2 number(2),
test3 number(2),
finalia number(2),
foreign key(usn) references student(usn),
foreign key(subcode) references course(subcode),
foreign key(ssid) references semsec(ssid),
primary key (usn, subcode, ssid)
);

Insertion--

insert into student values ('1bi15cs100','akshay','belagavi', 8877881122,'m');
insert into student values ('1bi15cs101','sandhya','bengaluru', 7722829912,'f');
insert into student values ('1bi15cs102','teesha','bengaluru', 7712312312,'f');
insert into student values ('1bi15cs103','supriya','mangaluru', 8877881122,'f');
insert into student values ('1bi15cs104','abhay','bengaluru', 9900211201,'m');

insert into semsec values ('cse8a', 8,'a');
insert into semsec values ('cse8b', 8,'b');
insert into semsec values ('cse8c', 8,'c');
insert into semsec values ('cse4a', 4,'a');
insert into semsec values ('cse4c', 4,'c');

insert into class values ('1bi15cs100','cse8a');
insert into class values ('1bi15cs101','cse8b');
insert into class values ('1bi15cs102','cse8c');
insert into class values ('1bi15cs103','cse4a');
insert into class values ('1bi15cs104','cse4c');

insert into course values ('10cs81', 'is', 8, 4);
insert into course values ('10cs82','sms', 8, 4);
insert into course values ('10cs83','mc', 8, 4);
insert into course values ('10cs84','dss', 8, 4);
insert into course values ('15cs55','java', 5, 3);

insert into iamarks(usn,subcode,ssid,test1,test2,test3) values('1bi15cs101','10cs81','cse8a',15,16,18);
insert into iamarks(usn,subcode,ssid,test1,test2,test3) values('1bi15cs101','10cs82','cse8a',10,11,11);
insert into iamarks(usn,subcode,ssid,test1,test2,test3) values('1bi15cs101','10cs83','cse8a',19,15,20);
insert into iamarks(usn,subcode,ssid,test1,test2,test3) values('1bi15cs103','10cs82','cse8c',20,16,19);
insert into iamarks(usn,subcode,ssid,test1,test2,test3) values ('1bi15cs103','10cs84','cse8c',15,15,12);

QUERIES--

Q1--

select s.*, ss.sem, ss.sec
from student s,semsec ss,class c
where s.usn = c.usn 
and ss.ssid = c.ssid 
and ss.sem = 4 
and ss.sec='c';

Q2--

select ss.sem, ss.sec, s.gender, count (s.gender) as count 
from student s, semsec ss, class c 
wheres.usn = c.usn and ss.ssid = c.ssid
group by ss.sem, ss.sec, s.gender
order by sem;

Q3--

create view stud_test1_marks as
select test1, subcode from iamarks
where usn = '1bi15cs101';

Q4--

create or replace procedure avgmarks is
cursor c_iamarks is
select greatest(test1,test2) as a,
greatest(test1,test3) as b,
greatest(test3,test2) as c
from iamarks
where finalia is null
for update;
c_a number;
c_b number;
c_c number;
c_sm number;
c_av number;
begin
open c_iamarks;
loop
fetch c_iamarks into c_a, c_b, c_c;
exit when c_iamarks%notfound;
--dbms_output.put_line(c_a || ‘’ || c_b || ‘’ || c_c);
if (c_a != c_b) 
then c_sm:=c_a+c_b;
else
c_sm:=c_a+c_c;
end if;
c_av:=c_sm/2;
--dbms_output.put_line('sum = '||c_sm);
--dbms_output.put_line('average = '||c_av);
update iamarks set finalia=c_av where current of c_iamarks;
end loop;
close c_iamarks;
end;
/

select * from iamarks;

begin
avgmarks;
end;
/

Q5--
select s.usn,s.sname,s.address,s.phone,s.gender,
(
case 
when ia.finalia between 17 and 20 then 'outstanding'
when ia.finalia between 12 and 16 then 'average' else 'weak'
end
) 
as cat
from student s, semsec ss, iamarks ia, course sub
where s.usn = ia.usn and ss.ssid = ia.ssid 
and sub.subcode = ia.subcode and sub.sem = 8;
