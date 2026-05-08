// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_db.dart';

// ignore_for_file: type=lint
class $DbTripTable extends DbTrip with TableInfo<$DbTripTable, DbTripData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbTripTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _destinationMeta =
      const VerificationMeta('destination');
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
      'destination', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<double> budget = GeneratedColumn<double>(
      'budget', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, destination, budget, isCompleted, startDate, endDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_trip';
  @override
  VerificationContext validateIntegrity(Insertable<DbTripData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
          _destinationMeta,
          destination.isAcceptableOrUnknown(
              data['destination']!, _destinationMeta));
    } else if (isInserting) {
      context.missing(_destinationMeta);
    }
    if (data.containsKey('budget')) {
      context.handle(_budgetMeta,
          budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta));
    } else if (isInserting) {
      context.missing(_budgetMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbTripData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbTripData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      destination: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}destination'])!,
      budget: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}budget'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
    );
  }

  @override
  $DbTripTable createAlias(String alias) {
    return $DbTripTable(attachedDatabase, alias);
  }
}

class DbTripData extends DataClass implements Insertable<DbTripData> {
  final int id;
  final String title;
  final String destination;
  final double budget;
  final bool isCompleted;
  final DateTime? startDate;
  final DateTime? endDate;
  const DbTripData(
      {required this.id,
      required this.title,
      required this.destination,
      required this.budget,
      required this.isCompleted,
      this.startDate,
      this.endDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['destination'] = Variable<String>(destination);
    map['budget'] = Variable<double>(budget);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    return map;
  }

  DbTripCompanion toCompanion(bool nullToAbsent) {
    return DbTripCompanion(
      id: Value(id),
      title: Value(title),
      destination: Value(destination),
      budget: Value(budget),
      isCompleted: Value(isCompleted),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
    );
  }

  factory DbTripData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbTripData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      destination: serializer.fromJson<String>(json['destination']),
      budget: serializer.fromJson<double>(json['budget']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'destination': serializer.toJson<String>(destination),
      'budget': serializer.toJson<double>(budget),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
    };
  }

  DbTripData copyWith(
          {int? id,
          String? title,
          String? destination,
          double? budget,
          bool? isCompleted,
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent()}) =>
      DbTripData(
        id: id ?? this.id,
        title: title ?? this.title,
        destination: destination ?? this.destination,
        budget: budget ?? this.budget,
        isCompleted: isCompleted ?? this.isCompleted,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
      );
  DbTripData copyWithCompanion(DbTripCompanion data) {
    return DbTripData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      destination:
          data.destination.present ? data.destination.value : this.destination,
      budget: data.budget.present ? data.budget.value : this.budget,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbTripData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('destination: $destination, ')
          ..write('budget: $budget, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, destination, budget, isCompleted, startDate, endDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbTripData &&
          other.id == this.id &&
          other.title == this.title &&
          other.destination == this.destination &&
          other.budget == this.budget &&
          other.isCompleted == this.isCompleted &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class DbTripCompanion extends UpdateCompanion<DbTripData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> destination;
  final Value<double> budget;
  final Value<bool> isCompleted;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  const DbTripCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.destination = const Value.absent(),
    this.budget = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  DbTripCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String destination,
    required double budget,
    this.isCompleted = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  })  : title = Value(title),
        destination = Value(destination),
        budget = Value(budget);
  static Insertable<DbTripData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? destination,
    Expression<double>? budget,
    Expression<bool>? isCompleted,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (destination != null) 'destination': destination,
      if (budget != null) 'budget': budget,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });
  }

  DbTripCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? destination,
      Value<double>? budget,
      Value<bool>? isCompleted,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate}) {
    return DbTripCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      budget: budget ?? this.budget,
      isCompleted: isCompleted ?? this.isCompleted,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (budget.present) {
      map['budget'] = Variable<double>(budget.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbTripCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('destination: $destination, ')
          ..write('budget: $budget, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }
}

class $DbExpenseTable extends DbExpense
    with TableInfo<$DbExpenseTable, DbExpenseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbExpenseTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<int> tripId = GeneratedColumn<int>(
      'trip_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES db_trip (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, tripId, title, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_expense';
  @override
  VerificationContext validateIntegrity(Insertable<DbExpenseData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(_tripIdMeta,
          tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta));
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbExpenseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbExpenseData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tripId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trip_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $DbExpenseTable createAlias(String alias) {
    return $DbExpenseTable(attachedDatabase, alias);
  }
}

class DbExpenseData extends DataClass implements Insertable<DbExpenseData> {
  final int id;
  final int tripId;
  final String title;
  final double amount;
  const DbExpenseData(
      {required this.id,
      required this.tripId,
      required this.title,
      required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trip_id'] = Variable<int>(tripId);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  DbExpenseCompanion toCompanion(bool nullToAbsent) {
    return DbExpenseCompanion(
      id: Value(id),
      tripId: Value(tripId),
      title: Value(title),
      amount: Value(amount),
    );
  }

  factory DbExpenseData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbExpenseData(
      id: serializer.fromJson<int>(json['id']),
      tripId: serializer.fromJson<int>(json['tripId']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tripId': serializer.toJson<int>(tripId),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
    };
  }

  DbExpenseData copyWith(
          {int? id, int? tripId, String? title, double? amount}) =>
      DbExpenseData(
        id: id ?? this.id,
        tripId: tripId ?? this.tripId,
        title: title ?? this.title,
        amount: amount ?? this.amount,
      );
  DbExpenseData copyWithCompanion(DbExpenseCompanion data) {
    return DbExpenseData(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbExpenseData(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('title: $title, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tripId, title, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbExpenseData &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.title == this.title &&
          other.amount == this.amount);
}

class DbExpenseCompanion extends UpdateCompanion<DbExpenseData> {
  final Value<int> id;
  final Value<int> tripId;
  final Value<String> title;
  final Value<double> amount;
  const DbExpenseCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
  });
  DbExpenseCompanion.insert({
    this.id = const Value.absent(),
    required int tripId,
    required String title,
    required double amount,
  })  : tripId = Value(tripId),
        title = Value(title),
        amount = Value(amount);
  static Insertable<DbExpenseData> custom({
    Expression<int>? id,
    Expression<int>? tripId,
    Expression<String>? title,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
    });
  }

  DbExpenseCompanion copyWith(
      {Value<int>? id,
      Value<int>? tripId,
      Value<String>? title,
      Value<double>? amount}) {
    return DbExpenseCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<int>(tripId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbExpenseCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('title: $title, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

abstract class _$FinanceDatabase extends GeneratedDatabase {
  _$FinanceDatabase(QueryExecutor e) : super(e);
  $FinanceDatabaseManager get managers => $FinanceDatabaseManager(this);
  late final $DbTripTable dbTrip = $DbTripTable(this);
  late final $DbExpenseTable dbExpense = $DbExpenseTable(this);
  late final TripDao tripDao = TripDao(this as FinanceDatabase);
  late final ExpenseDao expenseDao = ExpenseDao(this as FinanceDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [dbTrip, dbExpense];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('db_trip',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('db_expense', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$DbTripTableCreateCompanionBuilder = DbTripCompanion Function({
  Value<int> id,
  required String title,
  required String destination,
  required double budget,
  Value<bool> isCompleted,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
});
typedef $$DbTripTableUpdateCompanionBuilder = DbTripCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> destination,
  Value<double> budget,
  Value<bool> isCompleted,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
});

final class $$DbTripTableReferences
    extends BaseReferences<_$FinanceDatabase, $DbTripTable, DbTripData> {
  $$DbTripTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DbExpenseTable, List<DbExpenseData>>
      _dbExpenseRefsTable(_$FinanceDatabase db) =>
          MultiTypedResultKey.fromTable(db.dbExpense,
              aliasName:
                  $_aliasNameGenerator(db.dbTrip.id, db.dbExpense.tripId));

  $$DbExpenseTableProcessedTableManager get dbExpenseRefs {
    final manager = $$DbExpenseTableTableManager($_db, $_db.dbExpense)
        .filter((f) => f.tripId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_dbExpenseRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DbTripTableFilterComposer
    extends Composer<_$FinanceDatabase, $DbTripTable> {
  $$DbTripTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destination => $composableBuilder(
      column: $table.destination, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get budget => $composableBuilder(
      column: $table.budget, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  Expression<bool> dbExpenseRefs(
      Expression<bool> Function($$DbExpenseTableFilterComposer f) f) {
    final $$DbExpenseTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dbExpense,
        getReferencedColumn: (t) => t.tripId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbExpenseTableFilterComposer(
              $db: $db,
              $table: $db.dbExpense,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DbTripTableOrderingComposer
    extends Composer<_$FinanceDatabase, $DbTripTable> {
  $$DbTripTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destination => $composableBuilder(
      column: $table.destination, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get budget => $composableBuilder(
      column: $table.budget, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));
}

class $$DbTripTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $DbTripTable> {
  $$DbTripTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
      column: $table.destination, builder: (column) => column);

  GeneratedColumn<double> get budget =>
      $composableBuilder(column: $table.budget, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  Expression<T> dbExpenseRefs<T extends Object>(
      Expression<T> Function($$DbExpenseTableAnnotationComposer a) f) {
    final $$DbExpenseTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dbExpense,
        getReferencedColumn: (t) => t.tripId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbExpenseTableAnnotationComposer(
              $db: $db,
              $table: $db.dbExpense,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DbTripTableTableManager extends RootTableManager<
    _$FinanceDatabase,
    $DbTripTable,
    DbTripData,
    $$DbTripTableFilterComposer,
    $$DbTripTableOrderingComposer,
    $$DbTripTableAnnotationComposer,
    $$DbTripTableCreateCompanionBuilder,
    $$DbTripTableUpdateCompanionBuilder,
    (DbTripData, $$DbTripTableReferences),
    DbTripData,
    PrefetchHooks Function({bool dbExpenseRefs})> {
  $$DbTripTableTableManager(_$FinanceDatabase db, $DbTripTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbTripTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbTripTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbTripTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> destination = const Value.absent(),
            Value<double> budget = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
          }) =>
              DbTripCompanion(
            id: id,
            title: title,
            destination: destination,
            budget: budget,
            isCompleted: isCompleted,
            startDate: startDate,
            endDate: endDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String destination,
            required double budget,
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
          }) =>
              DbTripCompanion.insert(
            id: id,
            title: title,
            destination: destination,
            budget: budget,
            isCompleted: isCompleted,
            startDate: startDate,
            endDate: endDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DbTripTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({dbExpenseRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (dbExpenseRefs) db.dbExpense],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dbExpenseRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$DbTripTableReferences._dbExpenseRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DbTripTableReferences(db, table, p0)
                                .dbExpenseRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tripId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DbTripTableProcessedTableManager = ProcessedTableManager<
    _$FinanceDatabase,
    $DbTripTable,
    DbTripData,
    $$DbTripTableFilterComposer,
    $$DbTripTableOrderingComposer,
    $$DbTripTableAnnotationComposer,
    $$DbTripTableCreateCompanionBuilder,
    $$DbTripTableUpdateCompanionBuilder,
    (DbTripData, $$DbTripTableReferences),
    DbTripData,
    PrefetchHooks Function({bool dbExpenseRefs})>;
typedef $$DbExpenseTableCreateCompanionBuilder = DbExpenseCompanion Function({
  Value<int> id,
  required int tripId,
  required String title,
  required double amount,
});
typedef $$DbExpenseTableUpdateCompanionBuilder = DbExpenseCompanion Function({
  Value<int> id,
  Value<int> tripId,
  Value<String> title,
  Value<double> amount,
});

final class $$DbExpenseTableReferences
    extends BaseReferences<_$FinanceDatabase, $DbExpenseTable, DbExpenseData> {
  $$DbExpenseTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DbTripTable _tripIdTable(_$FinanceDatabase db) => db.dbTrip
      .createAlias($_aliasNameGenerator(db.dbExpense.tripId, db.dbTrip.id));

  $$DbTripTableProcessedTableManager? get tripId {
    if ($_item.tripId == null) return null;
    final manager = $$DbTripTableTableManager($_db, $_db.dbTrip)
        .filter((f) => f.id($_item.tripId!));
    final item = $_typedResult.readTableOrNull(_tripIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DbExpenseTableFilterComposer
    extends Composer<_$FinanceDatabase, $DbExpenseTable> {
  $$DbExpenseTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  $$DbTripTableFilterComposer get tripId {
    final $$DbTripTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.dbTrip,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbTripTableFilterComposer(
              $db: $db,
              $table: $db.dbTrip,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DbExpenseTableOrderingComposer
    extends Composer<_$FinanceDatabase, $DbExpenseTable> {
  $$DbExpenseTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  $$DbTripTableOrderingComposer get tripId {
    final $$DbTripTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.dbTrip,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbTripTableOrderingComposer(
              $db: $db,
              $table: $db.dbTrip,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DbExpenseTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $DbExpenseTable> {
  $$DbExpenseTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$DbTripTableAnnotationComposer get tripId {
    final $$DbTripTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tripId,
        referencedTable: $db.dbTrip,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DbTripTableAnnotationComposer(
              $db: $db,
              $table: $db.dbTrip,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DbExpenseTableTableManager extends RootTableManager<
    _$FinanceDatabase,
    $DbExpenseTable,
    DbExpenseData,
    $$DbExpenseTableFilterComposer,
    $$DbExpenseTableOrderingComposer,
    $$DbExpenseTableAnnotationComposer,
    $$DbExpenseTableCreateCompanionBuilder,
    $$DbExpenseTableUpdateCompanionBuilder,
    (DbExpenseData, $$DbExpenseTableReferences),
    DbExpenseData,
    PrefetchHooks Function({bool tripId})> {
  $$DbExpenseTableTableManager(_$FinanceDatabase db, $DbExpenseTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbExpenseTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbExpenseTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbExpenseTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tripId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> amount = const Value.absent(),
          }) =>
              DbExpenseCompanion(
            id: id,
            tripId: tripId,
            title: title,
            amount: amount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tripId,
            required String title,
            required double amount,
          }) =>
              DbExpenseCompanion.insert(
            id: id,
            tripId: tripId,
            title: title,
            amount: amount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DbExpenseTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tripId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (tripId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tripId,
                    referencedTable:
                        $$DbExpenseTableReferences._tripIdTable(db),
                    referencedColumn:
                        $$DbExpenseTableReferences._tripIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DbExpenseTableProcessedTableManager = ProcessedTableManager<
    _$FinanceDatabase,
    $DbExpenseTable,
    DbExpenseData,
    $$DbExpenseTableFilterComposer,
    $$DbExpenseTableOrderingComposer,
    $$DbExpenseTableAnnotationComposer,
    $$DbExpenseTableCreateCompanionBuilder,
    $$DbExpenseTableUpdateCompanionBuilder,
    (DbExpenseData, $$DbExpenseTableReferences),
    DbExpenseData,
    PrefetchHooks Function({bool tripId})>;

class $FinanceDatabaseManager {
  final _$FinanceDatabase _db;
  $FinanceDatabaseManager(this._db);
  $$DbTripTableTableManager get dbTrip =>
      $$DbTripTableTableManager(_db, _db.dbTrip);
  $$DbExpenseTableTableManager get dbExpense =>
      $$DbExpenseTableTableManager(_db, _db.dbExpense);
}

mixin _$TripDaoMixin on DatabaseAccessor<FinanceDatabase> {
  $DbTripTable get dbTrip => attachedDatabase.dbTrip;
}
mixin _$ExpenseDaoMixin on DatabaseAccessor<FinanceDatabase> {
  $DbTripTable get dbTrip => attachedDatabase.dbTrip;
  $DbExpenseTable get dbExpense => attachedDatabase.dbExpense;
}
