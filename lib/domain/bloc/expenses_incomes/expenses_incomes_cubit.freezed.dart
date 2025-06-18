// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expenses_incomes_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionsOnScreen {

 String get emoji; String get categoryName; String get amount; String get currency; bool get isIncome; String get comment;
/// Create a copy of TransactionsOnScreen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionsOnScreenCopyWith<TransactionsOnScreen> get copyWith => _$TransactionsOnScreenCopyWithImpl<TransactionsOnScreen>(this as TransactionsOnScreen, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionsOnScreen&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome)&&(identical(other.comment, comment) || other.comment == comment));
}


@override
int get hashCode => Object.hash(runtimeType,emoji,categoryName,amount,currency,isIncome,comment);

@override
String toString() {
  return 'TransactionsOnScreen(emoji: $emoji, categoryName: $categoryName, amount: $amount, currency: $currency, isIncome: $isIncome, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $TransactionsOnScreenCopyWith<$Res>  {
  factory $TransactionsOnScreenCopyWith(TransactionsOnScreen value, $Res Function(TransactionsOnScreen) _then) = _$TransactionsOnScreenCopyWithImpl;
@useResult
$Res call({
 String emoji, String categoryName, String amount, String currency, bool isIncome, String comment
});




}
/// @nodoc
class _$TransactionsOnScreenCopyWithImpl<$Res>
    implements $TransactionsOnScreenCopyWith<$Res> {
  _$TransactionsOnScreenCopyWithImpl(this._self, this._then);

  final TransactionsOnScreen _self;
  final $Res Function(TransactionsOnScreen) _then;

/// Create a copy of TransactionsOnScreen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emoji = null,Object? categoryName = null,Object? amount = null,Object? currency = null,Object? isIncome = null,Object? comment = null,}) {
  return _then(_self.copyWith(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _TransactionsOnScreen implements TransactionsOnScreen {
  const _TransactionsOnScreen({required this.emoji, required this.categoryName, required this.amount, required this.currency, required this.isIncome, required this.comment});
  

@override final  String emoji;
@override final  String categoryName;
@override final  String amount;
@override final  String currency;
@override final  bool isIncome;
@override final  String comment;

/// Create a copy of TransactionsOnScreen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionsOnScreenCopyWith<_TransactionsOnScreen> get copyWith => __$TransactionsOnScreenCopyWithImpl<_TransactionsOnScreen>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionsOnScreen&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome)&&(identical(other.comment, comment) || other.comment == comment));
}


@override
int get hashCode => Object.hash(runtimeType,emoji,categoryName,amount,currency,isIncome,comment);

@override
String toString() {
  return 'TransactionsOnScreen(emoji: $emoji, categoryName: $categoryName, amount: $amount, currency: $currency, isIncome: $isIncome, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$TransactionsOnScreenCopyWith<$Res> implements $TransactionsOnScreenCopyWith<$Res> {
  factory _$TransactionsOnScreenCopyWith(_TransactionsOnScreen value, $Res Function(_TransactionsOnScreen) _then) = __$TransactionsOnScreenCopyWithImpl;
@override @useResult
$Res call({
 String emoji, String categoryName, String amount, String currency, bool isIncome, String comment
});




}
/// @nodoc
class __$TransactionsOnScreenCopyWithImpl<$Res>
    implements _$TransactionsOnScreenCopyWith<$Res> {
  __$TransactionsOnScreenCopyWithImpl(this._self, this._then);

  final _TransactionsOnScreen _self;
  final $Res Function(_TransactionsOnScreen) _then;

/// Create a copy of TransactionsOnScreen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emoji = null,Object? categoryName = null,Object? amount = null,Object? currency = null,Object? isIncome = null,Object? comment = null,}) {
  return _then(_TransactionsOnScreen(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
