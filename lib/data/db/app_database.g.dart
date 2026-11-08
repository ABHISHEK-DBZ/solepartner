// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MerchantProfilesTable extends MerchantProfiles
    with TableInfo<$MerchantProfilesTable, MerchantProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MerchantProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _shopNameMeta = const VerificationMeta(
    'shopName',
  );
  @override
  late final GeneratedColumn<String> shopName = GeneratedColumn<String>(
    'shop_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerNameMeta = const VerificationMeta(
    'ownerName',
  );
  @override
  late final GeneratedColumn<String> ownerName = GeneratedColumn<String>(
    'owner_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessTypeMeta = const VerificationMeta(
    'businessType',
  );
  @override
  late final GeneratedColumn<String> businessType = GeneratedColumn<String>(
    'business_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 8,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shopName,
    ownerName,
    businessType,
    languageCode,
    currencyCode,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merchant_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<MerchantProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shop_name')) {
      context.handle(
        _shopNameMeta,
        shopName.isAcceptableOrUnknown(data['shop_name']!, _shopNameMeta),
      );
    } else if (isInserting) {
      context.missing(_shopNameMeta);
    }
    if (data.containsKey('owner_name')) {
      context.handle(
        _ownerNameMeta,
        ownerName.isAcceptableOrUnknown(data['owner_name']!, _ownerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerNameMeta);
    }
    if (data.containsKey('business_type')) {
      context.handle(
        _businessTypeMeta,
        businessType.isAcceptableOrUnknown(
          data['business_type']!,
          _businessTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessTypeMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MerchantProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MerchantProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      shopName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_name'],
      )!,
      ownerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_name'],
      )!,
      businessType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_type'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MerchantProfilesTable createAlias(String alias) {
    return $MerchantProfilesTable(attachedDatabase, alias);
  }
}

class MerchantProfile extends DataClass implements Insertable<MerchantProfile> {
  final int id;
  final String shopName;
  final String ownerName;
  final String businessType;
  final String languageCode;
  final String currencyCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MerchantProfile({
    required this.id,
    required this.shopName,
    required this.ownerName,
    required this.businessType,
    required this.languageCode,
    required this.currencyCode,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shop_name'] = Variable<String>(shopName);
    map['owner_name'] = Variable<String>(ownerName);
    map['business_type'] = Variable<String>(businessType);
    map['language_code'] = Variable<String>(languageCode);
    map['currency_code'] = Variable<String>(currencyCode);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MerchantProfilesCompanion toCompanion(bool nullToAbsent) {
    return MerchantProfilesCompanion(
      id: Value(id),
      shopName: Value(shopName),
      ownerName: Value(ownerName),
      businessType: Value(businessType),
      languageCode: Value(languageCode),
      currencyCode: Value(currencyCode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MerchantProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MerchantProfile(
      id: serializer.fromJson<int>(json['id']),
      shopName: serializer.fromJson<String>(json['shopName']),
      ownerName: serializer.fromJson<String>(json['ownerName']),
      businessType: serializer.fromJson<String>(json['businessType']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shopName': serializer.toJson<String>(shopName),
      'ownerName': serializer.toJson<String>(ownerName),
      'businessType': serializer.toJson<String>(businessType),
      'languageCode': serializer.toJson<String>(languageCode),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MerchantProfile copyWith({
    int? id,
    String? shopName,
    String? ownerName,
    String? businessType,
    String? languageCode,
    String? currencyCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MerchantProfile(
    id: id ?? this.id,
    shopName: shopName ?? this.shopName,
    ownerName: ownerName ?? this.ownerName,
    businessType: businessType ?? this.businessType,
    languageCode: languageCode ?? this.languageCode,
    currencyCode: currencyCode ?? this.currencyCode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MerchantProfile copyWithCompanion(MerchantProfilesCompanion data) {
    return MerchantProfile(
      id: data.id.present ? data.id.value : this.id,
      shopName: data.shopName.present ? data.shopName.value : this.shopName,
      ownerName: data.ownerName.present ? data.ownerName.value : this.ownerName,
      businessType: data.businessType.present
          ? data.businessType.value
          : this.businessType,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MerchantProfile(')
          ..write('id: $id, ')
          ..write('shopName: $shopName, ')
          ..write('ownerName: $ownerName, ')
          ..write('businessType: $businessType, ')
          ..write('languageCode: $languageCode, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shopName,
    ownerName,
    businessType,
    languageCode,
    currencyCode,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MerchantProfile &&
          other.id == this.id &&
          other.shopName == this.shopName &&
          other.ownerName == this.ownerName &&
          other.businessType == this.businessType &&
          other.languageCode == this.languageCode &&
          other.currencyCode == this.currencyCode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MerchantProfilesCompanion extends UpdateCompanion<MerchantProfile> {
  final Value<int> id;
  final Value<String> shopName;
  final Value<String> ownerName;
  final Value<String> businessType;
  final Value<String> languageCode;
  final Value<String> currencyCode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MerchantProfilesCompanion({
    this.id = const Value.absent(),
    this.shopName = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.businessType = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MerchantProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String shopName,
    required String ownerName,
    required String businessType,
    required String languageCode,
    required String currencyCode,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : shopName = Value(shopName),
       ownerName = Value(ownerName),
       businessType = Value(businessType),
       languageCode = Value(languageCode),
       currencyCode = Value(currencyCode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MerchantProfile> custom({
    Expression<int>? id,
    Expression<String>? shopName,
    Expression<String>? ownerName,
    Expression<String>? businessType,
    Expression<String>? languageCode,
    Expression<String>? currencyCode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shopName != null) 'shop_name': shopName,
      if (ownerName != null) 'owner_name': ownerName,
      if (businessType != null) 'business_type': businessType,
      if (languageCode != null) 'language_code': languageCode,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MerchantProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? shopName,
    Value<String>? ownerName,
    Value<String>? businessType,
    Value<String>? languageCode,
    Value<String>? currencyCode,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return MerchantProfilesCompanion(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      businessType: businessType ?? this.businessType,
      languageCode: languageCode ?? this.languageCode,
      currencyCode: currencyCode ?? this.currencyCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shopName.present) {
      map['shop_name'] = Variable<String>(shopName.value);
    }
    if (ownerName.present) {
      map['owner_name'] = Variable<String>(ownerName.value);
    }
    if (businessType.present) {
      map['business_type'] = Variable<String>(businessType.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MerchantProfilesCompanion(')
          ..write('id: $id, ')
          ..write('shopName: $shopName, ')
          ..write('ownerName: $ownerName, ')
          ..write('businessType: $businessType, ')
          ..write('languageCode: $languageCode, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 240,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    address,
    notes,
    archived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String notes;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.notes,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    map['notes'] = Variable<String>(notes);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      address: Value(address),
      notes: Value(notes),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      notes: serializer.fromJson<String>(json['notes']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'notes': serializer.toJson<String>(notes),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? notes,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Customer(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    notes: notes ?? this.notes,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    address,
    notes,
    archived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> address;
  final Value<String> notes;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String phone,
    required String address,
    required String notes,
    this.archived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       phone = Value(phone),
       address = Value(address),
       notes = Value(notes),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CustomersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? address,
    Value<String>? notes,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 240,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    address,
    notes,
    archived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String notes;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Supplier({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.notes,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    map['notes'] = Variable<String>(notes);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      address: Value(address),
      notes: Value(notes),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Supplier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      notes: serializer.fromJson<String>(json['notes']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'notes': serializer.toJson<String>(notes),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Supplier copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? notes,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Supplier(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    notes: notes ?? this.notes,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    address,
    notes,
    archived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> address;
  final Value<String> notes;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String phone,
    required String address,
    required String notes,
    this.archived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       phone = Value(phone),
       address = Value(address),
       notes = Value(notes),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Supplier> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SuppliersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? address,
    Value<String>? notes,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 160,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 24,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasePricePaiseMeta =
      const VerificationMeta('purchasePricePaise');
  @override
  late final GeneratedColumn<int> purchasePricePaise = GeneratedColumn<int>(
    'purchase_price_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sellingPricePaiseMeta = const VerificationMeta(
    'sellingPricePaise',
  );
  @override
  late final GeneratedColumn<int> sellingPricePaise = GeneratedColumn<int>(
    'selling_price_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stockQtyMeta = const VerificationMeta(
    'stockQty',
  );
  @override
  late final GeneratedColumn<double> stockQty = GeneratedColumn<double>(
    'stock_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _minStockQtyMeta = const VerificationMeta(
    'minStockQty',
  );
  @override
  late final GeneratedColumn<double> minStockQty = GeneratedColumn<double>(
    'min_stock_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES suppliers (id)',
    ),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    sku,
    barcode,
    category,
    unit,
    purchasePricePaise,
    sellingPricePaise,
    stockQty,
    minStockQty,
    supplierId,
    imagePath,
    archived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    } else if (isInserting) {
      context.missing(_skuMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('purchase_price_paise')) {
      context.handle(
        _purchasePricePaiseMeta,
        purchasePricePaise.isAcceptableOrUnknown(
          data['purchase_price_paise']!,
          _purchasePricePaiseMeta,
        ),
      );
    }
    if (data.containsKey('selling_price_paise')) {
      context.handle(
        _sellingPricePaiseMeta,
        sellingPricePaise.isAcceptableOrUnknown(
          data['selling_price_paise']!,
          _sellingPricePaiseMeta,
        ),
      );
    }
    if (data.containsKey('stock_qty')) {
      context.handle(
        _stockQtyMeta,
        stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta),
      );
    }
    if (data.containsKey('min_stock_qty')) {
      context.handle(
        _minStockQtyMeta,
        minStockQty.isAcceptableOrUnknown(
          data['min_stock_qty']!,
          _minStockQtyMeta,
        ),
      );
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      purchasePricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_price_paise'],
      )!,
      sellingPricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selling_price_paise'],
      )!,
      stockQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock_qty'],
      )!,
      minStockQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_stock_qty'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}supplier_id'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String sku;
  final String barcode;
  final String category;
  final String unit;
  final int purchasePricePaise;
  final int sellingPricePaise;
  final double stockQty;
  final double minStockQty;
  final int? supplierId;
  final String? imagePath;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.category,
    required this.unit,
    required this.purchasePricePaise,
    required this.sellingPricePaise,
    required this.stockQty,
    required this.minStockQty,
    this.supplierId,
    this.imagePath,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sku'] = Variable<String>(sku);
    map['barcode'] = Variable<String>(barcode);
    map['category'] = Variable<String>(category);
    map['unit'] = Variable<String>(unit);
    map['purchase_price_paise'] = Variable<int>(purchasePricePaise);
    map['selling_price_paise'] = Variable<int>(sellingPricePaise);
    map['stock_qty'] = Variable<double>(stockQty);
    map['min_stock_qty'] = Variable<double>(minStockQty);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<int>(supplierId);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      sku: Value(sku),
      barcode: Value(barcode),
      category: Value(category),
      unit: Value(unit),
      purchasePricePaise: Value(purchasePricePaise),
      sellingPricePaise: Value(sellingPricePaise),
      stockQty: Value(stockQty),
      minStockQty: Value(minStockQty),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sku: serializer.fromJson<String>(json['sku']),
      barcode: serializer.fromJson<String>(json['barcode']),
      category: serializer.fromJson<String>(json['category']),
      unit: serializer.fromJson<String>(json['unit']),
      purchasePricePaise: serializer.fromJson<int>(json['purchasePricePaise']),
      sellingPricePaise: serializer.fromJson<int>(json['sellingPricePaise']),
      stockQty: serializer.fromJson<double>(json['stockQty']),
      minStockQty: serializer.fromJson<double>(json['minStockQty']),
      supplierId: serializer.fromJson<int?>(json['supplierId']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sku': serializer.toJson<String>(sku),
      'barcode': serializer.toJson<String>(barcode),
      'category': serializer.toJson<String>(category),
      'unit': serializer.toJson<String>(unit),
      'purchasePricePaise': serializer.toJson<int>(purchasePricePaise),
      'sellingPricePaise': serializer.toJson<int>(sellingPricePaise),
      'stockQty': serializer.toJson<double>(stockQty),
      'minStockQty': serializer.toJson<double>(minStockQty),
      'supplierId': serializer.toJson<int?>(supplierId),
      'imagePath': serializer.toJson<String?>(imagePath),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith({
    int? id,
    String? name,
    String? sku,
    String? barcode,
    String? category,
    String? unit,
    int? purchasePricePaise,
    int? sellingPricePaise,
    double? stockQty,
    double? minStockQty,
    Value<int?> supplierId = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    sku: sku ?? this.sku,
    barcode: barcode ?? this.barcode,
    category: category ?? this.category,
    unit: unit ?? this.unit,
    purchasePricePaise: purchasePricePaise ?? this.purchasePricePaise,
    sellingPricePaise: sellingPricePaise ?? this.sellingPricePaise,
    stockQty: stockQty ?? this.stockQty,
    minStockQty: minStockQty ?? this.minStockQty,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sku: data.sku.present ? data.sku.value : this.sku,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      category: data.category.present ? data.category.value : this.category,
      unit: data.unit.present ? data.unit.value : this.unit,
      purchasePricePaise: data.purchasePricePaise.present
          ? data.purchasePricePaise.value
          : this.purchasePricePaise,
      sellingPricePaise: data.sellingPricePaise.present
          ? data.sellingPricePaise.value
          : this.sellingPricePaise,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      minStockQty: data.minStockQty.present
          ? data.minStockQty.value
          : this.minStockQty,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('purchasePricePaise: $purchasePricePaise, ')
          ..write('sellingPricePaise: $sellingPricePaise, ')
          ..write('stockQty: $stockQty, ')
          ..write('minStockQty: $minStockQty, ')
          ..write('supplierId: $supplierId, ')
          ..write('imagePath: $imagePath, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    sku,
    barcode,
    category,
    unit,
    purchasePricePaise,
    sellingPricePaise,
    stockQty,
    minStockQty,
    supplierId,
    imagePath,
    archived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.sku == this.sku &&
          other.barcode == this.barcode &&
          other.category == this.category &&
          other.unit == this.unit &&
          other.purchasePricePaise == this.purchasePricePaise &&
          other.sellingPricePaise == this.sellingPricePaise &&
          other.stockQty == this.stockQty &&
          other.minStockQty == this.minStockQty &&
          other.supplierId == this.supplierId &&
          other.imagePath == this.imagePath &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> sku;
  final Value<String> barcode;
  final Value<String> category;
  final Value<String> unit;
  final Value<int> purchasePricePaise;
  final Value<int> sellingPricePaise;
  final Value<double> stockQty;
  final Value<double> minStockQty;
  final Value<int?> supplierId;
  final Value<String?> imagePath;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sku = const Value.absent(),
    this.barcode = const Value.absent(),
    this.category = const Value.absent(),
    this.unit = const Value.absent(),
    this.purchasePricePaise = const Value.absent(),
    this.sellingPricePaise = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.minStockQty = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String sku,
    required String barcode,
    required String category,
    required String unit,
    this.purchasePricePaise = const Value.absent(),
    this.sellingPricePaise = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.minStockQty = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.archived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       sku = Value(sku),
       barcode = Value(barcode),
       category = Value(category),
       unit = Value(unit),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? sku,
    Expression<String>? barcode,
    Expression<String>? category,
    Expression<String>? unit,
    Expression<int>? purchasePricePaise,
    Expression<int>? sellingPricePaise,
    Expression<double>? stockQty,
    Expression<double>? minStockQty,
    Expression<int>? supplierId,
    Expression<String>? imagePath,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sku != null) 'sku': sku,
      if (barcode != null) 'barcode': barcode,
      if (category != null) 'category': category,
      if (unit != null) 'unit': unit,
      if (purchasePricePaise != null)
        'purchase_price_paise': purchasePricePaise,
      if (sellingPricePaise != null) 'selling_price_paise': sellingPricePaise,
      if (stockQty != null) 'stock_qty': stockQty,
      if (minStockQty != null) 'min_stock_qty': minStockQty,
      if (supplierId != null) 'supplier_id': supplierId,
      if (imagePath != null) 'image_path': imagePath,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? sku,
    Value<String>? barcode,
    Value<String>? category,
    Value<String>? unit,
    Value<int>? purchasePricePaise,
    Value<int>? sellingPricePaise,
    Value<double>? stockQty,
    Value<double>? minStockQty,
    Value<int?>? supplierId,
    Value<String?>? imagePath,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      purchasePricePaise: purchasePricePaise ?? this.purchasePricePaise,
      sellingPricePaise: sellingPricePaise ?? this.sellingPricePaise,
      stockQty: stockQty ?? this.stockQty,
      minStockQty: minStockQty ?? this.minStockQty,
      supplierId: supplierId ?? this.supplierId,
      imagePath: imagePath ?? this.imagePath,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (purchasePricePaise.present) {
      map['purchase_price_paise'] = Variable<int>(purchasePricePaise.value);
    }
    if (sellingPricePaise.present) {
      map['selling_price_paise'] = Variable<int>(sellingPricePaise.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<double>(stockQty.value);
    }
    if (minStockQty.present) {
      map['min_stock_qty'] = Variable<double>(minStockQty.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('barcode: $barcode, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('purchasePricePaise: $purchasePricePaise, ')
          ..write('sellingPricePaise: $sellingPricePaise, ')
          ..write('stockQty: $stockQty, ')
          ..write('minStockQty: $minStockQty, ')
          ..write('supplierId: $supplierId, ')
          ..write('imagePath: $imagePath, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<StockMovementKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<StockMovementKind>($StockMovementsTable.$converterkind);
  static const VerificationMeta _quantityDeltaMeta = const VerificationMeta(
    'quantityDelta',
  );
  @override
  late final GeneratedColumn<double> quantityDelta = GeneratedColumn<double>(
    'quantity_delta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostPaiseMeta = const VerificationMeta(
    'unitCostPaise',
  );
  @override
  late final GeneratedColumn<int> unitCostPaise = GeneratedColumn<int>(
    'unit_cost_paise',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 240,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceTypeMeta = const VerificationMeta(
    'referenceType',
  );
  @override
  late final GeneratedColumn<String> referenceType = GeneratedColumn<String>(
    'reference_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<int> referenceId = GeneratedColumn<int>(
    'reference_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    kind,
    quantityDelta,
    unitCostPaise,
    reason,
    referenceType,
    referenceId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockMovement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity_delta')) {
      context.handle(
        _quantityDeltaMeta,
        quantityDelta.isAcceptableOrUnknown(
          data['quantity_delta']!,
          _quantityDeltaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityDeltaMeta);
    }
    if (data.containsKey('unit_cost_paise')) {
      context.handle(
        _unitCostPaiseMeta,
        unitCostPaise.isAcceptableOrUnknown(
          data['unit_cost_paise']!,
          _unitCostPaiseMeta,
        ),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('reference_type')) {
      context.handle(
        _referenceTypeMeta,
        referenceType.isAcceptableOrUnknown(
          data['reference_type']!,
          _referenceTypeMeta,
        ),
      );
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      kind: $StockMovementsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      quantityDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_delta'],
      )!,
      unitCostPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_paise'],
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      referenceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_type'],
      ),
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reference_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StockMovementKind, String, String> $converterkind =
      const EnumNameConverter<StockMovementKind>(StockMovementKind.values);
}

class StockMovement extends DataClass implements Insertable<StockMovement> {
  final int id;
  final int productId;
  final StockMovementKind kind;
  final double quantityDelta;
  final int? unitCostPaise;
  final String reason;
  final String? referenceType;
  final int? referenceId;
  final DateTime createdAt;
  const StockMovement({
    required this.id,
    required this.productId,
    required this.kind,
    required this.quantityDelta,
    this.unitCostPaise,
    required this.reason,
    this.referenceType,
    this.referenceId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    {
      map['kind'] = Variable<String>(
        $StockMovementsTable.$converterkind.toSql(kind),
      );
    }
    map['quantity_delta'] = Variable<double>(quantityDelta);
    if (!nullToAbsent || unitCostPaise != null) {
      map['unit_cost_paise'] = Variable<int>(unitCostPaise);
    }
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || referenceType != null) {
      map['reference_type'] = Variable<String>(referenceType);
    }
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<int>(referenceId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      productId: Value(productId),
      kind: Value(kind),
      quantityDelta: Value(quantityDelta),
      unitCostPaise: unitCostPaise == null && nullToAbsent
          ? const Value.absent()
          : Value(unitCostPaise),
      reason: Value(reason),
      referenceType: referenceType == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceType),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      createdAt: Value(createdAt),
    );
  }

  factory StockMovement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovement(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      kind: $StockMovementsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      quantityDelta: serializer.fromJson<double>(json['quantityDelta']),
      unitCostPaise: serializer.fromJson<int?>(json['unitCostPaise']),
      reason: serializer.fromJson<String>(json['reason']),
      referenceType: serializer.fromJson<String?>(json['referenceType']),
      referenceId: serializer.fromJson<int?>(json['referenceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'kind': serializer.toJson<String>(
        $StockMovementsTable.$converterkind.toJson(kind),
      ),
      'quantityDelta': serializer.toJson<double>(quantityDelta),
      'unitCostPaise': serializer.toJson<int?>(unitCostPaise),
      'reason': serializer.toJson<String>(reason),
      'referenceType': serializer.toJson<String?>(referenceType),
      'referenceId': serializer.toJson<int?>(referenceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockMovement copyWith({
    int? id,
    int? productId,
    StockMovementKind? kind,
    double? quantityDelta,
    Value<int?> unitCostPaise = const Value.absent(),
    String? reason,
    Value<String?> referenceType = const Value.absent(),
    Value<int?> referenceId = const Value.absent(),
    DateTime? createdAt,
  }) => StockMovement(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    kind: kind ?? this.kind,
    quantityDelta: quantityDelta ?? this.quantityDelta,
    unitCostPaise: unitCostPaise.present
        ? unitCostPaise.value
        : this.unitCostPaise,
    reason: reason ?? this.reason,
    referenceType: referenceType.present
        ? referenceType.value
        : this.referenceType,
    referenceId: referenceId.present ? referenceId.value : this.referenceId,
    createdAt: createdAt ?? this.createdAt,
  );
  StockMovement copyWithCompanion(StockMovementsCompanion data) {
    return StockMovement(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      kind: data.kind.present ? data.kind.value : this.kind,
      quantityDelta: data.quantityDelta.present
          ? data.quantityDelta.value
          : this.quantityDelta,
      unitCostPaise: data.unitCostPaise.present
          ? data.unitCostPaise.value
          : this.unitCostPaise,
      reason: data.reason.present ? data.reason.value : this.reason,
      referenceType: data.referenceType.present
          ? data.referenceType.value
          : this.referenceType,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovement(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('kind: $kind, ')
          ..write('quantityDelta: $quantityDelta, ')
          ..write('unitCostPaise: $unitCostPaise, ')
          ..write('reason: $reason, ')
          ..write('referenceType: $referenceType, ')
          ..write('referenceId: $referenceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    kind,
    quantityDelta,
    unitCostPaise,
    reason,
    referenceType,
    referenceId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovement &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.kind == this.kind &&
          other.quantityDelta == this.quantityDelta &&
          other.unitCostPaise == this.unitCostPaise &&
          other.reason == this.reason &&
          other.referenceType == this.referenceType &&
          other.referenceId == this.referenceId &&
          other.createdAt == this.createdAt);
}

class StockMovementsCompanion extends UpdateCompanion<StockMovement> {
  final Value<int> id;
  final Value<int> productId;
  final Value<StockMovementKind> kind;
  final Value<double> quantityDelta;
  final Value<int?> unitCostPaise;
  final Value<String> reason;
  final Value<String?> referenceType;
  final Value<int?> referenceId;
  final Value<DateTime> createdAt;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.kind = const Value.absent(),
    this.quantityDelta = const Value.absent(),
    this.unitCostPaise = const Value.absent(),
    this.reason = const Value.absent(),
    this.referenceType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required StockMovementKind kind,
    required double quantityDelta,
    this.unitCostPaise = const Value.absent(),
    required String reason,
    this.referenceType = const Value.absent(),
    this.referenceId = const Value.absent(),
    required DateTime createdAt,
  }) : productId = Value(productId),
       kind = Value(kind),
       quantityDelta = Value(quantityDelta),
       reason = Value(reason),
       createdAt = Value(createdAt);
  static Insertable<StockMovement> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<String>? kind,
    Expression<double>? quantityDelta,
    Expression<int>? unitCostPaise,
    Expression<String>? reason,
    Expression<String>? referenceType,
    Expression<int>? referenceId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (kind != null) 'kind': kind,
      if (quantityDelta != null) 'quantity_delta': quantityDelta,
      if (unitCostPaise != null) 'unit_cost_paise': unitCostPaise,
      if (reason != null) 'reason': reason,
      if (referenceType != null) 'reference_type': referenceType,
      if (referenceId != null) 'reference_id': referenceId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StockMovementsCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<StockMovementKind>? kind,
    Value<double>? quantityDelta,
    Value<int?>? unitCostPaise,
    Value<String>? reason,
    Value<String?>? referenceType,
    Value<int?>? referenceId,
    Value<DateTime>? createdAt,
  }) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      kind: kind ?? this.kind,
      quantityDelta: quantityDelta ?? this.quantityDelta,
      unitCostPaise: unitCostPaise ?? this.unitCostPaise,
      reason: reason ?? this.reason,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $StockMovementsTable.$converterkind.toSql(kind.value),
      );
    }
    if (quantityDelta.present) {
      map['quantity_delta'] = Variable<double>(quantityDelta.value);
    }
    if (unitCostPaise.present) {
      map['unit_cost_paise'] = Variable<int>(unitCostPaise.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (referenceType.present) {
      map['reference_type'] = Variable<String>(referenceType.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<int>(referenceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('kind: $kind, ')
          ..write('quantityDelta: $quantityDelta, ')
          ..write('unitCostPaise: $unitCostPaise, ')
          ..write('reason: $reason, ')
          ..write('referenceType: $referenceType, ')
          ..write('referenceId: $referenceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TransactionKind>($TransactionsTable.$converterkind);
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashDeltaPaiseMeta = const VerificationMeta(
    'cashDeltaPaise',
  );
  @override
  late final GeneratedColumn<int> cashDeltaPaise = GeneratedColumn<int>(
    'cash_delta_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditDeltaPaiseMeta = const VerificationMeta(
    'creditDeltaPaise',
  );
  @override
  late final GeneratedColumn<int> creditDeltaPaise = GeneratedColumn<int>(
    'credit_delta_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES suppliers (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMethod, String> method =
      GeneratedColumn<String>(
        'method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PaymentMethod>($TransactionsTable.$convertermethod);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EntrySource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EntrySource>($TransactionsTable.$convertersource);
  static const VerificationMeta _externalRefMeta = const VerificationMeta(
    'externalRef',
  );
  @override
  late final GeneratedColumn<String> externalRef = GeneratedColumn<String>(
    'external_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isReversedMeta = const VerificationMeta(
    'isReversed',
  );
  @override
  late final GeneratedColumn<bool> isReversed = GeneratedColumn<bool>(
    'is_reversed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_reversed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reversalOfIdMeta = const VerificationMeta(
    'reversalOfId',
  );
  @override
  late final GeneratedColumn<int> reversalOfId = GeneratedColumn<int>(
    'reversal_of_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    amountPaise,
    cashDeltaPaise,
    creditDeltaPaise,
    customerId,
    supplierId,
    method,
    note,
    source,
    externalRef,
    occurredAt,
    createdAt,
    isReversed,
    reversalOfId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('cash_delta_paise')) {
      context.handle(
        _cashDeltaPaiseMeta,
        cashDeltaPaise.isAcceptableOrUnknown(
          data['cash_delta_paise']!,
          _cashDeltaPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cashDeltaPaiseMeta);
    }
    if (data.containsKey('credit_delta_paise')) {
      context.handle(
        _creditDeltaPaiseMeta,
        creditDeltaPaise.isAcceptableOrUnknown(
          data['credit_delta_paise']!,
          _creditDeltaPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creditDeltaPaiseMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('external_ref')) {
      context.handle(
        _externalRefMeta,
        externalRef.isAcceptableOrUnknown(
          data['external_ref']!,
          _externalRefMeta,
        ),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_reversed')) {
      context.handle(
        _isReversedMeta,
        isReversed.isAcceptableOrUnknown(data['is_reversed']!, _isReversedMeta),
      );
    }
    if (data.containsKey('reversal_of_id')) {
      context.handle(
        _reversalOfIdMeta,
        reversalOfId.isAcceptableOrUnknown(
          data['reversal_of_id']!,
          _reversalOfIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $TransactionsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      cashDeltaPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cash_delta_paise'],
      )!,
      creditDeltaPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_delta_paise'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      ),
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}supplier_id'],
      ),
      method: $TransactionsTable.$convertermethod.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}method'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      source: $TransactionsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      externalRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_ref'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isReversed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_reversed'],
      )!,
      reversalOfId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reversal_of_id'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionKind, String, String> $converterkind =
      const EnumNameConverter<TransactionKind>(TransactionKind.values);
  static JsonTypeConverter2<PaymentMethod, String, String> $convertermethod =
      const EnumNameConverter<PaymentMethod>(PaymentMethod.values);
  static JsonTypeConverter2<EntrySource, String, String> $convertersource =
      const EnumNameConverter<EntrySource>(EntrySource.values);
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final TransactionKind kind;
  final int amountPaise;
  final int cashDeltaPaise;
  final int creditDeltaPaise;
  final int? customerId;
  final int? supplierId;
  final PaymentMethod method;
  final String note;
  final EntrySource source;
  final String? externalRef;
  final DateTime occurredAt;
  final DateTime createdAt;
  final bool isReversed;
  final int? reversalOfId;
  const Transaction({
    required this.id,
    required this.kind,
    required this.amountPaise,
    required this.cashDeltaPaise,
    required this.creditDeltaPaise,
    this.customerId,
    this.supplierId,
    required this.method,
    required this.note,
    required this.source,
    this.externalRef,
    required this.occurredAt,
    required this.createdAt,
    required this.isReversed,
    this.reversalOfId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<String>(
        $TransactionsTable.$converterkind.toSql(kind),
      );
    }
    map['amount_paise'] = Variable<int>(amountPaise);
    map['cash_delta_paise'] = Variable<int>(cashDeltaPaise);
    map['credit_delta_paise'] = Variable<int>(creditDeltaPaise);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<int>(supplierId);
    }
    {
      map['method'] = Variable<String>(
        $TransactionsTable.$convertermethod.toSql(method),
      );
    }
    map['note'] = Variable<String>(note);
    {
      map['source'] = Variable<String>(
        $TransactionsTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || externalRef != null) {
      map['external_ref'] = Variable<String>(externalRef);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_reversed'] = Variable<bool>(isReversed);
    if (!nullToAbsent || reversalOfId != null) {
      map['reversal_of_id'] = Variable<int>(reversalOfId);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      kind: Value(kind),
      amountPaise: Value(amountPaise),
      cashDeltaPaise: Value(cashDeltaPaise),
      creditDeltaPaise: Value(creditDeltaPaise),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      method: Value(method),
      note: Value(note),
      source: Value(source),
      externalRef: externalRef == null && nullToAbsent
          ? const Value.absent()
          : Value(externalRef),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
      isReversed: Value(isReversed),
      reversalOfId: reversalOfId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversalOfId),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      kind: $TransactionsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      cashDeltaPaise: serializer.fromJson<int>(json['cashDeltaPaise']),
      creditDeltaPaise: serializer.fromJson<int>(json['creditDeltaPaise']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      supplierId: serializer.fromJson<int?>(json['supplierId']),
      method: $TransactionsTable.$convertermethod.fromJson(
        serializer.fromJson<String>(json['method']),
      ),
      note: serializer.fromJson<String>(json['note']),
      source: $TransactionsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      externalRef: serializer.fromJson<String?>(json['externalRef']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isReversed: serializer.fromJson<bool>(json['isReversed']),
      reversalOfId: serializer.fromJson<int?>(json['reversalOfId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(
        $TransactionsTable.$converterkind.toJson(kind),
      ),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'cashDeltaPaise': serializer.toJson<int>(cashDeltaPaise),
      'creditDeltaPaise': serializer.toJson<int>(creditDeltaPaise),
      'customerId': serializer.toJson<int?>(customerId),
      'supplierId': serializer.toJson<int?>(supplierId),
      'method': serializer.toJson<String>(
        $TransactionsTable.$convertermethod.toJson(method),
      ),
      'note': serializer.toJson<String>(note),
      'source': serializer.toJson<String>(
        $TransactionsTable.$convertersource.toJson(source),
      ),
      'externalRef': serializer.toJson<String?>(externalRef),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isReversed': serializer.toJson<bool>(isReversed),
      'reversalOfId': serializer.toJson<int?>(reversalOfId),
    };
  }

  Transaction copyWith({
    int? id,
    TransactionKind? kind,
    int? amountPaise,
    int? cashDeltaPaise,
    int? creditDeltaPaise,
    Value<int?> customerId = const Value.absent(),
    Value<int?> supplierId = const Value.absent(),
    PaymentMethod? method,
    String? note,
    EntrySource? source,
    Value<String?> externalRef = const Value.absent(),
    DateTime? occurredAt,
    DateTime? createdAt,
    bool? isReversed,
    Value<int?> reversalOfId = const Value.absent(),
  }) => Transaction(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    amountPaise: amountPaise ?? this.amountPaise,
    cashDeltaPaise: cashDeltaPaise ?? this.cashDeltaPaise,
    creditDeltaPaise: creditDeltaPaise ?? this.creditDeltaPaise,
    customerId: customerId.present ? customerId.value : this.customerId,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    method: method ?? this.method,
    note: note ?? this.note,
    source: source ?? this.source,
    externalRef: externalRef.present ? externalRef.value : this.externalRef,
    occurredAt: occurredAt ?? this.occurredAt,
    createdAt: createdAt ?? this.createdAt,
    isReversed: isReversed ?? this.isReversed,
    reversalOfId: reversalOfId.present ? reversalOfId.value : this.reversalOfId,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      cashDeltaPaise: data.cashDeltaPaise.present
          ? data.cashDeltaPaise.value
          : this.cashDeltaPaise,
      creditDeltaPaise: data.creditDeltaPaise.present
          ? data.creditDeltaPaise.value
          : this.creditDeltaPaise,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      method: data.method.present ? data.method.value : this.method,
      note: data.note.present ? data.note.value : this.note,
      source: data.source.present ? data.source.value : this.source,
      externalRef: data.externalRef.present
          ? data.externalRef.value
          : this.externalRef,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isReversed: data.isReversed.present
          ? data.isReversed.value
          : this.isReversed,
      reversalOfId: data.reversalOfId.present
          ? data.reversalOfId.value
          : this.reversalOfId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('cashDeltaPaise: $cashDeltaPaise, ')
          ..write('creditDeltaPaise: $creditDeltaPaise, ')
          ..write('customerId: $customerId, ')
          ..write('supplierId: $supplierId, ')
          ..write('method: $method, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('externalRef: $externalRef, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isReversed: $isReversed, ')
          ..write('reversalOfId: $reversalOfId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    amountPaise,
    cashDeltaPaise,
    creditDeltaPaise,
    customerId,
    supplierId,
    method,
    note,
    source,
    externalRef,
    occurredAt,
    createdAt,
    isReversed,
    reversalOfId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.amountPaise == this.amountPaise &&
          other.cashDeltaPaise == this.cashDeltaPaise &&
          other.creditDeltaPaise == this.creditDeltaPaise &&
          other.customerId == this.customerId &&
          other.supplierId == this.supplierId &&
          other.method == this.method &&
          other.note == this.note &&
          other.source == this.source &&
          other.externalRef == this.externalRef &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt &&
          other.isReversed == this.isReversed &&
          other.reversalOfId == this.reversalOfId);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<TransactionKind> kind;
  final Value<int> amountPaise;
  final Value<int> cashDeltaPaise;
  final Value<int> creditDeltaPaise;
  final Value<int?> customerId;
  final Value<int?> supplierId;
  final Value<PaymentMethod> method;
  final Value<String> note;
  final Value<EntrySource> source;
  final Value<String?> externalRef;
  final Value<DateTime> occurredAt;
  final Value<DateTime> createdAt;
  final Value<bool> isReversed;
  final Value<int?> reversalOfId;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.cashDeltaPaise = const Value.absent(),
    this.creditDeltaPaise = const Value.absent(),
    this.customerId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.method = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.externalRef = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isReversed = const Value.absent(),
    this.reversalOfId = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required TransactionKind kind,
    required int amountPaise,
    required int cashDeltaPaise,
    required int creditDeltaPaise,
    this.customerId = const Value.absent(),
    this.supplierId = const Value.absent(),
    required PaymentMethod method,
    required String note,
    required EntrySource source,
    this.externalRef = const Value.absent(),
    required DateTime occurredAt,
    required DateTime createdAt,
    this.isReversed = const Value.absent(),
    this.reversalOfId = const Value.absent(),
  }) : kind = Value(kind),
       amountPaise = Value(amountPaise),
       cashDeltaPaise = Value(cashDeltaPaise),
       creditDeltaPaise = Value(creditDeltaPaise),
       method = Value(method),
       note = Value(note),
       source = Value(source),
       occurredAt = Value(occurredAt),
       createdAt = Value(createdAt);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<int>? amountPaise,
    Expression<int>? cashDeltaPaise,
    Expression<int>? creditDeltaPaise,
    Expression<int>? customerId,
    Expression<int>? supplierId,
    Expression<String>? method,
    Expression<String>? note,
    Expression<String>? source,
    Expression<String>? externalRef,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? createdAt,
    Expression<bool>? isReversed,
    Expression<int>? reversalOfId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (cashDeltaPaise != null) 'cash_delta_paise': cashDeltaPaise,
      if (creditDeltaPaise != null) 'credit_delta_paise': creditDeltaPaise,
      if (customerId != null) 'customer_id': customerId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (method != null) 'method': method,
      if (note != null) 'note': note,
      if (source != null) 'source': source,
      if (externalRef != null) 'external_ref': externalRef,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (isReversed != null) 'is_reversed': isReversed,
      if (reversalOfId != null) 'reversal_of_id': reversalOfId,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<TransactionKind>? kind,
    Value<int>? amountPaise,
    Value<int>? cashDeltaPaise,
    Value<int>? creditDeltaPaise,
    Value<int?>? customerId,
    Value<int?>? supplierId,
    Value<PaymentMethod>? method,
    Value<String>? note,
    Value<EntrySource>? source,
    Value<String?>? externalRef,
    Value<DateTime>? occurredAt,
    Value<DateTime>? createdAt,
    Value<bool>? isReversed,
    Value<int?>? reversalOfId,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      amountPaise: amountPaise ?? this.amountPaise,
      cashDeltaPaise: cashDeltaPaise ?? this.cashDeltaPaise,
      creditDeltaPaise: creditDeltaPaise ?? this.creditDeltaPaise,
      customerId: customerId ?? this.customerId,
      supplierId: supplierId ?? this.supplierId,
      method: method ?? this.method,
      note: note ?? this.note,
      source: source ?? this.source,
      externalRef: externalRef ?? this.externalRef,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      isReversed: isReversed ?? this.isReversed,
      reversalOfId: reversalOfId ?? this.reversalOfId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $TransactionsTable.$converterkind.toSql(kind.value),
      );
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (cashDeltaPaise.present) {
      map['cash_delta_paise'] = Variable<int>(cashDeltaPaise.value);
    }
    if (creditDeltaPaise.present) {
      map['credit_delta_paise'] = Variable<int>(creditDeltaPaise.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(
        $TransactionsTable.$convertermethod.toSql(method.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $TransactionsTable.$convertersource.toSql(source.value),
      );
    }
    if (externalRef.present) {
      map['external_ref'] = Variable<String>(externalRef.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isReversed.present) {
      map['is_reversed'] = Variable<bool>(isReversed.value);
    }
    if (reversalOfId.present) {
      map['reversal_of_id'] = Variable<int>(reversalOfId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('cashDeltaPaise: $cashDeltaPaise, ')
          ..write('creditDeltaPaise: $creditDeltaPaise, ')
          ..write('customerId: $customerId, ')
          ..write('supplierId: $supplierId, ')
          ..write('method: $method, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('externalRef: $externalRef, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isReversed: $isReversed, ')
          ..write('reversalOfId: $reversalOfId')
          ..write(')'))
        .toString();
  }
}

class $TransactionLinesTable extends TransactionLines
    with TableInfo<$TransactionLinesTable, TransactionLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPricePaiseMeta = const VerificationMeta(
    'unitPricePaise',
  );
  @override
  late final GeneratedColumn<int> unitPricePaise = GeneratedColumn<int>(
    'unit_price_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostPaiseMeta = const VerificationMeta(
    'unitCostPaise',
  );
  @override
  late final GeneratedColumn<int> unitCostPaise = GeneratedColumn<int>(
    'unit_cost_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    productId,
    quantity,
    unitPricePaise,
    unitCostPaise,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price_paise')) {
      context.handle(
        _unitPricePaiseMeta,
        unitPricePaise.isAcceptableOrUnknown(
          data['unit_price_paise']!,
          _unitPricePaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPricePaiseMeta);
    }
    if (data.containsKey('unit_cost_paise')) {
      context.handle(
        _unitCostPaiseMeta,
        unitCostPaise.isAcceptableOrUnknown(
          data['unit_cost_paise']!,
          _unitCostPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitCostPaiseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitPricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_paise'],
      )!,
      unitCostPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_paise'],
      )!,
    );
  }

  @override
  $TransactionLinesTable createAlias(String alias) {
    return $TransactionLinesTable(attachedDatabase, alias);
  }
}

class TransactionLine extends DataClass implements Insertable<TransactionLine> {
  final int id;
  final int transactionId;
  final int productId;
  final double quantity;
  final int unitPricePaise;
  final int unitCostPaise;
  const TransactionLine({
    required this.id,
    required this.transactionId,
    required this.productId,
    required this.quantity,
    required this.unitPricePaise,
    required this.unitCostPaise,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<double>(quantity);
    map['unit_price_paise'] = Variable<int>(unitPricePaise);
    map['unit_cost_paise'] = Variable<int>(unitCostPaise);
    return map;
  }

  TransactionLinesCompanion toCompanion(bool nullToAbsent) {
    return TransactionLinesCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitPricePaise: Value(unitPricePaise),
      unitCostPaise: Value(unitCostPaise),
    );
  }

  factory TransactionLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionLine(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPricePaise: serializer.fromJson<int>(json['unitPricePaise']),
      unitCostPaise: serializer.fromJson<int>(json['unitCostPaise']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<double>(quantity),
      'unitPricePaise': serializer.toJson<int>(unitPricePaise),
      'unitCostPaise': serializer.toJson<int>(unitCostPaise),
    };
  }

  TransactionLine copyWith({
    int? id,
    int? transactionId,
    int? productId,
    double? quantity,
    int? unitPricePaise,
    int? unitCostPaise,
  }) => TransactionLine(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    unitPricePaise: unitPricePaise ?? this.unitPricePaise,
    unitCostPaise: unitCostPaise ?? this.unitCostPaise,
  );
  TransactionLine copyWithCompanion(TransactionLinesCompanion data) {
    return TransactionLine(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPricePaise: data.unitPricePaise.present
          ? data.unitPricePaise.value
          : this.unitPricePaise,
      unitCostPaise: data.unitCostPaise.present
          ? data.unitCostPaise.value
          : this.unitCostPaise,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionLine(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPricePaise: $unitPricePaise, ')
          ..write('unitCostPaise: $unitCostPaise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionId,
    productId,
    quantity,
    unitPricePaise,
    unitCostPaise,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionLine &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitPricePaise == this.unitPricePaise &&
          other.unitCostPaise == this.unitCostPaise);
}

class TransactionLinesCompanion extends UpdateCompanion<TransactionLine> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int> productId;
  final Value<double> quantity;
  final Value<int> unitPricePaise;
  final Value<int> unitCostPaise;
  const TransactionLinesCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPricePaise = const Value.absent(),
    this.unitCostPaise = const Value.absent(),
  });
  TransactionLinesCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    required int productId,
    required double quantity,
    required int unitPricePaise,
    required int unitCostPaise,
  }) : transactionId = Value(transactionId),
       productId = Value(productId),
       quantity = Value(quantity),
       unitPricePaise = Value(unitPricePaise),
       unitCostPaise = Value(unitCostPaise);
  static Insertable<TransactionLine> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? productId,
    Expression<double>? quantity,
    Expression<int>? unitPricePaise,
    Expression<int>? unitCostPaise,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitPricePaise != null) 'unit_price_paise': unitPricePaise,
      if (unitCostPaise != null) 'unit_cost_paise': unitCostPaise,
    });
  }

  TransactionLinesCompanion copyWith({
    Value<int>? id,
    Value<int>? transactionId,
    Value<int>? productId,
    Value<double>? quantity,
    Value<int>? unitPricePaise,
    Value<int>? unitCostPaise,
  }) {
    return TransactionLinesCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPricePaise: unitPricePaise ?? this.unitPricePaise,
      unitCostPaise: unitCostPaise ?? this.unitCostPaise,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPricePaise.present) {
      map['unit_price_paise'] = Variable<int>(unitPricePaise.value);
    }
    if (unitCostPaise.present) {
      map['unit_cost_paise'] = Variable<int>(unitCostPaise.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionLinesCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPricePaise: $unitPricePaise, ')
          ..write('unitCostPaise: $unitCostPaise')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
    'supplier_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES suppliers (id)',
    ),
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPaiseMeta = const VerificationMeta(
    'totalPaise',
  );
  @override
  late final GeneratedColumn<int> totalPaise = GeneratedColumn<int>(
    'total_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidPaiseMeta = const VerificationMeta(
    'paidPaise',
  );
  @override
  late final GeneratedColumn<int> paidPaise = GeneratedColumn<int>(
    'paid_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    supplierId,
    invoiceNumber,
    totalPaise,
    paidPaise,
    note,
    occurredAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<Purchase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('total_paise')) {
      context.handle(
        _totalPaiseMeta,
        totalPaise.isAcceptableOrUnknown(data['total_paise']!, _totalPaiseMeta),
      );
    } else if (isInserting) {
      context.missing(_totalPaiseMeta);
    }
    if (data.containsKey('paid_paise')) {
      context.handle(
        _paidPaiseMeta,
        paidPaise.isAcceptableOrUnknown(data['paid_paise']!, _paidPaiseMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}supplier_id'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      )!,
      totalPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_paise'],
      )!,
      paidPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_paise'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final int id;
  final int supplierId;
  final String invoiceNumber;
  final int totalPaise;
  final int paidPaise;
  final String note;
  final DateTime occurredAt;
  final DateTime createdAt;
  const Purchase({
    required this.id,
    required this.supplierId,
    required this.invoiceNumber,
    required this.totalPaise,
    required this.paidPaise,
    required this.note,
    required this.occurredAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['supplier_id'] = Variable<int>(supplierId);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['total_paise'] = Variable<int>(totalPaise);
    map['paid_paise'] = Variable<int>(paidPaise);
    map['note'] = Variable<String>(note);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      supplierId: Value(supplierId),
      invoiceNumber: Value(invoiceNumber),
      totalPaise: Value(totalPaise),
      paidPaise: Value(paidPaise),
      note: Value(note),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
    );
  }

  factory Purchase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<int>(json['id']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      totalPaise: serializer.fromJson<int>(json['totalPaise']),
      paidPaise: serializer.fromJson<int>(json['paidPaise']),
      note: serializer.fromJson<String>(json['note']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'supplierId': serializer.toJson<int>(supplierId),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'totalPaise': serializer.toJson<int>(totalPaise),
      'paidPaise': serializer.toJson<int>(paidPaise),
      'note': serializer.toJson<String>(note),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Purchase copyWith({
    int? id,
    int? supplierId,
    String? invoiceNumber,
    int? totalPaise,
    int? paidPaise,
    String? note,
    DateTime? occurredAt,
    DateTime? createdAt,
  }) => Purchase(
    id: id ?? this.id,
    supplierId: supplierId ?? this.supplierId,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    totalPaise: totalPaise ?? this.totalPaise,
    paidPaise: paidPaise ?? this.paidPaise,
    note: note ?? this.note,
    occurredAt: occurredAt ?? this.occurredAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      totalPaise: data.totalPaise.present
          ? data.totalPaise.value
          : this.totalPaise,
      paidPaise: data.paidPaise.present ? data.paidPaise.value : this.paidPaise,
      note: data.note.present ? data.note.value : this.note,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('paidPaise: $paidPaise, ')
          ..write('note: $note, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    supplierId,
    invoiceNumber,
    totalPaise,
    paidPaise,
    note,
    occurredAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.invoiceNumber == this.invoiceNumber &&
          other.totalPaise == this.totalPaise &&
          other.paidPaise == this.paidPaise &&
          other.note == this.note &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<int> id;
  final Value<int> supplierId;
  final Value<String> invoiceNumber;
  final Value<int> totalPaise;
  final Value<int> paidPaise;
  final Value<String> note;
  final Value<DateTime> occurredAt;
  final Value<DateTime> createdAt;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.totalPaise = const Value.absent(),
    this.paidPaise = const Value.absent(),
    this.note = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PurchasesCompanion.insert({
    this.id = const Value.absent(),
    required int supplierId,
    required String invoiceNumber,
    required int totalPaise,
    this.paidPaise = const Value.absent(),
    required String note,
    required DateTime occurredAt,
    required DateTime createdAt,
  }) : supplierId = Value(supplierId),
       invoiceNumber = Value(invoiceNumber),
       totalPaise = Value(totalPaise),
       note = Value(note),
       occurredAt = Value(occurredAt),
       createdAt = Value(createdAt);
  static Insertable<Purchase> custom({
    Expression<int>? id,
    Expression<int>? supplierId,
    Expression<String>? invoiceNumber,
    Expression<int>? totalPaise,
    Expression<int>? paidPaise,
    Expression<String>? note,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (totalPaise != null) 'total_paise': totalPaise,
      if (paidPaise != null) 'paid_paise': paidPaise,
      if (note != null) 'note': note,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PurchasesCompanion copyWith({
    Value<int>? id,
    Value<int>? supplierId,
    Value<String>? invoiceNumber,
    Value<int>? totalPaise,
    Value<int>? paidPaise,
    Value<String>? note,
    Value<DateTime>? occurredAt,
    Value<DateTime>? createdAt,
  }) {
    return PurchasesCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      totalPaise: totalPaise ?? this.totalPaise,
      paidPaise: paidPaise ?? this.paidPaise,
      note: note ?? this.note,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (totalPaise.present) {
      map['total_paise'] = Variable<int>(totalPaise.value);
    }
    if (paidPaise.present) {
      map['paid_paise'] = Variable<int>(paidPaise.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('paidPaise: $paidPaise, ')
          ..write('note: $note, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTable extends PurchaseItems
    with TableInfo<$PurchaseItemsTable, PurchaseItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<int> purchaseId = GeneratedColumn<int>(
    'purchase_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchases (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostPaiseMeta = const VerificationMeta(
    'unitCostPaise',
  );
  @override
  late final GeneratedColumn<int> unitCostPaise = GeneratedColumn<int>(
    'unit_cost_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseId,
    productId,
    quantity,
    unitCostPaise,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_cost_paise')) {
      context.handle(
        _unitCostPaiseMeta,
        unitCostPaise.isAcceptableOrUnknown(
          data['unit_cost_paise']!,
          _unitCostPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitCostPaiseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitCostPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_paise'],
      )!,
    );
  }

  @override
  $PurchaseItemsTable createAlias(String alias) {
    return $PurchaseItemsTable(attachedDatabase, alias);
  }
}

class PurchaseItem extends DataClass implements Insertable<PurchaseItem> {
  final int id;
  final int purchaseId;
  final int productId;
  final double quantity;
  final int unitCostPaise;
  const PurchaseItem({
    required this.id,
    required this.purchaseId,
    required this.productId,
    required this.quantity,
    required this.unitCostPaise,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_id'] = Variable<int>(purchaseId);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<double>(quantity);
    map['unit_cost_paise'] = Variable<int>(unitCostPaise);
    return map;
  }

  PurchaseItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitCostPaise: Value(unitCostPaise),
    );
  }

  factory PurchaseItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItem(
      id: serializer.fromJson<int>(json['id']),
      purchaseId: serializer.fromJson<int>(json['purchaseId']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitCostPaise: serializer.fromJson<int>(json['unitCostPaise']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseId': serializer.toJson<int>(purchaseId),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<double>(quantity),
      'unitCostPaise': serializer.toJson<int>(unitCostPaise),
    };
  }

  PurchaseItem copyWith({
    int? id,
    int? purchaseId,
    int? productId,
    double? quantity,
    int? unitCostPaise,
  }) => PurchaseItem(
    id: id ?? this.id,
    purchaseId: purchaseId ?? this.purchaseId,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    unitCostPaise: unitCostPaise ?? this.unitCostPaise,
  );
  PurchaseItem copyWithCompanion(PurchaseItemsCompanion data) {
    return PurchaseItem(
      id: data.id.present ? data.id.value : this.id,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitCostPaise: data.unitCostPaise.present
          ? data.unitCostPaise.value
          : this.unitCostPaise,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItem(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitCostPaise: $unitCostPaise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, purchaseId, productId, quantity, unitCostPaise);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItem &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitCostPaise == this.unitCostPaise);
}

class PurchaseItemsCompanion extends UpdateCompanion<PurchaseItem> {
  final Value<int> id;
  final Value<int> purchaseId;
  final Value<int> productId;
  final Value<double> quantity;
  final Value<int> unitCostPaise;
  const PurchaseItemsCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitCostPaise = const Value.absent(),
  });
  PurchaseItemsCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseId,
    required int productId,
    required double quantity,
    required int unitCostPaise,
  }) : purchaseId = Value(purchaseId),
       productId = Value(productId),
       quantity = Value(quantity),
       unitCostPaise = Value(unitCostPaise);
  static Insertable<PurchaseItem> custom({
    Expression<int>? id,
    Expression<int>? purchaseId,
    Expression<int>? productId,
    Expression<double>? quantity,
    Expression<int>? unitCostPaise,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitCostPaise != null) 'unit_cost_paise': unitCostPaise,
    });
  }

  PurchaseItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? purchaseId,
    Value<int>? productId,
    Value<double>? quantity,
    Value<int>? unitCostPaise,
  }) {
    return PurchaseItemsCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitCostPaise: unitCostPaise ?? this.unitCostPaise,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<int>(purchaseId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitCostPaise.present) {
      map['unit_cost_paise'] = Variable<int>(unitCostPaise.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitCostPaise: $unitCostPaise')
          ..write(')'))
        .toString();
  }
}

class $PayeesTable extends Payees with TableInfo<$PayeesTable, Payee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _walletAddressMeta = const VerificationMeta(
    'walletAddress',
  );
  @override
  late final GeneratedColumn<String> walletAddress = GeneratedColumn<String>(
    'wallet_address',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 32,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    walletAddress,
    archived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payees';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('wallet_address')) {
      context.handle(
        _walletAddressMeta,
        walletAddress.isAcceptableOrUnknown(
          data['wallet_address']!,
          _walletAddressMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_walletAddressMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payee(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      walletAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wallet_address'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PayeesTable createAlias(String alias) {
    return $PayeesTable(attachedDatabase, alias);
  }
}

class Payee extends DataClass implements Insertable<Payee> {
  final int id;
  final String name;
  final String walletAddress;
  final bool archived;
  final DateTime createdAt;
  const Payee({
    required this.id,
    required this.name,
    required this.walletAddress,
    required this.archived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['wallet_address'] = Variable<String>(walletAddress);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PayeesCompanion toCompanion(bool nullToAbsent) {
    return PayeesCompanion(
      id: Value(id),
      name: Value(name),
      walletAddress: Value(walletAddress),
      archived: Value(archived),
      createdAt: Value(createdAt),
    );
  }

  factory Payee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payee(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      walletAddress: serializer.fromJson<String>(json['walletAddress']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'walletAddress': serializer.toJson<String>(walletAddress),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Payee copyWith({
    int? id,
    String? name,
    String? walletAddress,
    bool? archived,
    DateTime? createdAt,
  }) => Payee(
    id: id ?? this.id,
    name: name ?? this.name,
    walletAddress: walletAddress ?? this.walletAddress,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
  );
  Payee copyWithCompanion(PayeesCompanion data) {
    return Payee(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      walletAddress: data.walletAddress.present
          ? data.walletAddress.value
          : this.walletAddress,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payee(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('walletAddress: $walletAddress, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, walletAddress, archived, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payee &&
          other.id == this.id &&
          other.name == this.name &&
          other.walletAddress == this.walletAddress &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt);
}

class PayeesCompanion extends UpdateCompanion<Payee> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> walletAddress;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  const PayeesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.walletAddress = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PayeesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String walletAddress,
    this.archived = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       walletAddress = Value(walletAddress),
       createdAt = Value(createdAt);
  static Insertable<Payee> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? walletAddress,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (walletAddress != null) 'wallet_address': walletAddress,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PayeesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? walletAddress,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
  }) {
    return PayeesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      walletAddress: walletAddress ?? this.walletAddress,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (walletAddress.present) {
      map['wallet_address'] = Variable<String>(walletAddress.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayeesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('walletAddress: $walletAddress, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SolanaPaymentsTable extends SolanaPayments
    with TableInfo<$SolanaPaymentsTable, SolanaPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SolanaPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 8,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _payeeIdMeta = const VerificationMeta(
    'payeeId',
  );
  @override
  late final GeneratedColumn<int> payeeId = GeneratedColumn<int>(
    'payee_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES payees (id)',
    ),
  );
  static const VerificationMeta _recipientNameMeta = const VerificationMeta(
    'recipientName',
  );
  @override
  late final GeneratedColumn<String> recipientName = GeneratedColumn<String>(
    'recipient_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipientAddressMeta = const VerificationMeta(
    'recipientAddress',
  );
  @override
  late final GeneratedColumn<String> recipientAddress = GeneratedColumn<String>(
    'recipient_address',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 32,
      maxTextLength: 64,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountLamportsMeta = const VerificationMeta(
    'amountLamports',
  );
  @override
  late final GeneratedColumn<int> amountLamports = GeneratedColumn<int>(
    'amount_lamports',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inrMemoPaiseMeta = const VerificationMeta(
    'inrMemoPaise',
  );
  @override
  late final GeneratedColumn<int> inrMemoPaise = GeneratedColumn<int>(
    'inr_memo_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _networkMeta = const VerificationMeta(
    'network',
  );
  @override
  late final GeneratedColumn<String> network = GeneratedColumn<String>(
    'network',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 4,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PaymentStatus>($SolanaPaymentsTable.$converterstatus);
  static const VerificationMeta _requestTextMeta = const VerificationMeta(
    'requestText',
  );
  @override
  late final GeneratedColumn<String> requestText = GeneratedColumn<String>(
    'request_text',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signatureMeta = const VerificationMeta(
    'signature',
  );
  @override
  late final GeneratedColumn<String> signature = GeneratedColumn<String>(
    'signature',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _explorerUrlMeta = const VerificationMeta(
    'explorerUrl',
  );
  @override
  late final GeneratedColumn<String> explorerUrl = GeneratedColumn<String>(
    'explorer_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ledgerTransactionIdMeta =
      const VerificationMeta('ledgerTransactionId');
  @override
  late final GeneratedColumn<int> ledgerTransactionId = GeneratedColumn<int>(
    'ledger_transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _policySnapshotJsonMeta =
      const VerificationMeta('policySnapshotJson');
  @override
  late final GeneratedColumn<String> policySnapshotJson =
      GeneratedColumn<String>(
        'policy_snapshot_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confirmedAtMeta = const VerificationMeta(
    'confirmedAt',
  );
  @override
  late final GeneratedColumn<DateTime> confirmedAt = GeneratedColumn<DateTime>(
    'confirmed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idempotencyKey,
    payeeId,
    recipientName,
    recipientAddress,
    amountLamports,
    inrMemoPaise,
    network,
    status,
    requestText,
    signature,
    explorerUrl,
    ledgerTransactionId,
    errorMessage,
    policySnapshotJson,
    createdAt,
    updatedAt,
    confirmedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'solana_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<SolanaPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('payee_id')) {
      context.handle(
        _payeeIdMeta,
        payeeId.isAcceptableOrUnknown(data['payee_id']!, _payeeIdMeta),
      );
    }
    if (data.containsKey('recipient_name')) {
      context.handle(
        _recipientNameMeta,
        recipientName.isAcceptableOrUnknown(
          data['recipient_name']!,
          _recipientNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientNameMeta);
    }
    if (data.containsKey('recipient_address')) {
      context.handle(
        _recipientAddressMeta,
        recipientAddress.isAcceptableOrUnknown(
          data['recipient_address']!,
          _recipientAddressMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientAddressMeta);
    }
    if (data.containsKey('amount_lamports')) {
      context.handle(
        _amountLamportsMeta,
        amountLamports.isAcceptableOrUnknown(
          data['amount_lamports']!,
          _amountLamportsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountLamportsMeta);
    }
    if (data.containsKey('inr_memo_paise')) {
      context.handle(
        _inrMemoPaiseMeta,
        inrMemoPaise.isAcceptableOrUnknown(
          data['inr_memo_paise']!,
          _inrMemoPaiseMeta,
        ),
      );
    }
    if (data.containsKey('network')) {
      context.handle(
        _networkMeta,
        network.isAcceptableOrUnknown(data['network']!, _networkMeta),
      );
    } else if (isInserting) {
      context.missing(_networkMeta);
    }
    if (data.containsKey('request_text')) {
      context.handle(
        _requestTextMeta,
        requestText.isAcceptableOrUnknown(
          data['request_text']!,
          _requestTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestTextMeta);
    }
    if (data.containsKey('signature')) {
      context.handle(
        _signatureMeta,
        signature.isAcceptableOrUnknown(data['signature']!, _signatureMeta),
      );
    }
    if (data.containsKey('explorer_url')) {
      context.handle(
        _explorerUrlMeta,
        explorerUrl.isAcceptableOrUnknown(
          data['explorer_url']!,
          _explorerUrlMeta,
        ),
      );
    }
    if (data.containsKey('ledger_transaction_id')) {
      context.handle(
        _ledgerTransactionIdMeta,
        ledgerTransactionId.isAcceptableOrUnknown(
          data['ledger_transaction_id']!,
          _ledgerTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('policy_snapshot_json')) {
      context.handle(
        _policySnapshotJsonMeta,
        policySnapshotJson.isAcceptableOrUnknown(
          data['policy_snapshot_json']!,
          _policySnapshotJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
        _confirmedAtMeta,
        confirmedAt.isAcceptableOrUnknown(
          data['confirmed_at']!,
          _confirmedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SolanaPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SolanaPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      payeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payee_id'],
      ),
      recipientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipient_name'],
      )!,
      recipientAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipient_address'],
      )!,
      amountLamports: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_lamports'],
      )!,
      inrMemoPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}inr_memo_paise'],
      )!,
      network: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network'],
      )!,
      status: $SolanaPaymentsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      requestText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_text'],
      )!,
      signature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signature'],
      ),
      explorerUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explorer_url'],
      ),
      ledgerTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ledger_transaction_id'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      policySnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}policy_snapshot_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      confirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}confirmed_at'],
      ),
    );
  }

  @override
  $SolanaPaymentsTable createAlias(String alias) {
    return $SolanaPaymentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentStatus, String, String> $converterstatus =
      const EnumNameConverter<PaymentStatus>(PaymentStatus.values);
}

class SolanaPayment extends DataClass implements Insertable<SolanaPayment> {
  final int id;
  final String idempotencyKey;
  final int? payeeId;
  final String recipientName;
  final String recipientAddress;
  final int amountLamports;

  /// Optional merchant-entered INR memo. Never derived from a price feed.
  final int inrMemoPaise;
  final String network;
  final PaymentStatus status;
  final String requestText;
  final String? signature;
  final String? explorerUrl;
  final int? ledgerTransactionId;
  final String? errorMessage;
  final String? policySnapshotJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? confirmedAt;
  const SolanaPayment({
    required this.id,
    required this.idempotencyKey,
    this.payeeId,
    required this.recipientName,
    required this.recipientAddress,
    required this.amountLamports,
    required this.inrMemoPaise,
    required this.network,
    required this.status,
    required this.requestText,
    this.signature,
    this.explorerUrl,
    this.ledgerTransactionId,
    this.errorMessage,
    this.policySnapshotJson,
    required this.createdAt,
    required this.updatedAt,
    this.confirmedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    if (!nullToAbsent || payeeId != null) {
      map['payee_id'] = Variable<int>(payeeId);
    }
    map['recipient_name'] = Variable<String>(recipientName);
    map['recipient_address'] = Variable<String>(recipientAddress);
    map['amount_lamports'] = Variable<int>(amountLamports);
    map['inr_memo_paise'] = Variable<int>(inrMemoPaise);
    map['network'] = Variable<String>(network);
    {
      map['status'] = Variable<String>(
        $SolanaPaymentsTable.$converterstatus.toSql(status),
      );
    }
    map['request_text'] = Variable<String>(requestText);
    if (!nullToAbsent || signature != null) {
      map['signature'] = Variable<String>(signature);
    }
    if (!nullToAbsent || explorerUrl != null) {
      map['explorer_url'] = Variable<String>(explorerUrl);
    }
    if (!nullToAbsent || ledgerTransactionId != null) {
      map['ledger_transaction_id'] = Variable<int>(ledgerTransactionId);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || policySnapshotJson != null) {
      map['policy_snapshot_json'] = Variable<String>(policySnapshotJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || confirmedAt != null) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt);
    }
    return map;
  }

  SolanaPaymentsCompanion toCompanion(bool nullToAbsent) {
    return SolanaPaymentsCompanion(
      id: Value(id),
      idempotencyKey: Value(idempotencyKey),
      payeeId: payeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(payeeId),
      recipientName: Value(recipientName),
      recipientAddress: Value(recipientAddress),
      amountLamports: Value(amountLamports),
      inrMemoPaise: Value(inrMemoPaise),
      network: Value(network),
      status: Value(status),
      requestText: Value(requestText),
      signature: signature == null && nullToAbsent
          ? const Value.absent()
          : Value(signature),
      explorerUrl: explorerUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(explorerUrl),
      ledgerTransactionId: ledgerTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(ledgerTransactionId),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      policySnapshotJson: policySnapshotJson == null && nullToAbsent
          ? const Value.absent()
          : Value(policySnapshotJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      confirmedAt: confirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedAt),
    );
  }

  factory SolanaPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SolanaPayment(
      id: serializer.fromJson<int>(json['id']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      payeeId: serializer.fromJson<int?>(json['payeeId']),
      recipientName: serializer.fromJson<String>(json['recipientName']),
      recipientAddress: serializer.fromJson<String>(json['recipientAddress']),
      amountLamports: serializer.fromJson<int>(json['amountLamports']),
      inrMemoPaise: serializer.fromJson<int>(json['inrMemoPaise']),
      network: serializer.fromJson<String>(json['network']),
      status: $SolanaPaymentsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      requestText: serializer.fromJson<String>(json['requestText']),
      signature: serializer.fromJson<String?>(json['signature']),
      explorerUrl: serializer.fromJson<String?>(json['explorerUrl']),
      ledgerTransactionId: serializer.fromJson<int?>(
        json['ledgerTransactionId'],
      ),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      policySnapshotJson: serializer.fromJson<String?>(
        json['policySnapshotJson'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      confirmedAt: serializer.fromJson<DateTime?>(json['confirmedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'payeeId': serializer.toJson<int?>(payeeId),
      'recipientName': serializer.toJson<String>(recipientName),
      'recipientAddress': serializer.toJson<String>(recipientAddress),
      'amountLamports': serializer.toJson<int>(amountLamports),
      'inrMemoPaise': serializer.toJson<int>(inrMemoPaise),
      'network': serializer.toJson<String>(network),
      'status': serializer.toJson<String>(
        $SolanaPaymentsTable.$converterstatus.toJson(status),
      ),
      'requestText': serializer.toJson<String>(requestText),
      'signature': serializer.toJson<String?>(signature),
      'explorerUrl': serializer.toJson<String?>(explorerUrl),
      'ledgerTransactionId': serializer.toJson<int?>(ledgerTransactionId),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'policySnapshotJson': serializer.toJson<String?>(policySnapshotJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'confirmedAt': serializer.toJson<DateTime?>(confirmedAt),
    };
  }

  SolanaPayment copyWith({
    int? id,
    String? idempotencyKey,
    Value<int?> payeeId = const Value.absent(),
    String? recipientName,
    String? recipientAddress,
    int? amountLamports,
    int? inrMemoPaise,
    String? network,
    PaymentStatus? status,
    String? requestText,
    Value<String?> signature = const Value.absent(),
    Value<String?> explorerUrl = const Value.absent(),
    Value<int?> ledgerTransactionId = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    Value<String?> policySnapshotJson = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> confirmedAt = const Value.absent(),
  }) => SolanaPayment(
    id: id ?? this.id,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    payeeId: payeeId.present ? payeeId.value : this.payeeId,
    recipientName: recipientName ?? this.recipientName,
    recipientAddress: recipientAddress ?? this.recipientAddress,
    amountLamports: amountLamports ?? this.amountLamports,
    inrMemoPaise: inrMemoPaise ?? this.inrMemoPaise,
    network: network ?? this.network,
    status: status ?? this.status,
    requestText: requestText ?? this.requestText,
    signature: signature.present ? signature.value : this.signature,
    explorerUrl: explorerUrl.present ? explorerUrl.value : this.explorerUrl,
    ledgerTransactionId: ledgerTransactionId.present
        ? ledgerTransactionId.value
        : this.ledgerTransactionId,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    policySnapshotJson: policySnapshotJson.present
        ? policySnapshotJson.value
        : this.policySnapshotJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    confirmedAt: confirmedAt.present ? confirmedAt.value : this.confirmedAt,
  );
  SolanaPayment copyWithCompanion(SolanaPaymentsCompanion data) {
    return SolanaPayment(
      id: data.id.present ? data.id.value : this.id,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      payeeId: data.payeeId.present ? data.payeeId.value : this.payeeId,
      recipientName: data.recipientName.present
          ? data.recipientName.value
          : this.recipientName,
      recipientAddress: data.recipientAddress.present
          ? data.recipientAddress.value
          : this.recipientAddress,
      amountLamports: data.amountLamports.present
          ? data.amountLamports.value
          : this.amountLamports,
      inrMemoPaise: data.inrMemoPaise.present
          ? data.inrMemoPaise.value
          : this.inrMemoPaise,
      network: data.network.present ? data.network.value : this.network,
      status: data.status.present ? data.status.value : this.status,
      requestText: data.requestText.present
          ? data.requestText.value
          : this.requestText,
      signature: data.signature.present ? data.signature.value : this.signature,
      explorerUrl: data.explorerUrl.present
          ? data.explorerUrl.value
          : this.explorerUrl,
      ledgerTransactionId: data.ledgerTransactionId.present
          ? data.ledgerTransactionId.value
          : this.ledgerTransactionId,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      policySnapshotJson: data.policySnapshotJson.present
          ? data.policySnapshotJson.value
          : this.policySnapshotJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      confirmedAt: data.confirmedAt.present
          ? data.confirmedAt.value
          : this.confirmedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SolanaPayment(')
          ..write('id: $id, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('payeeId: $payeeId, ')
          ..write('recipientName: $recipientName, ')
          ..write('recipientAddress: $recipientAddress, ')
          ..write('amountLamports: $amountLamports, ')
          ..write('inrMemoPaise: $inrMemoPaise, ')
          ..write('network: $network, ')
          ..write('status: $status, ')
          ..write('requestText: $requestText, ')
          ..write('signature: $signature, ')
          ..write('explorerUrl: $explorerUrl, ')
          ..write('ledgerTransactionId: $ledgerTransactionId, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('policySnapshotJson: $policySnapshotJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('confirmedAt: $confirmedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idempotencyKey,
    payeeId,
    recipientName,
    recipientAddress,
    amountLamports,
    inrMemoPaise,
    network,
    status,
    requestText,
    signature,
    explorerUrl,
    ledgerTransactionId,
    errorMessage,
    policySnapshotJson,
    createdAt,
    updatedAt,
    confirmedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SolanaPayment &&
          other.id == this.id &&
          other.idempotencyKey == this.idempotencyKey &&
          other.payeeId == this.payeeId &&
          other.recipientName == this.recipientName &&
          other.recipientAddress == this.recipientAddress &&
          other.amountLamports == this.amountLamports &&
          other.inrMemoPaise == this.inrMemoPaise &&
          other.network == this.network &&
          other.status == this.status &&
          other.requestText == this.requestText &&
          other.signature == this.signature &&
          other.explorerUrl == this.explorerUrl &&
          other.ledgerTransactionId == this.ledgerTransactionId &&
          other.errorMessage == this.errorMessage &&
          other.policySnapshotJson == this.policySnapshotJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.confirmedAt == this.confirmedAt);
}

class SolanaPaymentsCompanion extends UpdateCompanion<SolanaPayment> {
  final Value<int> id;
  final Value<String> idempotencyKey;
  final Value<int?> payeeId;
  final Value<String> recipientName;
  final Value<String> recipientAddress;
  final Value<int> amountLamports;
  final Value<int> inrMemoPaise;
  final Value<String> network;
  final Value<PaymentStatus> status;
  final Value<String> requestText;
  final Value<String?> signature;
  final Value<String?> explorerUrl;
  final Value<int?> ledgerTransactionId;
  final Value<String?> errorMessage;
  final Value<String?> policySnapshotJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> confirmedAt;
  const SolanaPaymentsCompanion({
    this.id = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.payeeId = const Value.absent(),
    this.recipientName = const Value.absent(),
    this.recipientAddress = const Value.absent(),
    this.amountLamports = const Value.absent(),
    this.inrMemoPaise = const Value.absent(),
    this.network = const Value.absent(),
    this.status = const Value.absent(),
    this.requestText = const Value.absent(),
    this.signature = const Value.absent(),
    this.explorerUrl = const Value.absent(),
    this.ledgerTransactionId = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.policySnapshotJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.confirmedAt = const Value.absent(),
  });
  SolanaPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required String idempotencyKey,
    this.payeeId = const Value.absent(),
    required String recipientName,
    required String recipientAddress,
    required int amountLamports,
    this.inrMemoPaise = const Value.absent(),
    required String network,
    required PaymentStatus status,
    required String requestText,
    this.signature = const Value.absent(),
    this.explorerUrl = const Value.absent(),
    this.ledgerTransactionId = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.policySnapshotJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.confirmedAt = const Value.absent(),
  }) : idempotencyKey = Value(idempotencyKey),
       recipientName = Value(recipientName),
       recipientAddress = Value(recipientAddress),
       amountLamports = Value(amountLamports),
       network = Value(network),
       status = Value(status),
       requestText = Value(requestText),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SolanaPayment> custom({
    Expression<int>? id,
    Expression<String>? idempotencyKey,
    Expression<int>? payeeId,
    Expression<String>? recipientName,
    Expression<String>? recipientAddress,
    Expression<int>? amountLamports,
    Expression<int>? inrMemoPaise,
    Expression<String>? network,
    Expression<String>? status,
    Expression<String>? requestText,
    Expression<String>? signature,
    Expression<String>? explorerUrl,
    Expression<int>? ledgerTransactionId,
    Expression<String>? errorMessage,
    Expression<String>? policySnapshotJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? confirmedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (payeeId != null) 'payee_id': payeeId,
      if (recipientName != null) 'recipient_name': recipientName,
      if (recipientAddress != null) 'recipient_address': recipientAddress,
      if (amountLamports != null) 'amount_lamports': amountLamports,
      if (inrMemoPaise != null) 'inr_memo_paise': inrMemoPaise,
      if (network != null) 'network': network,
      if (status != null) 'status': status,
      if (requestText != null) 'request_text': requestText,
      if (signature != null) 'signature': signature,
      if (explorerUrl != null) 'explorer_url': explorerUrl,
      if (ledgerTransactionId != null)
        'ledger_transaction_id': ledgerTransactionId,
      if (errorMessage != null) 'error_message': errorMessage,
      if (policySnapshotJson != null)
        'policy_snapshot_json': policySnapshotJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
    });
  }

  SolanaPaymentsCompanion copyWith({
    Value<int>? id,
    Value<String>? idempotencyKey,
    Value<int?>? payeeId,
    Value<String>? recipientName,
    Value<String>? recipientAddress,
    Value<int>? amountLamports,
    Value<int>? inrMemoPaise,
    Value<String>? network,
    Value<PaymentStatus>? status,
    Value<String>? requestText,
    Value<String?>? signature,
    Value<String?>? explorerUrl,
    Value<int?>? ledgerTransactionId,
    Value<String?>? errorMessage,
    Value<String?>? policySnapshotJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? confirmedAt,
  }) {
    return SolanaPaymentsCompanion(
      id: id ?? this.id,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      payeeId: payeeId ?? this.payeeId,
      recipientName: recipientName ?? this.recipientName,
      recipientAddress: recipientAddress ?? this.recipientAddress,
      amountLamports: amountLamports ?? this.amountLamports,
      inrMemoPaise: inrMemoPaise ?? this.inrMemoPaise,
      network: network ?? this.network,
      status: status ?? this.status,
      requestText: requestText ?? this.requestText,
      signature: signature ?? this.signature,
      explorerUrl: explorerUrl ?? this.explorerUrl,
      ledgerTransactionId: ledgerTransactionId ?? this.ledgerTransactionId,
      errorMessage: errorMessage ?? this.errorMessage,
      policySnapshotJson: policySnapshotJson ?? this.policySnapshotJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (payeeId.present) {
      map['payee_id'] = Variable<int>(payeeId.value);
    }
    if (recipientName.present) {
      map['recipient_name'] = Variable<String>(recipientName.value);
    }
    if (recipientAddress.present) {
      map['recipient_address'] = Variable<String>(recipientAddress.value);
    }
    if (amountLamports.present) {
      map['amount_lamports'] = Variable<int>(amountLamports.value);
    }
    if (inrMemoPaise.present) {
      map['inr_memo_paise'] = Variable<int>(inrMemoPaise.value);
    }
    if (network.present) {
      map['network'] = Variable<String>(network.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $SolanaPaymentsTable.$converterstatus.toSql(status.value),
      );
    }
    if (requestText.present) {
      map['request_text'] = Variable<String>(requestText.value);
    }
    if (signature.present) {
      map['signature'] = Variable<String>(signature.value);
    }
    if (explorerUrl.present) {
      map['explorer_url'] = Variable<String>(explorerUrl.value);
    }
    if (ledgerTransactionId.present) {
      map['ledger_transaction_id'] = Variable<int>(ledgerTransactionId.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (policySnapshotJson.present) {
      map['policy_snapshot_json'] = Variable<String>(policySnapshotJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SolanaPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('payeeId: $payeeId, ')
          ..write('recipientName: $recipientName, ')
          ..write('recipientAddress: $recipientAddress, ')
          ..write('amountLamports: $amountLamports, ')
          ..write('inrMemoPaise: $inrMemoPaise, ')
          ..write('network: $network, ')
          ..write('status: $status, ')
          ..write('requestText: $requestText, ')
          ..write('signature: $signature, ')
          ..write('explorerUrl: $explorerUrl, ')
          ..write('ledgerTransactionId: $ledgerTransactionId, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('policySnapshotJson: $policySnapshotJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('confirmedAt: $confirmedAt')
          ..write(')'))
        .toString();
  }
}

class $PolicyRowsTable extends PolicyRows
    with TableInfo<$PolicyRowsTable, PolicyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PolicyRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _maxPerPaymentLamportsMeta =
      const VerificationMeta('maxPerPaymentLamports');
  @override
  late final GeneratedColumn<int> maxPerPaymentLamports = GeneratedColumn<int>(
    'max_per_payment_lamports',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyLimitLamportsMeta =
      const VerificationMeta('dailyLimitLamports');
  @override
  late final GeneratedColumn<int> dailyLimitLamports = GeneratedColumn<int>(
    'daily_limit_lamports',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedRecipientsOnlyMeta =
      const VerificationMeta('savedRecipientsOnly');
  @override
  late final GeneratedColumn<bool> savedRecipientsOnly = GeneratedColumn<bool>(
    'saved_recipients_only',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("saved_recipients_only" IN (0, 1))',
    ),
  );
  static const VerificationMeta _devnetOnlyMeta = const VerificationMeta(
    'devnetOnly',
  );
  @override
  late final GeneratedColumn<bool> devnetOnly = GeneratedColumn<bool>(
    'devnet_only',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("devnet_only" IN (0, 1))',
    ),
  );
  static const VerificationMeta _requireApprovalMeta = const VerificationMeta(
    'requireApproval',
  );
  @override
  late final GeneratedColumn<bool> requireApproval = GeneratedColumn<bool>(
    'require_approval',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("require_approval" IN (0, 1))',
    ),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    maxPerPaymentLamports,
    dailyLimitLamports,
    savedRecipientsOnly,
    devnetOnly,
    requireApproval,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'policy_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PolicyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('max_per_payment_lamports')) {
      context.handle(
        _maxPerPaymentLamportsMeta,
        maxPerPaymentLamports.isAcceptableOrUnknown(
          data['max_per_payment_lamports']!,
          _maxPerPaymentLamportsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxPerPaymentLamportsMeta);
    }
    if (data.containsKey('daily_limit_lamports')) {
      context.handle(
        _dailyLimitLamportsMeta,
        dailyLimitLamports.isAcceptableOrUnknown(
          data['daily_limit_lamports']!,
          _dailyLimitLamportsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyLimitLamportsMeta);
    }
    if (data.containsKey('saved_recipients_only')) {
      context.handle(
        _savedRecipientsOnlyMeta,
        savedRecipientsOnly.isAcceptableOrUnknown(
          data['saved_recipients_only']!,
          _savedRecipientsOnlyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_savedRecipientsOnlyMeta);
    }
    if (data.containsKey('devnet_only')) {
      context.handle(
        _devnetOnlyMeta,
        devnetOnly.isAcceptableOrUnknown(data['devnet_only']!, _devnetOnlyMeta),
      );
    } else if (isInserting) {
      context.missing(_devnetOnlyMeta);
    }
    if (data.containsKey('require_approval')) {
      context.handle(
        _requireApprovalMeta,
        requireApproval.isAcceptableOrUnknown(
          data['require_approval']!,
          _requireApprovalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requireApprovalMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PolicyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PolicyRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      maxPerPaymentLamports: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_per_payment_lamports'],
      )!,
      dailyLimitLamports: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_limit_lamports'],
      )!,
      savedRecipientsOnly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}saved_recipients_only'],
      )!,
      devnetOnly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}devnet_only'],
      )!,
      requireApproval: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}require_approval'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PolicyRowsTable createAlias(String alias) {
    return $PolicyRowsTable(attachedDatabase, alias);
  }
}

class PolicyRow extends DataClass implements Insertable<PolicyRow> {
  final int id;
  final int maxPerPaymentLamports;
  final int dailyLimitLamports;
  final bool savedRecipientsOnly;
  final bool devnetOnly;
  final bool requireApproval;
  final DateTime updatedAt;
  const PolicyRow({
    required this.id,
    required this.maxPerPaymentLamports,
    required this.dailyLimitLamports,
    required this.savedRecipientsOnly,
    required this.devnetOnly,
    required this.requireApproval,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['max_per_payment_lamports'] = Variable<int>(maxPerPaymentLamports);
    map['daily_limit_lamports'] = Variable<int>(dailyLimitLamports);
    map['saved_recipients_only'] = Variable<bool>(savedRecipientsOnly);
    map['devnet_only'] = Variable<bool>(devnetOnly);
    map['require_approval'] = Variable<bool>(requireApproval);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PolicyRowsCompanion toCompanion(bool nullToAbsent) {
    return PolicyRowsCompanion(
      id: Value(id),
      maxPerPaymentLamports: Value(maxPerPaymentLamports),
      dailyLimitLamports: Value(dailyLimitLamports),
      savedRecipientsOnly: Value(savedRecipientsOnly),
      devnetOnly: Value(devnetOnly),
      requireApproval: Value(requireApproval),
      updatedAt: Value(updatedAt),
    );
  }

  factory PolicyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PolicyRow(
      id: serializer.fromJson<int>(json['id']),
      maxPerPaymentLamports: serializer.fromJson<int>(
        json['maxPerPaymentLamports'],
      ),
      dailyLimitLamports: serializer.fromJson<int>(json['dailyLimitLamports']),
      savedRecipientsOnly: serializer.fromJson<bool>(
        json['savedRecipientsOnly'],
      ),
      devnetOnly: serializer.fromJson<bool>(json['devnetOnly']),
      requireApproval: serializer.fromJson<bool>(json['requireApproval']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'maxPerPaymentLamports': serializer.toJson<int>(maxPerPaymentLamports),
      'dailyLimitLamports': serializer.toJson<int>(dailyLimitLamports),
      'savedRecipientsOnly': serializer.toJson<bool>(savedRecipientsOnly),
      'devnetOnly': serializer.toJson<bool>(devnetOnly),
      'requireApproval': serializer.toJson<bool>(requireApproval),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PolicyRow copyWith({
    int? id,
    int? maxPerPaymentLamports,
    int? dailyLimitLamports,
    bool? savedRecipientsOnly,
    bool? devnetOnly,
    bool? requireApproval,
    DateTime? updatedAt,
  }) => PolicyRow(
    id: id ?? this.id,
    maxPerPaymentLamports: maxPerPaymentLamports ?? this.maxPerPaymentLamports,
    dailyLimitLamports: dailyLimitLamports ?? this.dailyLimitLamports,
    savedRecipientsOnly: savedRecipientsOnly ?? this.savedRecipientsOnly,
    devnetOnly: devnetOnly ?? this.devnetOnly,
    requireApproval: requireApproval ?? this.requireApproval,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PolicyRow copyWithCompanion(PolicyRowsCompanion data) {
    return PolicyRow(
      id: data.id.present ? data.id.value : this.id,
      maxPerPaymentLamports: data.maxPerPaymentLamports.present
          ? data.maxPerPaymentLamports.value
          : this.maxPerPaymentLamports,
      dailyLimitLamports: data.dailyLimitLamports.present
          ? data.dailyLimitLamports.value
          : this.dailyLimitLamports,
      savedRecipientsOnly: data.savedRecipientsOnly.present
          ? data.savedRecipientsOnly.value
          : this.savedRecipientsOnly,
      devnetOnly: data.devnetOnly.present
          ? data.devnetOnly.value
          : this.devnetOnly,
      requireApproval: data.requireApproval.present
          ? data.requireApproval.value
          : this.requireApproval,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PolicyRow(')
          ..write('id: $id, ')
          ..write('maxPerPaymentLamports: $maxPerPaymentLamports, ')
          ..write('dailyLimitLamports: $dailyLimitLamports, ')
          ..write('savedRecipientsOnly: $savedRecipientsOnly, ')
          ..write('devnetOnly: $devnetOnly, ')
          ..write('requireApproval: $requireApproval, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    maxPerPaymentLamports,
    dailyLimitLamports,
    savedRecipientsOnly,
    devnetOnly,
    requireApproval,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PolicyRow &&
          other.id == this.id &&
          other.maxPerPaymentLamports == this.maxPerPaymentLamports &&
          other.dailyLimitLamports == this.dailyLimitLamports &&
          other.savedRecipientsOnly == this.savedRecipientsOnly &&
          other.devnetOnly == this.devnetOnly &&
          other.requireApproval == this.requireApproval &&
          other.updatedAt == this.updatedAt);
}

class PolicyRowsCompanion extends UpdateCompanion<PolicyRow> {
  final Value<int> id;
  final Value<int> maxPerPaymentLamports;
  final Value<int> dailyLimitLamports;
  final Value<bool> savedRecipientsOnly;
  final Value<bool> devnetOnly;
  final Value<bool> requireApproval;
  final Value<DateTime> updatedAt;
  const PolicyRowsCompanion({
    this.id = const Value.absent(),
    this.maxPerPaymentLamports = const Value.absent(),
    this.dailyLimitLamports = const Value.absent(),
    this.savedRecipientsOnly = const Value.absent(),
    this.devnetOnly = const Value.absent(),
    this.requireApproval = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PolicyRowsCompanion.insert({
    this.id = const Value.absent(),
    required int maxPerPaymentLamports,
    required int dailyLimitLamports,
    required bool savedRecipientsOnly,
    required bool devnetOnly,
    required bool requireApproval,
    required DateTime updatedAt,
  }) : maxPerPaymentLamports = Value(maxPerPaymentLamports),
       dailyLimitLamports = Value(dailyLimitLamports),
       savedRecipientsOnly = Value(savedRecipientsOnly),
       devnetOnly = Value(devnetOnly),
       requireApproval = Value(requireApproval),
       updatedAt = Value(updatedAt);
  static Insertable<PolicyRow> custom({
    Expression<int>? id,
    Expression<int>? maxPerPaymentLamports,
    Expression<int>? dailyLimitLamports,
    Expression<bool>? savedRecipientsOnly,
    Expression<bool>? devnetOnly,
    Expression<bool>? requireApproval,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (maxPerPaymentLamports != null)
        'max_per_payment_lamports': maxPerPaymentLamports,
      if (dailyLimitLamports != null)
        'daily_limit_lamports': dailyLimitLamports,
      if (savedRecipientsOnly != null)
        'saved_recipients_only': savedRecipientsOnly,
      if (devnetOnly != null) 'devnet_only': devnetOnly,
      if (requireApproval != null) 'require_approval': requireApproval,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PolicyRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? maxPerPaymentLamports,
    Value<int>? dailyLimitLamports,
    Value<bool>? savedRecipientsOnly,
    Value<bool>? devnetOnly,
    Value<bool>? requireApproval,
    Value<DateTime>? updatedAt,
  }) {
    return PolicyRowsCompanion(
      id: id ?? this.id,
      maxPerPaymentLamports:
          maxPerPaymentLamports ?? this.maxPerPaymentLamports,
      dailyLimitLamports: dailyLimitLamports ?? this.dailyLimitLamports,
      savedRecipientsOnly: savedRecipientsOnly ?? this.savedRecipientsOnly,
      devnetOnly: devnetOnly ?? this.devnetOnly,
      requireApproval: requireApproval ?? this.requireApproval,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (maxPerPaymentLamports.present) {
      map['max_per_payment_lamports'] = Variable<int>(
        maxPerPaymentLamports.value,
      );
    }
    if (dailyLimitLamports.present) {
      map['daily_limit_lamports'] = Variable<int>(dailyLimitLamports.value);
    }
    if (savedRecipientsOnly.present) {
      map['saved_recipients_only'] = Variable<bool>(savedRecipientsOnly.value);
    }
    if (devnetOnly.present) {
      map['devnet_only'] = Variable<bool>(devnetOnly.value);
    }
    if (requireApproval.present) {
      map['require_approval'] = Variable<bool>(requireApproval.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PolicyRowsCompanion(')
          ..write('id: $id, ')
          ..write('maxPerPaymentLamports: $maxPerPaymentLamports, ')
          ..write('dailyLimitLamports: $dailyLimitLamports, ')
          ..write('savedRecipientsOnly: $savedRecipientsOnly, ')
          ..write('devnetOnly: $devnetOnly, ')
          ..write('requireApproval: $requireApproval, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsJsonMeta = const VerificationMeta(
    'detailsJson',
  );
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
    'details_json',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 0,
      maxTextLength: 4000,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    action,
    detailsJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('details_json')) {
      context.handle(
        _detailsJsonMeta,
        detailsJson.isAcceptableOrUnknown(
          data['details_json']!,
          _detailsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_detailsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      ),
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      detailsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLog extends DataClass implements Insertable<AuditLog> {
  final int id;
  final String entityType;
  final int? entityId;
  final String action;
  final String detailsJson;
  final DateTime createdAt;
  const AuditLog({
    required this.id,
    required this.entityType,
    this.entityId,
    required this.action,
    required this.detailsJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<int>(entityId);
    }
    map['action'] = Variable<String>(action);
    map['details_json'] = Variable<String>(detailsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      action: Value(action),
      detailsJson: Value(detailsJson),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int?>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      detailsJson: serializer.fromJson<String>(json['detailsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int?>(entityId),
      'action': serializer.toJson<String>(action),
      'detailsJson': serializer.toJson<String>(detailsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditLog copyWith({
    int? id,
    String? entityType,
    Value<int?> entityId = const Value.absent(),
    String? action,
    String? detailsJson,
    DateTime? createdAt,
  }) => AuditLog(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId.present ? entityId.value : this.entityId,
    action: action ?? this.action,
    detailsJson: detailsJson ?? this.detailsJson,
    createdAt: createdAt ?? this.createdAt,
  );
  AuditLog copyWithCompanion(AuditLogsCompanion data) {
    return AuditLog(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      detailsJson: data.detailsJson.present
          ? data.detailsJson.value
          : this.detailsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLog(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityType, entityId, action, detailsJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLog &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.detailsJson == this.detailsJson &&
          other.createdAt == this.createdAt);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<int?> entityId;
  final Value<String> action;
  final Value<String> detailsJson;
  final Value<DateTime> createdAt;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    this.entityId = const Value.absent(),
    required String action,
    required String detailsJson,
    required DateTime createdAt,
  }) : entityType = Value(entityType),
       action = Value(action),
       detailsJson = Value(detailsJson),
       createdAt = Value(createdAt);
  static Insertable<AuditLog> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? action,
    Expression<String>? detailsJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (detailsJson != null) 'details_json': detailsJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AuditLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<int?>? entityId,
    Value<String>? action,
    Value<String>? detailsJson,
    Value<DateTime>? createdAt,
  }) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      detailsJson: detailsJson ?? this.detailsJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (detailsJson.present) {
      map['details_json'] = Variable<String>(detailsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MerchantProfilesTable merchantProfiles = $MerchantProfilesTable(
    this,
  );
  late final $CustomersTable customers = $CustomersTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionLinesTable transactionLines = $TransactionLinesTable(
    this,
  );
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $PurchaseItemsTable purchaseItems = $PurchaseItemsTable(this);
  late final $PayeesTable payees = $PayeesTable(this);
  late final $SolanaPaymentsTable solanaPayments = $SolanaPaymentsTable(this);
  late final $PolicyRowsTable policyRows = $PolicyRowsTable(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    merchantProfiles,
    customers,
    suppliers,
    products,
    stockMovements,
    transactions,
    transactionLines,
    purchases,
    purchaseItems,
    payees,
    solanaPayments,
    policyRows,
    auditLogs,
    appSettings,
  ];
}

typedef $$MerchantProfilesTableCreateCompanionBuilder =
    MerchantProfilesCompanion Function({
      Value<int> id,
      required String shopName,
      required String ownerName,
      required String businessType,
      required String languageCode,
      required String currencyCode,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$MerchantProfilesTableUpdateCompanionBuilder =
    MerchantProfilesCompanion Function({
      Value<int> id,
      Value<String> shopName,
      Value<String> ownerName,
      Value<String> businessType,
      Value<String> languageCode,
      Value<String> currencyCode,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$MerchantProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $MerchantProfilesTable> {
  $$MerchantProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopName => $composableBuilder(
    column: $table.shopName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessType => $composableBuilder(
    column: $table.businessType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MerchantProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $MerchantProfilesTable> {
  $$MerchantProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopName => $composableBuilder(
    column: $table.shopName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessType => $composableBuilder(
    column: $table.businessType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MerchantProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MerchantProfilesTable> {
  $$MerchantProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shopName =>
      $composableBuilder(column: $table.shopName, builder: (column) => column);

  GeneratedColumn<String> get ownerName =>
      $composableBuilder(column: $table.ownerName, builder: (column) => column);

  GeneratedColumn<String> get businessType => $composableBuilder(
    column: $table.businessType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MerchantProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MerchantProfilesTable,
          MerchantProfile,
          $$MerchantProfilesTableFilterComposer,
          $$MerchantProfilesTableOrderingComposer,
          $$MerchantProfilesTableAnnotationComposer,
          $$MerchantProfilesTableCreateCompanionBuilder,
          $$MerchantProfilesTableUpdateCompanionBuilder,
          (
            MerchantProfile,
            BaseReferences<
              _$AppDatabase,
              $MerchantProfilesTable,
              MerchantProfile
            >,
          ),
          MerchantProfile,
          PrefetchHooks Function()
        > {
  $$MerchantProfilesTableTableManager(
    _$AppDatabase db,
    $MerchantProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MerchantProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MerchantProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MerchantProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> shopName = const Value.absent(),
                Value<String> ownerName = const Value.absent(),
                Value<String> businessType = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MerchantProfilesCompanion(
                id: id,
                shopName: shopName,
                ownerName: ownerName,
                businessType: businessType,
                languageCode: languageCode,
                currencyCode: currencyCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String shopName,
                required String ownerName,
                required String businessType,
                required String languageCode,
                required String currencyCode,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => MerchantProfilesCompanion.insert(
                id: id,
                shopName: shopName,
                ownerName: ownerName,
                businessType: businessType,
                languageCode: languageCode,
                currencyCode: currencyCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MerchantProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MerchantProfilesTable,
      MerchantProfile,
      $$MerchantProfilesTableFilterComposer,
      $$MerchantProfilesTableOrderingComposer,
      $$MerchantProfilesTableAnnotationComposer,
      $$MerchantProfilesTableCreateCompanionBuilder,
      $$MerchantProfilesTableUpdateCompanionBuilder,
      (
        MerchantProfile,
        BaseReferences<_$AppDatabase, $MerchantProfilesTable, MerchantProfile>,
      ),
      MerchantProfile,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      required String name,
      required String phone,
      required String address,
      required String notes,
      Value<bool> archived,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> phone,
      Value<String> address,
      Value<String> notes,
      Value<bool> archived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: $_aliasNameGenerator(
      db.customers.id,
      db.transactions.customerId,
    ),
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({bool transactionsRefs})
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                name: name,
                phone: phone,
                address: address,
                notes: notes,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String phone,
                required String address,
                required String notes,
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => CustomersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                address: address,
                notes: notes,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<
                      Customer,
                      $CustomersTable,
                      Transaction
                    >(
                      currentTable: table,
                      referencedTable: $$CustomersTableReferences
                          ._transactionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomersTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.customerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({bool transactionsRefs})
    >;
typedef $$SuppliersTableCreateCompanionBuilder =
    SuppliersCompanion Function({
      Value<int> id,
      required String name,
      required String phone,
      required String address,
      required String notes,
      Value<bool> archived,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$SuppliersTableUpdateCompanionBuilder =
    SuppliersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> phone,
      Value<String> address,
      Value<String> notes,
      Value<bool> archived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$SuppliersTableReferences
    extends BaseReferences<_$AppDatabase, $SuppliersTable, Supplier> {
  $$SuppliersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: $_aliasNameGenerator(db.suppliers.id, db.products.supplierId),
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.supplierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: $_aliasNameGenerator(
      db.suppliers.id,
      db.transactions.supplierId,
    ),
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.supplierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PurchasesTable, List<Purchase>>
  _purchasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchases,
    aliasName: $_aliasNameGenerator(db.suppliers.id, db.purchases.supplierId),
  );

  $$PurchasesTableProcessedTableManager get purchasesRefs {
    final manager = $$PurchasesTableTableManager(
      $_db,
      $_db.purchases,
    ).filter((f) => f.supplierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> purchasesRefs(
    Expression<bool> Function($$PurchasesTableFilterComposer f) f,
  ) {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableFilterComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> purchasesRefs<T extends Object>(
    Expression<T> Function($$PurchasesTableAnnotationComposer a) f,
  ) {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SuppliersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SuppliersTable,
          Supplier,
          $$SuppliersTableFilterComposer,
          $$SuppliersTableOrderingComposer,
          $$SuppliersTableAnnotationComposer,
          $$SuppliersTableCreateCompanionBuilder,
          $$SuppliersTableUpdateCompanionBuilder,
          (Supplier, $$SuppliersTableReferences),
          Supplier,
          PrefetchHooks Function({
            bool productsRefs,
            bool transactionsRefs,
            bool purchasesRefs,
          })
        > {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SuppliersCompanion(
                id: id,
                name: name,
                phone: phone,
                address: address,
                notes: notes,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String phone,
                required String address,
                required String notes,
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => SuppliersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                address: address,
                notes: notes,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SuppliersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productsRefs = false,
                transactionsRefs = false,
                purchasesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (productsRefs) db.products,
                    if (transactionsRefs) db.transactions,
                    if (purchasesRefs) db.purchases,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (productsRefs)
                        await $_getPrefetchedData<
                          Supplier,
                          $SuppliersTable,
                          Product
                        >(
                          currentTable: table,
                          referencedTable: $$SuppliersTableReferences
                              ._productsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SuppliersTableReferences(
                                db,
                                table,
                                p0,
                              ).productsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.supplierId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Supplier,
                          $SuppliersTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$SuppliersTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SuppliersTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.supplierId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (purchasesRefs)
                        await $_getPrefetchedData<
                          Supplier,
                          $SuppliersTable,
                          Purchase
                        >(
                          currentTable: table,
                          referencedTable: $$SuppliersTableReferences
                              ._purchasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SuppliersTableReferences(
                                db,
                                table,
                                p0,
                              ).purchasesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.supplierId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SuppliersTable,
      Supplier,
      $$SuppliersTableFilterComposer,
      $$SuppliersTableOrderingComposer,
      $$SuppliersTableAnnotationComposer,
      $$SuppliersTableCreateCompanionBuilder,
      $$SuppliersTableUpdateCompanionBuilder,
      (Supplier, $$SuppliersTableReferences),
      Supplier,
      PrefetchHooks Function({
        bool productsRefs,
        bool transactionsRefs,
        bool purchasesRefs,
      })
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String name,
      required String sku,
      required String barcode,
      required String category,
      required String unit,
      Value<int> purchasePricePaise,
      Value<int> sellingPricePaise,
      Value<double> stockQty,
      Value<double> minStockQty,
      Value<int?> supplierId,
      Value<String?> imagePath,
      Value<bool> archived,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> sku,
      Value<String> barcode,
      Value<String> category,
      Value<String> unit,
      Value<int> purchasePricePaise,
      Value<int> sellingPricePaise,
      Value<double> stockQty,
      Value<double> minStockQty,
      Value<int?> supplierId,
      Value<String?> imagePath,
      Value<bool> archived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias(
        $_aliasNameGenerator(db.products.supplierId, db.suppliers.id),
      );

  $$SuppliersTableProcessedTableManager? get supplierId {
    final $_column = $_itemColumn<int>('supplier_id');
    if ($_column == null) return null;
    final manager = $$SuppliersTableTableManager(
      $_db,
      $_db.suppliers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
  _stockMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: $_aliasNameGenerator(
      db.products.id,
      db.stockMovements.productId,
    ),
  );

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager(
      $_db,
      $_db.stockMovements,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionLinesTable, List<TransactionLine>>
  _transactionLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionLines,
    aliasName: $_aliasNameGenerator(
      db.products.id,
      db.transactionLines.productId,
    ),
  );

  $$TransactionLinesTableProcessedTableManager get transactionLinesRefs {
    final manager = $$TransactionLinesTableTableManager(
      $_db,
      $_db.transactionLines,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
  _purchaseItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseItems,
    aliasName: $_aliasNameGenerator(db.products.id, db.purchaseItems.productId),
  );

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager(
      $_db,
      $_db.purchaseItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchasePricePaise => $composableBuilder(
    column: $table.purchasePricePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sellingPricePaise => $composableBuilder(
    column: $table.sellingPricePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minStockQty => $composableBuilder(
    column: $table.minStockQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableFilterComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> stockMovementsRefs(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionLinesRefs(
    Expression<bool> Function($$TransactionLinesTableFilterComposer f) f,
  ) {
    final $$TransactionLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableFilterComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> purchaseItemsRefs(
    Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f,
  ) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableFilterComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchasePricePaise => $composableBuilder(
    column: $table.purchasePricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sellingPricePaise => $composableBuilder(
    column: $table.sellingPricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minStockQty => $composableBuilder(
    column: $table.minStockQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableOrderingComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get purchasePricePaise => $composableBuilder(
    column: $table.purchasePricePaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sellingPricePaise => $composableBuilder(
    column: $table.sellingPricePaise,
    builder: (column) => column,
  );

  GeneratedColumn<double> get stockQty =>
      $composableBuilder(column: $table.stockQty, builder: (column) => column);

  GeneratedColumn<double> get minStockQty => $composableBuilder(
    column: $table.minStockQty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableAnnotationComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> stockMovementsRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionLinesRefs<T extends Object>(
    Expression<T> Function($$TransactionLinesTableAnnotationComposer a) f,
  ) {
    final $$TransactionLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
    Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f,
  ) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({
            bool supplierId,
            bool stockMovementsRefs,
            bool transactionLinesRefs,
            bool purchaseItemsRefs,
          })
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> sku = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> purchasePricePaise = const Value.absent(),
                Value<int> sellingPricePaise = const Value.absent(),
                Value<double> stockQty = const Value.absent(),
                Value<double> minStockQty = const Value.absent(),
                Value<int?> supplierId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                sku: sku,
                barcode: barcode,
                category: category,
                unit: unit,
                purchasePricePaise: purchasePricePaise,
                sellingPricePaise: sellingPricePaise,
                stockQty: stockQty,
                minStockQty: minStockQty,
                supplierId: supplierId,
                imagePath: imagePath,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String sku,
                required String barcode,
                required String category,
                required String unit,
                Value<int> purchasePricePaise = const Value.absent(),
                Value<int> sellingPricePaise = const Value.absent(),
                Value<double> stockQty = const Value.absent(),
                Value<double> minStockQty = const Value.absent(),
                Value<int?> supplierId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                sku: sku,
                barcode: barcode,
                category: category,
                unit: unit,
                purchasePricePaise: purchasePricePaise,
                sellingPricePaise: sellingPricePaise,
                stockQty: stockQty,
                minStockQty: minStockQty,
                supplierId: supplierId,
                imagePath: imagePath,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                supplierId = false,
                stockMovementsRefs = false,
                transactionLinesRefs = false,
                purchaseItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stockMovementsRefs) db.stockMovements,
                    if (transactionLinesRefs) db.transactionLines,
                    if (purchaseItemsRefs) db.purchaseItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (supplierId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.supplierId,
                                    referencedTable: $$ProductsTableReferences
                                        ._supplierIdTable(db),
                                    referencedColumn: $$ProductsTableReferences
                                        ._supplierIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stockMovementsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          StockMovement
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._stockMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transactionLinesRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          TransactionLine
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._transactionLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (purchaseItemsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          PurchaseItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._purchaseItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({
        bool supplierId,
        bool stockMovementsRefs,
        bool transactionLinesRefs,
        bool purchaseItemsRefs,
      })
    >;
typedef $$StockMovementsTableCreateCompanionBuilder =
    StockMovementsCompanion Function({
      Value<int> id,
      required int productId,
      required StockMovementKind kind,
      required double quantityDelta,
      Value<int?> unitCostPaise,
      required String reason,
      Value<String?> referenceType,
      Value<int?> referenceId,
      required DateTime createdAt,
    });
typedef $$StockMovementsTableUpdateCompanionBuilder =
    StockMovementsCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<StockMovementKind> kind,
      Value<double> quantityDelta,
      Value<int?> unitCostPaise,
      Value<String> reason,
      Value<String?> referenceType,
      Value<int?> referenceId,
      Value<DateTime> createdAt,
    });

final class $$StockMovementsTableReferences
    extends BaseReferences<_$AppDatabase, $StockMovementsTable, StockMovement> {
  $$StockMovementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.stockMovements.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StockMovementKind, StockMovementKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get quantityDelta => $composableBuilder(
    column: $table.quantityDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceType => $composableBuilder(
    column: $table.referenceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityDelta => $composableBuilder(
    column: $table.quantityDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceType => $composableBuilder(
    column: $table.referenceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StockMovementKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get quantityDelta => $composableBuilder(
    column: $table.quantityDelta,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get referenceType => $composableBuilder(
    column: $table.referenceType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockMovementsTable,
          StockMovement,
          $$StockMovementsTableFilterComposer,
          $$StockMovementsTableOrderingComposer,
          $$StockMovementsTableAnnotationComposer,
          $$StockMovementsTableCreateCompanionBuilder,
          $$StockMovementsTableUpdateCompanionBuilder,
          (StockMovement, $$StockMovementsTableReferences),
          StockMovement,
          PrefetchHooks Function({bool productId})
        > {
  $$StockMovementsTableTableManager(
    _$AppDatabase db,
    $StockMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<StockMovementKind> kind = const Value.absent(),
                Value<double> quantityDelta = const Value.absent(),
                Value<int?> unitCostPaise = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String?> referenceType = const Value.absent(),
                Value<int?> referenceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StockMovementsCompanion(
                id: id,
                productId: productId,
                kind: kind,
                quantityDelta: quantityDelta,
                unitCostPaise: unitCostPaise,
                reason: reason,
                referenceType: referenceType,
                referenceId: referenceId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required StockMovementKind kind,
                required double quantityDelta,
                Value<int?> unitCostPaise = const Value.absent(),
                required String reason,
                Value<String?> referenceType = const Value.absent(),
                Value<int?> referenceId = const Value.absent(),
                required DateTime createdAt,
              }) => StockMovementsCompanion.insert(
                id: id,
                productId: productId,
                kind: kind,
                quantityDelta: quantityDelta,
                unitCostPaise: unitCostPaise,
                reason: reason,
                referenceType: referenceType,
                referenceId: referenceId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StockMovementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$StockMovementsTableReferences
                                    ._productIdTable(db),
                                referencedColumn:
                                    $$StockMovementsTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StockMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockMovementsTable,
      StockMovement,
      $$StockMovementsTableFilterComposer,
      $$StockMovementsTableOrderingComposer,
      $$StockMovementsTableAnnotationComposer,
      $$StockMovementsTableCreateCompanionBuilder,
      $$StockMovementsTableUpdateCompanionBuilder,
      (StockMovement, $$StockMovementsTableReferences),
      StockMovement,
      PrefetchHooks Function({bool productId})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required TransactionKind kind,
      required int amountPaise,
      required int cashDeltaPaise,
      required int creditDeltaPaise,
      Value<int?> customerId,
      Value<int?> supplierId,
      required PaymentMethod method,
      required String note,
      required EntrySource source,
      Value<String?> externalRef,
      required DateTime occurredAt,
      required DateTime createdAt,
      Value<bool> isReversed,
      Value<int?> reversalOfId,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<TransactionKind> kind,
      Value<int> amountPaise,
      Value<int> cashDeltaPaise,
      Value<int> creditDeltaPaise,
      Value<int?> customerId,
      Value<int?> supplierId,
      Value<PaymentMethod> method,
      Value<String> note,
      Value<EntrySource> source,
      Value<String?> externalRef,
      Value<DateTime> occurredAt,
      Value<DateTime> createdAt,
      Value<bool> isReversed,
      Value<int?> reversalOfId,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias(
        $_aliasNameGenerator(db.transactions.customerId, db.customers.id),
      );

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias(
        $_aliasNameGenerator(db.transactions.supplierId, db.suppliers.id),
      );

  $$SuppliersTableProcessedTableManager? get supplierId {
    final $_column = $_itemColumn<int>('supplier_id');
    if ($_column == null) return null;
    final manager = $$SuppliersTableTableManager(
      $_db,
      $_db.suppliers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _reversalOfIdTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        $_aliasNameGenerator(db.transactions.reversalOfId, db.transactions.id),
      );

  $$TransactionsTableProcessedTableManager? get reversalOfId {
    final $_column = $_itemColumn<int>('reversal_of_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reversalOfIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionLinesTable, List<TransactionLine>>
  _transactionLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionLines,
    aliasName: $_aliasNameGenerator(
      db.transactions.id,
      db.transactionLines.transactionId,
    ),
  );

  $$TransactionLinesTableProcessedTableManager get transactionLinesRefs {
    final manager = $$TransactionLinesTableTableManager(
      $_db,
      $_db.transactionLines,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SolanaPaymentsTable, List<SolanaPayment>>
  _solanaPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.solanaPayments,
    aliasName: $_aliasNameGenerator(
      db.transactions.id,
      db.solanaPayments.ledgerTransactionId,
    ),
  );

  $$SolanaPaymentsTableProcessedTableManager get solanaPaymentsRefs {
    final manager = $$SolanaPaymentsTableTableManager($_db, $_db.solanaPayments)
        .filter(
          (f) => f.ledgerTransactionId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_solanaPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionKind, TransactionKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cashDeltaPaise => $composableBuilder(
    column: $table.cashDeltaPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditDeltaPaise => $composableBuilder(
    column: $table.creditDeltaPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMethod, PaymentMethod, String>
  get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EntrySource, EntrySource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get externalRef => $composableBuilder(
    column: $table.externalRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isReversed => $composableBuilder(
    column: $table.isReversed,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableFilterComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get reversalOfId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversalOfId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionLinesRefs(
    Expression<bool> Function($$TransactionLinesTableFilterComposer f) f,
  ) {
    final $$TransactionLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableFilterComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> solanaPaymentsRefs(
    Expression<bool> Function($$SolanaPaymentsTableFilterComposer f) f,
  ) {
    final $$SolanaPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.solanaPayments,
      getReferencedColumn: (t) => t.ledgerTransactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SolanaPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.solanaPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cashDeltaPaise => $composableBuilder(
    column: $table.cashDeltaPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditDeltaPaise => $composableBuilder(
    column: $table.creditDeltaPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalRef => $composableBuilder(
    column: $table.externalRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isReversed => $composableBuilder(
    column: $table.isReversed,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableOrderingComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get reversalOfId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversalOfId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cashDeltaPaise => $composableBuilder(
    column: $table.cashDeltaPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creditDeltaPaise => $composableBuilder(
    column: $table.creditDeltaPaise,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PaymentMethod, String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EntrySource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalRef => $composableBuilder(
    column: $table.externalRef,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isReversed => $composableBuilder(
    column: $table.isReversed,
    builder: (column) => column,
  );

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableAnnotationComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get reversalOfId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversalOfId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionLinesRefs<T extends Object>(
    Expression<T> Function($$TransactionLinesTableAnnotationComposer a) f,
  ) {
    final $$TransactionLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionLines,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.transactionLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> solanaPaymentsRefs<T extends Object>(
    Expression<T> Function($$SolanaPaymentsTableAnnotationComposer a) f,
  ) {
    final $$SolanaPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.solanaPayments,
      getReferencedColumn: (t) => t.ledgerTransactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SolanaPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.solanaPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({
            bool customerId,
            bool supplierId,
            bool reversalOfId,
            bool transactionLinesRefs,
            bool solanaPaymentsRefs,
          })
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<TransactionKind> kind = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<int> cashDeltaPaise = const Value.absent(),
                Value<int> creditDeltaPaise = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                Value<int?> supplierId = const Value.absent(),
                Value<PaymentMethod> method = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<EntrySource> source = const Value.absent(),
                Value<String?> externalRef = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isReversed = const Value.absent(),
                Value<int?> reversalOfId = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                kind: kind,
                amountPaise: amountPaise,
                cashDeltaPaise: cashDeltaPaise,
                creditDeltaPaise: creditDeltaPaise,
                customerId: customerId,
                supplierId: supplierId,
                method: method,
                note: note,
                source: source,
                externalRef: externalRef,
                occurredAt: occurredAt,
                createdAt: createdAt,
                isReversed: isReversed,
                reversalOfId: reversalOfId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TransactionKind kind,
                required int amountPaise,
                required int cashDeltaPaise,
                required int creditDeltaPaise,
                Value<int?> customerId = const Value.absent(),
                Value<int?> supplierId = const Value.absent(),
                required PaymentMethod method,
                required String note,
                required EntrySource source,
                Value<String?> externalRef = const Value.absent(),
                required DateTime occurredAt,
                required DateTime createdAt,
                Value<bool> isReversed = const Value.absent(),
                Value<int?> reversalOfId = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                kind: kind,
                amountPaise: amountPaise,
                cashDeltaPaise: cashDeltaPaise,
                creditDeltaPaise: creditDeltaPaise,
                customerId: customerId,
                supplierId: supplierId,
                method: method,
                note: note,
                source: source,
                externalRef: externalRef,
                occurredAt: occurredAt,
                createdAt: createdAt,
                isReversed: isReversed,
                reversalOfId: reversalOfId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                supplierId = false,
                reversalOfId = false,
                transactionLinesRefs = false,
                solanaPaymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionLinesRefs) db.transactionLines,
                    if (solanaPaymentsRefs) db.solanaPayments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._customerIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._customerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (supplierId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.supplierId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._supplierIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._supplierIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (reversalOfId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.reversalOfId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._reversalOfIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._reversalOfIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionLinesRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          TransactionLine
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._transactionLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (solanaPaymentsRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          SolanaPayment
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._solanaPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).solanaPaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ledgerTransactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({
        bool customerId,
        bool supplierId,
        bool reversalOfId,
        bool transactionLinesRefs,
        bool solanaPaymentsRefs,
      })
    >;
typedef $$TransactionLinesTableCreateCompanionBuilder =
    TransactionLinesCompanion Function({
      Value<int> id,
      required int transactionId,
      required int productId,
      required double quantity,
      required int unitPricePaise,
      required int unitCostPaise,
    });
typedef $$TransactionLinesTableUpdateCompanionBuilder =
    TransactionLinesCompanion Function({
      Value<int> id,
      Value<int> transactionId,
      Value<int> productId,
      Value<double> quantity,
      Value<int> unitPricePaise,
      Value<int> unitCostPaise,
    });

final class $$TransactionLinesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TransactionLinesTable, TransactionLine> {
  $$TransactionLinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        $_aliasNameGenerator(
          db.transactionLines.transactionId,
          db.transactions.id,
        ),
      );

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<int>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.transactionLines.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionLinesTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionLinesTable> {
  $$TransactionLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionLinesTable> {
  $$TransactionLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionLinesTable> {
  $$TransactionLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPricePaise => $composableBuilder(
    column: $table.unitPricePaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => column,
  );

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionLinesTable,
          TransactionLine,
          $$TransactionLinesTableFilterComposer,
          $$TransactionLinesTableOrderingComposer,
          $$TransactionLinesTableAnnotationComposer,
          $$TransactionLinesTableCreateCompanionBuilder,
          $$TransactionLinesTableUpdateCompanionBuilder,
          (TransactionLine, $$TransactionLinesTableReferences),
          TransactionLine,
          PrefetchHooks Function({bool transactionId, bool productId})
        > {
  $$TransactionLinesTableTableManager(
    _$AppDatabase db,
    $TransactionLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> transactionId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<int> unitPricePaise = const Value.absent(),
                Value<int> unitCostPaise = const Value.absent(),
              }) => TransactionLinesCompanion(
                id: id,
                transactionId: transactionId,
                productId: productId,
                quantity: quantity,
                unitPricePaise: unitPricePaise,
                unitCostPaise: unitCostPaise,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int transactionId,
                required int productId,
                required double quantity,
                required int unitPricePaise,
                required int unitCostPaise,
              }) => TransactionLinesCompanion.insert(
                id: id,
                transactionId: transactionId,
                productId: productId,
                quantity: quantity,
                unitPricePaise: unitPricePaise,
                unitCostPaise: unitCostPaise,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (transactionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.transactionId,
                                referencedTable:
                                    $$TransactionLinesTableReferences
                                        ._transactionIdTable(db),
                                referencedColumn:
                                    $$TransactionLinesTableReferences
                                        ._transactionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$TransactionLinesTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$TransactionLinesTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TransactionLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionLinesTable,
      TransactionLine,
      $$TransactionLinesTableFilterComposer,
      $$TransactionLinesTableOrderingComposer,
      $$TransactionLinesTableAnnotationComposer,
      $$TransactionLinesTableCreateCompanionBuilder,
      $$TransactionLinesTableUpdateCompanionBuilder,
      (TransactionLine, $$TransactionLinesTableReferences),
      TransactionLine,
      PrefetchHooks Function({bool transactionId, bool productId})
    >;
typedef $$PurchasesTableCreateCompanionBuilder =
    PurchasesCompanion Function({
      Value<int> id,
      required int supplierId,
      required String invoiceNumber,
      required int totalPaise,
      Value<int> paidPaise,
      required String note,
      required DateTime occurredAt,
      required DateTime createdAt,
    });
typedef $$PurchasesTableUpdateCompanionBuilder =
    PurchasesCompanion Function({
      Value<int> id,
      Value<int> supplierId,
      Value<String> invoiceNumber,
      Value<int> totalPaise,
      Value<int> paidPaise,
      Value<String> note,
      Value<DateTime> occurredAt,
      Value<DateTime> createdAt,
    });

final class $$PurchasesTableReferences
    extends BaseReferences<_$AppDatabase, $PurchasesTable, Purchase> {
  $$PurchasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias(
        $_aliasNameGenerator(db.purchases.supplierId, db.suppliers.id),
      );

  $$SuppliersTableProcessedTableManager get supplierId {
    final $_column = $_itemColumn<int>('supplier_id')!;

    final manager = $$SuppliersTableTableManager(
      $_db,
      $_db.suppliers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
  _purchaseItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseItems,
    aliasName: $_aliasNameGenerator(
      db.purchases.id,
      db.purchaseItems.purchaseId,
    ),
  );

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager(
      $_db,
      $_db.purchaseItems,
    ).filter((f) => f.purchaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidPaise => $composableBuilder(
    column: $table.paidPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableFilterComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> purchaseItemsRefs(
    Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f,
  ) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.purchaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableFilterComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidPaise => $composableBuilder(
    column: $table.paidPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableOrderingComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPaise => $composableBuilder(
    column: $table.totalPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paidPaise =>
      $composableBuilder(column: $table.paidPaise, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableAnnotationComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
    Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f,
  ) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.purchaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchasesTable,
          Purchase,
          $$PurchasesTableFilterComposer,
          $$PurchasesTableOrderingComposer,
          $$PurchasesTableAnnotationComposer,
          $$PurchasesTableCreateCompanionBuilder,
          $$PurchasesTableUpdateCompanionBuilder,
          (Purchase, $$PurchasesTableReferences),
          Purchase,
          PrefetchHooks Function({bool supplierId, bool purchaseItemsRefs})
        > {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> supplierId = const Value.absent(),
                Value<String> invoiceNumber = const Value.absent(),
                Value<int> totalPaise = const Value.absent(),
                Value<int> paidPaise = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PurchasesCompanion(
                id: id,
                supplierId: supplierId,
                invoiceNumber: invoiceNumber,
                totalPaise: totalPaise,
                paidPaise: paidPaise,
                note: note,
                occurredAt: occurredAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int supplierId,
                required String invoiceNumber,
                required int totalPaise,
                Value<int> paidPaise = const Value.absent(),
                required String note,
                required DateTime occurredAt,
                required DateTime createdAt,
              }) => PurchasesCompanion.insert(
                id: id,
                supplierId: supplierId,
                invoiceNumber: invoiceNumber,
                totalPaise: totalPaise,
                paidPaise: paidPaise,
                note: note,
                occurredAt: occurredAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PurchasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({supplierId = false, purchaseItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (purchaseItemsRefs) db.purchaseItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (supplierId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.supplierId,
                                    referencedTable: $$PurchasesTableReferences
                                        ._supplierIdTable(db),
                                    referencedColumn: $$PurchasesTableReferences
                                        ._supplierIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (purchaseItemsRefs)
                        await $_getPrefetchedData<
                          Purchase,
                          $PurchasesTable,
                          PurchaseItem
                        >(
                          currentTable: table,
                          referencedTable: $$PurchasesTableReferences
                              ._purchaseItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PurchasesTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.purchaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchasesTable,
      Purchase,
      $$PurchasesTableFilterComposer,
      $$PurchasesTableOrderingComposer,
      $$PurchasesTableAnnotationComposer,
      $$PurchasesTableCreateCompanionBuilder,
      $$PurchasesTableUpdateCompanionBuilder,
      (Purchase, $$PurchasesTableReferences),
      Purchase,
      PrefetchHooks Function({bool supplierId, bool purchaseItemsRefs})
    >;
typedef $$PurchaseItemsTableCreateCompanionBuilder =
    PurchaseItemsCompanion Function({
      Value<int> id,
      required int purchaseId,
      required int productId,
      required double quantity,
      required int unitCostPaise,
    });
typedef $$PurchaseItemsTableUpdateCompanionBuilder =
    PurchaseItemsCompanion Function({
      Value<int> id,
      Value<int> purchaseId,
      Value<int> productId,
      Value<double> quantity,
      Value<int> unitCostPaise,
    });

final class $$PurchaseItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PurchaseItemsTable, PurchaseItem> {
  $$PurchaseItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PurchasesTable _purchaseIdTable(_$AppDatabase db) =>
      db.purchases.createAlias(
        $_aliasNameGenerator(db.purchaseItems.purchaseId, db.purchases.id),
      );

  $$PurchasesTableProcessedTableManager get purchaseId {
    final $_column = $_itemColumn<int>('purchase_id')!;

    final manager = $$PurchasesTableTableManager(
      $_db,
      $_db.purchases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.purchaseItems.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PurchaseItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => ColumnFilters(column),
  );

  $$PurchasesTableFilterComposer get purchaseId {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableFilterComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => ColumnOrderings(column),
  );

  $$PurchasesTableOrderingComposer get purchaseId {
    final $$PurchasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableOrderingComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitCostPaise => $composableBuilder(
    column: $table.unitCostPaise,
    builder: (column) => column,
  );

  $$PurchasesTableAnnotationComposer get purchaseId {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseItemsTable,
          PurchaseItem,
          $$PurchaseItemsTableFilterComposer,
          $$PurchaseItemsTableOrderingComposer,
          $$PurchaseItemsTableAnnotationComposer,
          $$PurchaseItemsTableCreateCompanionBuilder,
          $$PurchaseItemsTableUpdateCompanionBuilder,
          (PurchaseItem, $$PurchaseItemsTableReferences),
          PurchaseItem,
          PrefetchHooks Function({bool purchaseId, bool productId})
        > {
  $$PurchaseItemsTableTableManager(_$AppDatabase db, $PurchaseItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> purchaseId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<int> unitCostPaise = const Value.absent(),
              }) => PurchaseItemsCompanion(
                id: id,
                purchaseId: purchaseId,
                productId: productId,
                quantity: quantity,
                unitCostPaise: unitCostPaise,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int purchaseId,
                required int productId,
                required double quantity,
                required int unitCostPaise,
              }) => PurchaseItemsCompanion.insert(
                id: id,
                purchaseId: purchaseId,
                productId: productId,
                quantity: quantity,
                unitCostPaise: unitCostPaise,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PurchaseItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({purchaseId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (purchaseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.purchaseId,
                                referencedTable: $$PurchaseItemsTableReferences
                                    ._purchaseIdTable(db),
                                referencedColumn: $$PurchaseItemsTableReferences
                                    ._purchaseIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$PurchaseItemsTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$PurchaseItemsTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PurchaseItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseItemsTable,
      PurchaseItem,
      $$PurchaseItemsTableFilterComposer,
      $$PurchaseItemsTableOrderingComposer,
      $$PurchaseItemsTableAnnotationComposer,
      $$PurchaseItemsTableCreateCompanionBuilder,
      $$PurchaseItemsTableUpdateCompanionBuilder,
      (PurchaseItem, $$PurchaseItemsTableReferences),
      PurchaseItem,
      PrefetchHooks Function({bool purchaseId, bool productId})
    >;
typedef $$PayeesTableCreateCompanionBuilder =
    PayeesCompanion Function({
      Value<int> id,
      required String name,
      required String walletAddress,
      Value<bool> archived,
      required DateTime createdAt,
    });
typedef $$PayeesTableUpdateCompanionBuilder =
    PayeesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> walletAddress,
      Value<bool> archived,
      Value<DateTime> createdAt,
    });

final class $$PayeesTableReferences
    extends BaseReferences<_$AppDatabase, $PayeesTable, Payee> {
  $$PayeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SolanaPaymentsTable, List<SolanaPayment>>
  _solanaPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.solanaPayments,
    aliasName: $_aliasNameGenerator(db.payees.id, db.solanaPayments.payeeId),
  );

  $$SolanaPaymentsTableProcessedTableManager get solanaPaymentsRefs {
    final manager = $$SolanaPaymentsTableTableManager(
      $_db,
      $_db.solanaPayments,
    ).filter((f) => f.payeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_solanaPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PayeesTableFilterComposer
    extends Composer<_$AppDatabase, $PayeesTable> {
  $$PayeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get walletAddress => $composableBuilder(
    column: $table.walletAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> solanaPaymentsRefs(
    Expression<bool> Function($$SolanaPaymentsTableFilterComposer f) f,
  ) {
    final $$SolanaPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.solanaPayments,
      getReferencedColumn: (t) => t.payeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SolanaPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.solanaPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PayeesTableOrderingComposer
    extends Composer<_$AppDatabase, $PayeesTable> {
  $$PayeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get walletAddress => $composableBuilder(
    column: $table.walletAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PayeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayeesTable> {
  $$PayeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get walletAddress => $composableBuilder(
    column: $table.walletAddress,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> solanaPaymentsRefs<T extends Object>(
    Expression<T> Function($$SolanaPaymentsTableAnnotationComposer a) f,
  ) {
    final $$SolanaPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.solanaPayments,
      getReferencedColumn: (t) => t.payeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SolanaPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.solanaPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PayeesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PayeesTable,
          Payee,
          $$PayeesTableFilterComposer,
          $$PayeesTableOrderingComposer,
          $$PayeesTableAnnotationComposer,
          $$PayeesTableCreateCompanionBuilder,
          $$PayeesTableUpdateCompanionBuilder,
          (Payee, $$PayeesTableReferences),
          Payee,
          PrefetchHooks Function({bool solanaPaymentsRefs})
        > {
  $$PayeesTableTableManager(_$AppDatabase db, $PayeesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> walletAddress = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PayeesCompanion(
                id: id,
                name: name,
                walletAddress: walletAddress,
                archived: archived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String walletAddress,
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
              }) => PayeesCompanion.insert(
                id: id,
                name: name,
                walletAddress: walletAddress,
                archived: archived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PayeesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({solanaPaymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (solanaPaymentsRefs) db.solanaPayments,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (solanaPaymentsRefs)
                    await $_getPrefetchedData<
                      Payee,
                      $PayeesTable,
                      SolanaPayment
                    >(
                      currentTable: table,
                      referencedTable: $$PayeesTableReferences
                          ._solanaPaymentsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PayeesTableReferences(
                        db,
                        table,
                        p0,
                      ).solanaPaymentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.payeeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PayeesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PayeesTable,
      Payee,
      $$PayeesTableFilterComposer,
      $$PayeesTableOrderingComposer,
      $$PayeesTableAnnotationComposer,
      $$PayeesTableCreateCompanionBuilder,
      $$PayeesTableUpdateCompanionBuilder,
      (Payee, $$PayeesTableReferences),
      Payee,
      PrefetchHooks Function({bool solanaPaymentsRefs})
    >;
typedef $$SolanaPaymentsTableCreateCompanionBuilder =
    SolanaPaymentsCompanion Function({
      Value<int> id,
      required String idempotencyKey,
      Value<int?> payeeId,
      required String recipientName,
      required String recipientAddress,
      required int amountLamports,
      Value<int> inrMemoPaise,
      required String network,
      required PaymentStatus status,
      required String requestText,
      Value<String?> signature,
      Value<String?> explorerUrl,
      Value<int?> ledgerTransactionId,
      Value<String?> errorMessage,
      Value<String?> policySnapshotJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> confirmedAt,
    });
typedef $$SolanaPaymentsTableUpdateCompanionBuilder =
    SolanaPaymentsCompanion Function({
      Value<int> id,
      Value<String> idempotencyKey,
      Value<int?> payeeId,
      Value<String> recipientName,
      Value<String> recipientAddress,
      Value<int> amountLamports,
      Value<int> inrMemoPaise,
      Value<String> network,
      Value<PaymentStatus> status,
      Value<String> requestText,
      Value<String?> signature,
      Value<String?> explorerUrl,
      Value<int?> ledgerTransactionId,
      Value<String?> errorMessage,
      Value<String?> policySnapshotJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> confirmedAt,
    });

final class $$SolanaPaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $SolanaPaymentsTable, SolanaPayment> {
  $$SolanaPaymentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PayeesTable _payeeIdTable(_$AppDatabase db) => db.payees.createAlias(
    $_aliasNameGenerator(db.solanaPayments.payeeId, db.payees.id),
  );

  $$PayeesTableProcessedTableManager? get payeeId {
    final $_column = $_itemColumn<int>('payee_id');
    if ($_column == null) return null;
    final manager = $$PayeesTableTableManager(
      $_db,
      $_db.payees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_payeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _ledgerTransactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        $_aliasNameGenerator(
          db.solanaPayments.ledgerTransactionId,
          db.transactions.id,
        ),
      );

  $$TransactionsTableProcessedTableManager? get ledgerTransactionId {
    final $_column = $_itemColumn<int>('ledger_transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ledgerTransactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SolanaPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $SolanaPaymentsTable> {
  $$SolanaPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipientName => $composableBuilder(
    column: $table.recipientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipientAddress => $composableBuilder(
    column: $table.recipientAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountLamports => $composableBuilder(
    column: $table.amountLamports,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inrMemoPaise => $composableBuilder(
    column: $table.inrMemoPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentStatus, PaymentStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get requestText => $composableBuilder(
    column: $table.requestText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explorerUrl => $composableBuilder(
    column: $table.explorerUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get policySnapshotJson => $composableBuilder(
    column: $table.policySnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PayeesTableFilterComposer get payeeId {
    final $$PayeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.payeeId,
      referencedTable: $db.payees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PayeesTableFilterComposer(
            $db: $db,
            $table: $db.payees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get ledgerTransactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SolanaPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $SolanaPaymentsTable> {
  $$SolanaPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipientName => $composableBuilder(
    column: $table.recipientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipientAddress => $composableBuilder(
    column: $table.recipientAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountLamports => $composableBuilder(
    column: $table.amountLamports,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inrMemoPaise => $composableBuilder(
    column: $table.inrMemoPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestText => $composableBuilder(
    column: $table.requestText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explorerUrl => $composableBuilder(
    column: $table.explorerUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get policySnapshotJson => $composableBuilder(
    column: $table.policySnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PayeesTableOrderingComposer get payeeId {
    final $$PayeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.payeeId,
      referencedTable: $db.payees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PayeesTableOrderingComposer(
            $db: $db,
            $table: $db.payees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get ledgerTransactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SolanaPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SolanaPaymentsTable> {
  $$SolanaPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recipientName => $composableBuilder(
    column: $table.recipientName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recipientAddress => $composableBuilder(
    column: $table.recipientAddress,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountLamports => $composableBuilder(
    column: $table.amountLamports,
    builder: (column) => column,
  );

  GeneratedColumn<int> get inrMemoPaise => $composableBuilder(
    column: $table.inrMemoPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get network =>
      $composableBuilder(column: $table.network, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get requestText => $composableBuilder(
    column: $table.requestText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signature =>
      $composableBuilder(column: $table.signature, builder: (column) => column);

  GeneratedColumn<String> get explorerUrl => $composableBuilder(
    column: $table.explorerUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get policySnapshotJson => $composableBuilder(
    column: $table.policySnapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => column,
  );

  $$PayeesTableAnnotationComposer get payeeId {
    final $$PayeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.payeeId,
      referencedTable: $db.payees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PayeesTableAnnotationComposer(
            $db: $db,
            $table: $db.payees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get ledgerTransactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SolanaPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SolanaPaymentsTable,
          SolanaPayment,
          $$SolanaPaymentsTableFilterComposer,
          $$SolanaPaymentsTableOrderingComposer,
          $$SolanaPaymentsTableAnnotationComposer,
          $$SolanaPaymentsTableCreateCompanionBuilder,
          $$SolanaPaymentsTableUpdateCompanionBuilder,
          (SolanaPayment, $$SolanaPaymentsTableReferences),
          SolanaPayment,
          PrefetchHooks Function({bool payeeId, bool ledgerTransactionId})
        > {
  $$SolanaPaymentsTableTableManager(
    _$AppDatabase db,
    $SolanaPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SolanaPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SolanaPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SolanaPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<int?> payeeId = const Value.absent(),
                Value<String> recipientName = const Value.absent(),
                Value<String> recipientAddress = const Value.absent(),
                Value<int> amountLamports = const Value.absent(),
                Value<int> inrMemoPaise = const Value.absent(),
                Value<String> network = const Value.absent(),
                Value<PaymentStatus> status = const Value.absent(),
                Value<String> requestText = const Value.absent(),
                Value<String?> signature = const Value.absent(),
                Value<String?> explorerUrl = const Value.absent(),
                Value<int?> ledgerTransactionId = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> policySnapshotJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> confirmedAt = const Value.absent(),
              }) => SolanaPaymentsCompanion(
                id: id,
                idempotencyKey: idempotencyKey,
                payeeId: payeeId,
                recipientName: recipientName,
                recipientAddress: recipientAddress,
                amountLamports: amountLamports,
                inrMemoPaise: inrMemoPaise,
                network: network,
                status: status,
                requestText: requestText,
                signature: signature,
                explorerUrl: explorerUrl,
                ledgerTransactionId: ledgerTransactionId,
                errorMessage: errorMessage,
                policySnapshotJson: policySnapshotJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                confirmedAt: confirmedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String idempotencyKey,
                Value<int?> payeeId = const Value.absent(),
                required String recipientName,
                required String recipientAddress,
                required int amountLamports,
                Value<int> inrMemoPaise = const Value.absent(),
                required String network,
                required PaymentStatus status,
                required String requestText,
                Value<String?> signature = const Value.absent(),
                Value<String?> explorerUrl = const Value.absent(),
                Value<int?> ledgerTransactionId = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> policySnapshotJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> confirmedAt = const Value.absent(),
              }) => SolanaPaymentsCompanion.insert(
                id: id,
                idempotencyKey: idempotencyKey,
                payeeId: payeeId,
                recipientName: recipientName,
                recipientAddress: recipientAddress,
                amountLamports: amountLamports,
                inrMemoPaise: inrMemoPaise,
                network: network,
                status: status,
                requestText: requestText,
                signature: signature,
                explorerUrl: explorerUrl,
                ledgerTransactionId: ledgerTransactionId,
                errorMessage: errorMessage,
                policySnapshotJson: policySnapshotJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                confirmedAt: confirmedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SolanaPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({payeeId = false, ledgerTransactionId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (payeeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.payeeId,
                                    referencedTable:
                                        $$SolanaPaymentsTableReferences
                                            ._payeeIdTable(db),
                                    referencedColumn:
                                        $$SolanaPaymentsTableReferences
                                            ._payeeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (ledgerTransactionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ledgerTransactionId,
                                    referencedTable:
                                        $$SolanaPaymentsTableReferences
                                            ._ledgerTransactionIdTable(db),
                                    referencedColumn:
                                        $$SolanaPaymentsTableReferences
                                            ._ledgerTransactionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$SolanaPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SolanaPaymentsTable,
      SolanaPayment,
      $$SolanaPaymentsTableFilterComposer,
      $$SolanaPaymentsTableOrderingComposer,
      $$SolanaPaymentsTableAnnotationComposer,
      $$SolanaPaymentsTableCreateCompanionBuilder,
      $$SolanaPaymentsTableUpdateCompanionBuilder,
      (SolanaPayment, $$SolanaPaymentsTableReferences),
      SolanaPayment,
      PrefetchHooks Function({bool payeeId, bool ledgerTransactionId})
    >;
typedef $$PolicyRowsTableCreateCompanionBuilder =
    PolicyRowsCompanion Function({
      Value<int> id,
      required int maxPerPaymentLamports,
      required int dailyLimitLamports,
      required bool savedRecipientsOnly,
      required bool devnetOnly,
      required bool requireApproval,
      required DateTime updatedAt,
    });
typedef $$PolicyRowsTableUpdateCompanionBuilder =
    PolicyRowsCompanion Function({
      Value<int> id,
      Value<int> maxPerPaymentLamports,
      Value<int> dailyLimitLamports,
      Value<bool> savedRecipientsOnly,
      Value<bool> devnetOnly,
      Value<bool> requireApproval,
      Value<DateTime> updatedAt,
    });

class $$PolicyRowsTableFilterComposer
    extends Composer<_$AppDatabase, $PolicyRowsTable> {
  $$PolicyRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxPerPaymentLamports => $composableBuilder(
    column: $table.maxPerPaymentLamports,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyLimitLamports => $composableBuilder(
    column: $table.dailyLimitLamports,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get savedRecipientsOnly => $composableBuilder(
    column: $table.savedRecipientsOnly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get devnetOnly => $composableBuilder(
    column: $table.devnetOnly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requireApproval => $composableBuilder(
    column: $table.requireApproval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PolicyRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $PolicyRowsTable> {
  $$PolicyRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxPerPaymentLamports => $composableBuilder(
    column: $table.maxPerPaymentLamports,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyLimitLamports => $composableBuilder(
    column: $table.dailyLimitLamports,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get savedRecipientsOnly => $composableBuilder(
    column: $table.savedRecipientsOnly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get devnetOnly => $composableBuilder(
    column: $table.devnetOnly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requireApproval => $composableBuilder(
    column: $table.requireApproval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PolicyRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PolicyRowsTable> {
  $$PolicyRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get maxPerPaymentLamports => $composableBuilder(
    column: $table.maxPerPaymentLamports,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyLimitLamports => $composableBuilder(
    column: $table.dailyLimitLamports,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get savedRecipientsOnly => $composableBuilder(
    column: $table.savedRecipientsOnly,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get devnetOnly => $composableBuilder(
    column: $table.devnetOnly,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requireApproval => $composableBuilder(
    column: $table.requireApproval,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PolicyRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PolicyRowsTable,
          PolicyRow,
          $$PolicyRowsTableFilterComposer,
          $$PolicyRowsTableOrderingComposer,
          $$PolicyRowsTableAnnotationComposer,
          $$PolicyRowsTableCreateCompanionBuilder,
          $$PolicyRowsTableUpdateCompanionBuilder,
          (
            PolicyRow,
            BaseReferences<_$AppDatabase, $PolicyRowsTable, PolicyRow>,
          ),
          PolicyRow,
          PrefetchHooks Function()
        > {
  $$PolicyRowsTableTableManager(_$AppDatabase db, $PolicyRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PolicyRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PolicyRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PolicyRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> maxPerPaymentLamports = const Value.absent(),
                Value<int> dailyLimitLamports = const Value.absent(),
                Value<bool> savedRecipientsOnly = const Value.absent(),
                Value<bool> devnetOnly = const Value.absent(),
                Value<bool> requireApproval = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PolicyRowsCompanion(
                id: id,
                maxPerPaymentLamports: maxPerPaymentLamports,
                dailyLimitLamports: dailyLimitLamports,
                savedRecipientsOnly: savedRecipientsOnly,
                devnetOnly: devnetOnly,
                requireApproval: requireApproval,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int maxPerPaymentLamports,
                required int dailyLimitLamports,
                required bool savedRecipientsOnly,
                required bool devnetOnly,
                required bool requireApproval,
                required DateTime updatedAt,
              }) => PolicyRowsCompanion.insert(
                id: id,
                maxPerPaymentLamports: maxPerPaymentLamports,
                dailyLimitLamports: dailyLimitLamports,
                savedRecipientsOnly: savedRecipientsOnly,
                devnetOnly: devnetOnly,
                requireApproval: requireApproval,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PolicyRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PolicyRowsTable,
      PolicyRow,
      $$PolicyRowsTableFilterComposer,
      $$PolicyRowsTableOrderingComposer,
      $$PolicyRowsTableAnnotationComposer,
      $$PolicyRowsTableCreateCompanionBuilder,
      $$PolicyRowsTableUpdateCompanionBuilder,
      (PolicyRow, BaseReferences<_$AppDatabase, $PolicyRowsTable, PolicyRow>),
      PolicyRow,
      PrefetchHooks Function()
    >;
typedef $$AuditLogsTableCreateCompanionBuilder =
    AuditLogsCompanion Function({
      Value<int> id,
      required String entityType,
      Value<int?> entityId,
      required String action,
      required String detailsJson,
      required DateTime createdAt,
    });
typedef $$AuditLogsTableUpdateCompanionBuilder =
    AuditLogsCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<int?> entityId,
      Value<String> action,
      Value<String> detailsJson,
      Value<DateTime> createdAt,
    });

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AuditLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogsTable,
          AuditLog,
          $$AuditLogsTableFilterComposer,
          $$AuditLogsTableOrderingComposer,
          $$AuditLogsTableAnnotationComposer,
          $$AuditLogsTableCreateCompanionBuilder,
          $$AuditLogsTableUpdateCompanionBuilder,
          (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
          AuditLog,
          PrefetchHooks Function()
        > {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int?> entityId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> detailsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AuditLogsCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                action: action,
                detailsJson: detailsJson,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                Value<int?> entityId = const Value.absent(),
                required String action,
                required String detailsJson,
                required DateTime createdAt,
              }) => AuditLogsCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                action: action,
                detailsJson: detailsJson,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogsTable,
      AuditLog,
      $$AuditLogsTableFilterComposer,
      $$AuditLogsTableOrderingComposer,
      $$AuditLogsTableAnnotationComposer,
      $$AuditLogsTableCreateCompanionBuilder,
      $$AuditLogsTableUpdateCompanionBuilder,
      (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
      AuditLog,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MerchantProfilesTableTableManager get merchantProfiles =>
      $$MerchantProfilesTableTableManager(_db, _db.merchantProfiles);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$StockMovementsTableTableManager get stockMovements =>
      $$StockMovementsTableTableManager(_db, _db.stockMovements);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionLinesTableTableManager get transactionLines =>
      $$TransactionLinesTableTableManager(_db, _db.transactionLines);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$PurchaseItemsTableTableManager get purchaseItems =>
      $$PurchaseItemsTableTableManager(_db, _db.purchaseItems);
  $$PayeesTableTableManager get payees =>
      $$PayeesTableTableManager(_db, _db.payees);
  $$SolanaPaymentsTableTableManager get solanaPayments =>
      $$SolanaPaymentsTableTableManager(_db, _db.solanaPayments);
  $$PolicyRowsTableTableManager get policyRows =>
      $$PolicyRowsTableTableManager(_db, _db.policyRows);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
