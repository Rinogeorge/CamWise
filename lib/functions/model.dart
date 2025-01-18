import 'package:hive/hive.dart';
part 'model.g.dart';

@HiveType(typeId: 1)
class Userdatamodel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? username;

  @HiveField(3)
  String? password;

  @HiveField(4)
  String? email;

  @HiveField(5)
  int? phone;

  Userdatamodel(
      {this.id,
      required this.name,
      required this.username,
      required this.password,
      required this.email,
      required this.phone});
}

@HiveType(typeId: 2)
class Profilemodel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? image;

  Profilemodel({this.id, required this.image});
}

@HiveType(typeId: 3)
class Categorymodel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String imagepath;

  @HiveField(2)
  String categoryname;

  Categorymodel({required this.imagepath, this.id, required this.categoryname});
}

@HiveType(typeId: 4)
class Productmodel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? image;

  @HiveField(2)
  String? productname;

  @HiveField(3)
  String? categoryname;

  @HiveField(4)
  String? description;

  @HiveField(5)
  dynamic sellingrate;

  @HiveField(6)
  int? purchaserate;

  @HiveField(7)
  int? stock;
  @HiveField(8)
  int? quantity;

  Productmodel({
    this.id,
    required this.image,
    required this.productname,
    this.categoryname,
    this.description,
    required this.sellingrate,
    this.purchaserate,
    required this.stock,
    this.quantity,
  });

  get selectedQuantity => null;
}

@HiveType(typeId: 5)
class SellProduct {
  @HiveField(0)
  int? id;

  @HiveField(1)
   String sellName;

  @HiveField(2)
   String sellPhone;

  @HiveField(3)
  final String sellproductname;

  @HiveField(4)
  final String sellPrice;

  @HiveField(5)
  final DateTime? sellDate;
 
  
  @HiveField(6)
  final double? totalprice;
  @HiveField(7)
  final int? sellquantity;

  SellProduct({
    this.sellquantity,
    this.id,
    required this.sellName,
    required this.sellPhone,
    required this.sellproductname,
    required this.sellPrice,
    required this.sellDate,
    required this.totalprice,                      
  });
}

@HiveType(typeId: 6)
class ProfileModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String image;

  ProfileModel({this.id, required this.image});
}

 
@HiveType(typeId: 7)
class CustomerDetails extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phone;

  CustomerDetails({required this.name, required this.phone});
}


@HiveType(typeId: 8)
class InvoiceModel {
  @HiveField(0)
  final String? customerName;

  @HiveField(1)
  final String? customerPhone;
  
  @HiveField(2)
  final List<Productmodel>? products;
  
  @HiveField(3)
  final double? totalAmount;
  
  @HiveField(4)
  final int? squantity;
  
  @HiveField(5)
 final DateTime? purchaseDate;
  
  @HiveField(6)
   final double? amount;

   @HiveField(7)
     int? id;

    @HiveField(8)
    double? invoiceNumber; 
   
  InvoiceModel({
     this.amount,
      this.customerName,
     this.customerPhone,
     this.products,
     this.invoiceNumber,
     this.totalAmount,
      this.squantity,
     this.purchaseDate,  
    this.id,
  });
}

@HiveType(typeId: 9)  
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String? message;

  @HiveField(2)
  final DateTime? timestamp;

  @HiveField(3)
  bool isRead;

  @HiveField(4)
  final String? description;

    @HiveField(5)
  final String? customerName;

  @HiveField(6)
  final double? totalAmountSale;

  NotificationModel({
    this.totalAmountSale = 0.0,
    required this.title,
    this.customerName,
    this.message,
     this.timestamp,
    this.isRead = false,
    this.description,
  });
}