part of 'model.dart';

class UserdatamodelAdapter extends TypeAdapter<Userdatamodel> {
  @override
  final int typeId = 1;

  @override
  Userdatamodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Userdatamodel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      username: fields[2] as String?,
      password: fields[3] as String?,
      email: fields[4] as String?,
      phone: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Userdatamodel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserdatamodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfilemodelAdapter extends TypeAdapter<Profilemodel> {
  @override
  final int typeId = 2;

  @override
  Profilemodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profilemodel(
      id: fields[0] as int?,
      image: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Profilemodel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfilemodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategorymodelAdapter extends TypeAdapter<Categorymodel> {
  @override
  final int typeId = 3;

  @override
  Categorymodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Categorymodel(
      imagepath: fields[1] as String,
      id: fields[0] as int?,
      categoryname: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Categorymodel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagepath)
      ..writeByte(2)
      ..write(obj.categoryname);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategorymodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductmodelAdapter extends TypeAdapter<Productmodel> {
  @override
  final int typeId = 4;

  @override
  Productmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Productmodel(
      id: fields[0] as int?,
      image: fields[1] as String?,
      productname: fields[2] as String?,
      categoryname: fields[3] as String?,
      description: fields[4] as String?,
      sellingrate: fields[5] as dynamic,
      purchaserate: fields[6] as int?,
      stock: fields[7] as int?,
      quantity: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Productmodel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.productname)
      ..writeByte(3)
      ..write(obj.categoryname)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.sellingrate)
      ..writeByte(6)
      ..write(obj.purchaserate)
      ..writeByte(7)
      ..write(obj.stock)
      ..writeByte(8)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SellProductAdapter extends TypeAdapter<SellProduct> {
  @override
  final int typeId = 5;

  @override
  SellProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SellProduct(
      sellquantity: fields[7] as int?,
      id: fields[0] as int?,
      sellName: fields[1] as String,
      sellPhone: fields[2] as String,
      sellproductname: fields[3] as String,
      sellPrice: fields[4] as String,
      sellDate: fields[5] as DateTime?,
      totalprice: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, SellProduct obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sellName)
      ..writeByte(2)
      ..write(obj.sellPhone)
      ..writeByte(3)
      ..write(obj.sellproductname)
      ..writeByte(4)
      ..write(obj.sellPrice)
      ..writeByte(5)
      ..write(obj.sellDate)
      ..writeByte(6)
      ..write(obj.totalprice)
      ..writeByte(7)
      ..write(obj.sellquantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SellProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileModelAdapter extends TypeAdapter<ProfileModel> {
  @override
  final int typeId = 6;

  @override
  ProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileModel(
      id: fields[0] as int?,
      image: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CustomerDetailsAdapter extends TypeAdapter<CustomerDetails> {
  @override
  final int typeId = 7;

  @override
  CustomerDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerDetails(
      name: fields[0] as String,
      phone: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerDetails obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InvoiceModelAdapter extends TypeAdapter<InvoiceModel> {
  @override
  final int typeId = 8;

  @override
  InvoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceModel(
      amount: fields[6] as double?,
      customerName: fields[0] as String?,
      customerPhone: fields[1] as String?,
      products: (fields[2] as List?)?.cast<Productmodel>(),
      invoiceNumber: fields[8] as double?,
      totalAmount: fields[3] as double?,
      squantity: fields[4] as int?,
      purchaseDate: fields[5] as DateTime?,
      id: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.customerName)
      ..writeByte(1)
      ..write(obj.customerPhone)
      ..writeByte(2)
      ..write(obj.products)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.squantity)
      ..writeByte(5)
      ..write(obj.purchaseDate)
      ..writeByte(6)
      ..write(obj.amount)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.invoiceNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = 9;

  @override
  NotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationModel(
      totalAmountSale: fields[6] as double?,
      title: fields[0] as String,
      customerName: fields[5] as String?,
      message: fields[1] as String?,
      timestamp: fields[2] as DateTime?,
      isRead: fields[3] as bool,
      description: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.isRead)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.customerName)
      ..writeByte(6)
      ..write(obj.totalAmountSale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
