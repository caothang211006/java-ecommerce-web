SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS orderdetails;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS viewhistory;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS accounts;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE accounts (
    account VARCHAR(20) PRIMARY KEY NOT NULL,
    pass VARCHAR(20) NOT NULL,
    lastName VARCHAR(50) NULL,
    firstName VARCHAR(30) NOT NULL,
    birthday DATETIME NULL,
    gender BOOLEAN DEFAULT TRUE,
    phone VARCHAR(20),
    isUse BOOLEAN DEFAULT FALSE,
    roleInSystem INT DEFAULT 0,
    sessionId VARCHAR(128) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE categories (
    typeId INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    categoryName VARCHAR(88) NOT NULL,
    memo TEXT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE products (
    productId VARCHAR(10) PRIMARY KEY NOT NULL,
    productName VARCHAR(500) NOT NULL,
    productImage TEXT,
    brief TEXT,
    postedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    typeId INT NOT NULL,
    account VARCHAR(20) NOT NULL,
    unit VARCHAR(32) DEFAULT 'pcs',
    price INT DEFAULT 0,
    discount INT DEFAULT 0 CHECK (discount >= 0 AND discount <= 100),
    CONSTRAINT fk_products_category FOREIGN KEY (typeId) REFERENCES categories(typeId),
    CONSTRAINT fk_products_account FOREIGN KEY (account) REFERENCES accounts(account) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- YC 1: Nhập thông tin tài khoản, tối thiểu 5 thành viên sẽ dùng để làm việc với các trang: Administrative pages
insert into accounts(account, pass, lastName, firstName, birthday, gender, phone, isUse, roleInSystem)
values('manager','123','Nguyễn Minh','Quang','1996/06/12',1,'0935694223',1,2);
insert into accounts(account, pass, lastName, firstName, birthday, gender, phone, isUse, roleInSystem)
values('admin','abc','Nguyễn Quang','Hưng','1996/10/28',1,'0705101028',1,1);
insert into categories(categoryName) values('Dụng cụ nhà bếp');
insert into categories(categoryName) values('Điện gia dụng');
insert into categories(categoryName) values('Trang trí nội thất');
insert into categories(categoryName) values('Dụng cụ thể thao');
insert into categories(categoryName) values('Thiết bị thông minh');
insert into categories(categoryName) values('Quần - Áo thời trang');
insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)		-- => OK
              values('SHG2303MRA', 'Bộ nồi Inox 3 đáy SUNHOUSE', '/images/sanPham/boNoiInoxSunhouse.jpg',
			          'Quai nồi Quai inox tán đinh bọc silicon cách nhiệt, Núm cầm Núm inox bọc silicon cách nhiệt,
					  Vung nồi Vung kính cường lực viền inox, Đáy nồi Đáy từ, sử dụng trên mọi loại bếp',
					 'manager', 399000,10,1, 'Bộ');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('NAG1452', 'Nồi Áp Suất Cơ Inox Cao Cấp Nagakawa', '/images/sanPham/noiApSuatNagakawa.jpg',
			          'Hệ thống 2 van xả, khóa nắp tuyệt đối an toàn. Hệ thống doăng an toàn và kín tuyêt đối.
					  Chất liệu cao cấp inox 304 không gỉ, chống bám bẩn tối ưu, an toàn cho sức khỏe, dễ dàng vệ sinh.
				      Cấu trúc đáy 3 lớp, nấu chín đều, giữ nhiệt lâu, tản nhiệt tốt',
					  'manager', 1328000,5,1, 'Bộ');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('SHG2303TEF', 'Combo 2 Chảo chiên chống dính đáy Tefal', '/images/sanPham/chaoChienTefal.jpg',
			          'LỚP PHỦ TITANIUM nonstick Bền chắc với hơn 16,000 lần chà nhám, mang lại khả năng chống dính tuyệt vời và độ bền vượt trội,
					    có thể sử dụng ít dầu khi nấu ăn. Bên ngoài được phủ sơn chống dính, dễ dàng làm sạch. CÔNG NGHỆ THERMO-SPOT
						Báo nhiệt thông minh, cho biết nhiệt độ lý tưởng để nấu ăn ngon.',
					   'admin', 709000,0,1,'Bộ');

-- Trang trí nội thất -------------------------------------------------------------------------------------------------------
insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('4062373305', 'Ghế thư giãn', '/images/sanPham/gheThuGian.jpg',
			          'Ghế làm chất liệu cao cấp, chắc chắn. Dùng ở văn phong, đi dã ngoại, ở nhà.
						Dễ dàng gấp gọn, Nằm cực sướng, giúp thư giãn lưng sau mỗi ngày làm việc',
					 'admin', 699000,10,3, 'Cái');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('8868354221', 'Bàn Trà Sofa Phong Cách Bắc Âu - IGEA', '/images/sanPham/banTraSofaIGEA.jpg',
			          'Mặt bàn sản xuất từ gỗ MDF phủ melamin cao cấp chống xước chống nước bề mặt sáng bóng. Chân bàn sản xuất từ gỗ sồi vân gỗ đều và đẹp.
					  Kích thước: mặt bàn rộng 50cm dài 90cm cao 42cm. Màu sắc: Trắng. Phong cách: Hiện đại',
					 'manager', 290000,5,3,'Cái');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('2759614408', 'Giá để giày, Kệ Giày, kệ giầy dép - 7 tầng', '/images/sanPham/keGiaDeGiay.jpg',
			          'Tủ Giày Gỗ Lắp Ráp 7 Tầng Cao Cấp với thiết kế nhỏ gọn, dễ dàng tháo lắp, đặc biệt có thể xếp lại cất gọn khi không sử dụng đến, tiết kiệm diện tích.
						Khung gỗ  melamine chống nước, có kèm bộ ốc vít để bạn có thể tự lắp ráp và tháo dỡ khi muốn di chuyển
						Kết cấu chắc chắn, bền bỉ, chịu lực tốt. Có thể để được 12 đôi giày dép và thêm ngăn kéo để chứa đồ nhỏ.
						Sản phẩm góp phần tạo nét hiện đại, sinh động cho không gian sống.',
					   'admin', 439000,10,3, 'Cái');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('5746333511', 'Kệ tivi phong cách Bắc Âu T350-1', '/images/sanPham/keTiviPhongCachBacAu.png',
			          'Thiết kế đơn giản nhưng sắc nét, hiện đại, giúp trang trí nhà thêm ấn tượng tiết kiệm diện tích.
						Đa công năng: Sử dụng làm kệ tủ tivi ,kệ trang trí đa năng.
						+ Kích thước:178x30x36cm.
						+ Chất Liệu: Gỗ MDF nhập khẩu phủ melamin cao cấp chống xước chống nước tuyệt đối
						+ Màu sắc: Vân gỗ,Trắng hiện đại, nâu',
					 'admin', 569000,0,3, 'Bộ');

-- Điện  gia dụng [2] -------------------------------------------------------------------------------------------------------
insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('BK105S2VWS', 'Máy giặt Toshiba Inverter', '/images/sanPham/mayGiatToshiba.jpg',
			          'Máy Giặt Cửa Trước Inverter Toshiba TW-BK105S2V-WS (9.5kg) - Hàng Chính Hãng sở hữu kiểu thiết kế lồng ngang hiện đại, mang phong cách châu Âu cùng với gam màu trắng tinh tế,
					  chắc chắn sẽ trở thành nội thất sang trọng cho không gian sống nhà bạn. Tiết kiệm điện năng. Khối lượng giặt: 9.5kg. Loại máy giặt: Cửa trước - lồng ngang. Tiết kiệm điện với công nghệ Inverter.',
					 'manager', 7390000,0,2, 'Bộ');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('NAFD10AR1B', 'Máy giặt Panasonic Inverter 10.5 Kg', '/images/sanPham/mayGiatPanasonic.jpg',
			          'Giặt sạch các vết bẩn cứng đầu dễ dàng với công nghệ giặt Stainmaster, sở hữu công nghệ giặt Stainmaster,
					  giúp giặt sạch các vết bẩn cứng đầu và tăng cường hiệu quả giặt sạch quần áo tốt hơn.',
					 'manager', 9290000,0,2, 'Bộ');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('NRF654GTX2', 'Tủ lạnh Panasonic Inverter 642 lít', '/images/sanPham/tuLanhPanasonic.png',
			          'Tủ lạnh Panasonic Inverter 642 lít NR-F654GT-X2 với kiểu dáng 6 cửa, mặt gương cùng hệ thống khay kệ làm từ kính
					  cường lực cứng cáp, không chỉ tô điểm vẻ đẹp đẳng cấp cho gian bếp mà còn giúp bạn thoải mái trong việc sắp xếp thực phẩm.
					  Bên cạnh đó, tủ lạnh Panasonic 642 lít còn là sự lựa chọn lý tưởng cho gia đình trên 5 người.',
					 'admin',88990000,0,2, 'Bộ');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('EHE5224B-A', 'Tủ Lạnh ELECTROLUX Inverter 524 Lít ', '/images/sanPham/tuLanhELECTROLUX.png',
			          'Làm mát 360 giúp giữ cho thực phẩm của bạn tươi và ngon lâu hơn bằng cách giảm thiểu biến động nhiệt độ. Bằng cách làm mát từng kệ riêng lẻ, nhiệt độ ổn định được duy trì.
					  Bộ lọc TasteLock Crisper với NutriPlus tạo ra một môi trường kín, ẩm để khóa các chất dinh dưỡng lâu hơn, giữ cho trái cây và rau quả của bạn tươi trong bảy ngày.',
					 'manager', 22590000,0,2, 'Bộ');

-- Dụng cụ thể thao [4] -----------------------------------------------------------------------------------------------------
insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('7823080768', 'Tạ đeo chân cao cấp', '/images/sanPham/taDeoChanCaoCap.jpg',
			          'Tạ đeo chân cao cấp phiên bản 4.0 - Nâng cao thể lực, giảm mỡ tăng cơ, phát triển chiều cao, sức bật và sức bền
					  Cấu tạo :
						+ Vải : Polyeste siêu bền có khả năng chống nước, khử mùi siêu thoáng và cực kỳ êm chân khi tập luyện.
						+ Thanh tạ : Thép không gỉ mạ crom cao cấp.
						+ Trọng Lượng : 4 kg, 5 kg, 6 kg, 8 kg... có thể điểu chỉnh được trọng lượng.',
					 'manager', 315000,0,4, 'Bộ');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('6075086733', 'Áo thể thao Fitme Body Compression', '/images/sanPham/aoTheThaoFitness.pnj',
			          'Áo thể thao Body Compression Fitme cao cấp chuyên nghiệp dành cho những ai có nhu cầu luyện tập với cường độ cao
						Phù hợp cho các môn thể thao tập gym, bóng rổ, bóng đá, bóng chuyền, giữ nhiệt.
						Quần chất co dãn cao, fit cơ thể, tôn dáng người',
					   'admin', 152000,0,4, 'Bộ');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('8640589401', 'Xà Đơn Treo Tường', '/images/sanPham/xaDonTreoTuong.jpg',
			          'Tập hít xà đơn hàng ngày sẽ giúp cho bạn có một thân hình cân đối, đẹp, vòng ngực rộng và cơ bắp săn chắn.
						Với việc tập xà đơn sẽ giúp bạn có một đôi tay cứng, chắc, khỏe.
						Tập hít xà đơn hàng ngày cũng sẽ giúp người tập giảm béo bụng một cách nhanh nhất và hiệu quả
						Xà đơn treo tường có thể thay đổi độ dài sao cho phù hợp với từng kích thước vị trí cần lắp đặt.',
					 'manager', 119000,0,4, 'Bộ');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('9024218247', 'Máy chạy bộ trên không cao cấp', '/images/sanPham/mayChayBoTrenKhong.jpg',
			          'Máy kết hợp tập luyện vừa chạy bộ, đi bộ vừa có thể tập kéo tay thúc đẩy các hệ cơ bắp chân, bắp tay, đùi, hông, mông, eo, bụng..
						Bàn để chân rộng, tạo thế đứng vững chắc, tay cầm bọc mút dày, tạo sự thoải mái cho người tập',
					  'admin', 1020000,0,4, 'Bộ');

-- Quần áo thời trang [6] --------------------------------------------------------------------------------------------------
insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('6681948644', 'Váy Babaydoll Kẻ Caro Phối Nơ', '/images/sanPham/vayBabadollCaro.jpg',
			          'Mẫu váy nhẹ nhàng tiểu thư cho các nàng bánh bèo vừa về kho Lê Sang nha!. Mã mới xưởng bên mới thiết kế chào hàng các nàng luôn ạ.
						+ Thiết kế cổ tròn phối nơ, đuôi cá.
						+ Vải đũi xốp trắng mịn dày dặn.',
					  'admin', 109000,0,6, 'Cái');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('1688993802', 'Áo Sơ Mi Nam Trơn Ngắn Tay', '/images/sanPham/aoSoMiNamNganTay.jpg',
			          'Áo sơ mi nam body vẫn rất phù hợp để sử dụng thoải mái cho môi trường công sở. mẫu áo có thiết kế như thế này sẽ giúp các bạn nam thể hiện được sự tươi trẻ, năng động, thanh lịch và dễ dàng khoe được vóc dáng cân đối của cơ thể.
						Mẫu áo sơ mi nam body phù hợp và đẹp nhất khi được những chàng trai sở hữu thân hình săn chắc và thon gọn.',
					 'admin', 99000,0,6, 'Chiếc');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('4494738964', 'Balo Nữ Đi Học Laptop Chống Nước Ulzzang', '/images/sanPham/baloNuChongNuoc.jpg',
			          'Thiết kế hiện đại, trẻ trung,tiện dụng,vừa đơn giản, vừa sang trọng. Sản phẩm chắc chắn.  Kích thước :BALO:40X12X30 CM',
					  'admin', 105000,0,6, 'Cái');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('9680372888', 'Giày thể thao nữ', '/images/sanPham/giayTheThaoNu.jpg',
			          'Kiểu dáng mới, mẫu mã đa dạng. Thể thao cá tính, đi chơi, đi thể dục đều đẹp ạ. Đế cao su, êm chân chống trơn trượt. Size 35 -39',
					  'manager', 153000,0,6, 'Đôi');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('8709925437', 'Giày bốt da nam cao cổ', '/images/sanPham/giayBotDaNamCaoCo.jpg',
			          'Giày da nam GD-08 với phong cách Bụi Bặm giúp bạn trở nên cá tính và ngầu hơn bao giờ hết, chất da tổng hợp cao cấp giúp bạn dùng lâu bên với thời gian
						Giày bốt nam GD-08 thiết kế giữa chất da và lớt vải lỗ thoáng khi nơi thân giày giúp chân bạn được thoáng khi hơn có 2 màu : Đen và Nâu',
					  'manager',189000,0,6, 'Đôi');

-- Thiết bị thông minh [5] ---------------------------------------------------------------------------------------------------
insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('11MAX64213', 'Điện Thoại iPhone 11 Pro Max 64GB', '/images/sanPham/iPhone11_ProMax.jpg',
			          'Điện thoại iPhone 11 Pro Max là phiên bản cao cấp nhất của iPhone năm nay. Sản phẩm có nhiều cải tiến nổi bật, hiệu năng,
					  thiết kế mới đặc biệt ở phần mặt lưng và hệ thống camera.
						iPhone 11 Pro Max có rất nhiều cải tiến về thiết kế, điểm khác biệt lớn nhất đến từ phần mặt lưng với cụm camera được
						thiết kế cách điệu khá to. ',
					 'admin',26500000,0,5, 'Cái');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('10NOTEP256', 'Samsung Galaxy Note 10 Plus', '/images/sanPham/samsungGalaxyNote10Plus.jpg',
			          'Sự kết hợp của những dải màu nổi bật và sinh động. Với lớp kính cường lực Gorilla 6 bảo vệ vững chắc, và chất liệu
					  thủy tinh đánh bóng bắt sáng cao cấp sắc sảo kiến tạo nên ánh quang đậm chất đương đại.
					  Thao tác sử dụng Galaxy Note10 và Note10+ trực quan hơn nhờ Giao diện Đồng nhất, thân thiện với thói quen thường ngày,
					  cho trải nghiệm Galaxy trở nên vô tận.',
					 'admin',25450000,0,5, 'Cái');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('XRN8012121', 'Xiaomi Redmi Note 8', '/images/sanPham/XiaomiRedmiNote8.jpg',
			          'Điện Thoại Xiaomi Redmi Note 8 - Hàng Chính Hãng Không chỉ có 2 hay 3 camera mà với chiếc smartphone mới Xiaomi Redmi Note 8 thì người dùng sẽ có tới 4 camera
					    để thỏa mãn nhu cầu chụp ảnh của mình.
					    Xiaomi Redmi Note 8 sở hữu cho mình camera chính với độ phân giải khủng "khủng" với "số chấm" lên tới 48 MP.',
					  'manager',3750000,0,5, 'Cái');

insert into products (productId, productName, productImage, brief, account, price, discount, typeId, unit)
              values('Y98HEAD802', 'Tai nghe bluetooth thể thao Y98', '/images/sanPham/TaiNgheBluetoothY98.jpg',
			          'Nghe nhạc trong lúc tập luyện thể thao có thể giúp người tập quên đi cảm giác mệt mỏi và gia tăng thời gian tập luyện.
					  Đồng thời, việc nghe nhạc cũng khiến con người quên đi sự chán nản, lặp đi lặp lại của các bài tập thể dục, từ đó gia tăng
					  hiệu suất tập thể dục, thể thao. Chính vì vậy chiếc Tai nghe thể thao Bluetooth Y98 đang hot trên thị trường hiện nay chắc
					  chắn sẽ làm bạn hài lòng.',
					 'manager',299000,0,5, 'Bộ');
CREATE TABLE cart (
    account VARCHAR(20) NOT NULL,
    productId VARCHAR(10) NOT NULL,
    quantity INT DEFAULT 1,
    PRIMARY KEY (account, productId),
    CONSTRAINT fk_cart_account FOREIGN KEY (account) REFERENCES accounts(account) ON DELETE CASCADE,
    CONSTRAINT fk_cart_product FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE viewhistory (
    account VARCHAR(20) NOT NULL,
    productId VARCHAR(10) NOT NULL,
    viewedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (account, productId),
    CONSTRAINT fk_viewhistory_account FOREIGN KEY (account) REFERENCES accounts(account) ON DELETE CASCADE,
    CONSTRAINT fk_viewhistory_product FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE orders (
    orderId INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    account VARCHAR(20),
    orderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    address VARCHAR(500) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    status INT DEFAULT 0,
    CONSTRAINT fk_orders_account FOREIGN KEY (account) REFERENCES accounts(account)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE orderdetails (
    orderId INT NOT NULL,
    productId VARCHAR(10) NOT NULL,
    quantity INT NOT NULL,
    price INT NOT NULL,
    discount INT DEFAULT 0,
    PRIMARY KEY (orderId, productId),
    CONSTRAINT fk_orderdetails_order FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE,
    CONSTRAINT fk_orderdetails_product FOREIGN KEY (productId) REFERENCES products(productId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
