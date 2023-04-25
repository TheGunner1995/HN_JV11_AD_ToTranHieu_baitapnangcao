create database QLBHTOTRANHIEU;
use QLBHTOTRANHIEU;

create table customer(
cId int primary key,
cName varchar(25) ,
cAge int 
);

create table product(
pId int primary key,
pName varchar(25) ,
pPrice int
);

create table `order`(
oId int primary key,
cId int,
foreign key(cId) references customer(cId),
oDate datetime ,
oTotalPrice int 
);

create table orderDetail(
oID int ,
foreign key(oId) references `order`(oId),
pId int,
foreign key(pId) references product(pId),
odQTY int 
);

insert into customer(cId,cName, cAge) values
(1,"Minh Quân", 10),
(2,"Ngọc Oanh", 20),
(3,"Hồng HÀ", 50);

insert into `order`(oId,cId, oDate) values
(1,1,"2006-3-21"),
(2,2,"2006-3-23"),
(3,1,"2006-3-16");

insert into product(pId,pName, pPrice) values
(1,"Máy Giặt", 3),
(2,"Tủ Lạnh", 5),
(3,"Điều Hòa", 7),
(4,"Quạt", 1),
(5,"Bếp Điện", 2);

insert into orderDetail(oId, pId, odQTY) values
(1,1,3),
(1,3,7),
(1,4,2),
(2,1,1),
(3,1,8),
(2,5,4),
(2,3,3);

-- 2.Hiển thị các thông tin gồm oID, oDate, oTotalPrice của tất cả các hóa đơntrong bảng Order, danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm trên
select * from `order` order by oDate desc;

-- 3.Hiển thị tên và giá của các sản phẩm có giá cao nhất 
select p.pName, p.pPrice from product p where p.pPrice = (select max(pPrice) from product);

-- 4.Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó
select c.cname, p.pname from customer c join `order` o on c.cId = o.cId join orderdetail od on o.oId = od.oId join product p on od.pId = p.pId;

-- 5.Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
select c.cName from customer c where c.cId not in (select cId from `order`);

-- 6.Hiển thị chi tiết của từng hóa đơn
select o.oId, o.oDate, od.odQTY, p.pName, p.pPrice from `order` o join orderDetail od on o.oId = od.oId join product p on od.pId = p.pId;

-- 7.Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện
-- trong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice)
select o.oId, o.oDate, sum(od.odQTY * p.pPrice) as `TOTAL` from `order` o join orderDetail od on o.oId = od.oId join product p on od.pId = p.pId group by o.oId;

-- 8.Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị 
create view Sales as
select sum(tb.TOTAL) as Sales from (select o.oId, o.oDate, sum(od.odQTY * p.pPrice) as `TOTAL` from `order` o join orderDetail od on o.oId = od.oId join product p on od.pId = p.pId group by o.oId) tb;
SELECT * FROM sales;

-- 9.Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng
alter table `order`
drop foreign key order_ibfk_1;
alter table orderDetail
drop foreign key orderdetail_ibfk_1,
drop foreign key orderdetail_ibfk_2;

ALTER TABLE customer 
DROP PRIMARY KEY ;

ALTER TABLE `order` 
DROP PRIMARY KEY;

ALTER TABLE product 
DROP PRIMARY KEY;

-- 10.Tạo một trigger tên là cusUpdate trên bảng Customer, sao cho khi sửa mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo:
create trigger cusUpdate
after update on customer
for each row
update `order` set cId = new.cId where cId = old.cId;

update customer
set cId =7 where cId = 2;

-- 11.Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của một sản phẩm, strored procedure này sẽ xóa sản phẩm có tên được truyên 
vào thông qua tham số, và các thông tin liên quan đến sản phẩm đó ở trong 
bảng OrderDetail:

DELIMITER // 
create procedure delProduct(in pNameDel varchar(25))
begin
delete from Product where pName = pNameDel;
delete from OrderDetail where pId in (select pId from Product where pName = pNameDel);
end //
DELIMITER ;
call delProduct("Bep Dien");





