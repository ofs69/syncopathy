// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaFilter {

 int? get filterCategory; Set<String>? get funscriptAuthors; Set<String>? get funscriptTags; Set<String>? get funscriptPerformers;
/// Create a copy of MediaFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaFilterCopyWith<MediaFilter> get copyWith => _$MediaFilterCopyWithImpl<MediaFilter>(this as MediaFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaFilter&&(identical(other.filterCategory, filterCategory) || other.filterCategory == filterCategory)&&const DeepCollectionEquality().equals(other.funscriptAuthors, funscriptAuthors)&&const DeepCollectionEquality().equals(other.funscriptTags, funscriptTags)&&const DeepCollectionEquality().equals(other.funscriptPerformers, funscriptPerformers));
}


@override
int get hashCode => Object.hash(runtimeType,filterCategory,const DeepCollectionEquality().hash(funscriptAuthors),const DeepCollectionEquality().hash(funscriptTags),const DeepCollectionEquality().hash(funscriptPerformers));

@override
String toString() {
  return 'MediaFilter(filterCategory: $filterCategory, funscriptAuthors: $funscriptAuthors, funscriptTags: $funscriptTags, funscriptPerformers: $funscriptPerformers)';
}


}

/// @nodoc
abstract mixin class $MediaFilterCopyWith<$Res>  {
  factory $MediaFilterCopyWith(MediaFilter value, $Res Function(MediaFilter) _then) = _$MediaFilterCopyWithImpl;
@useResult
$Res call({
 int? filterCategory, Set<String>? funscriptAuthors, Set<String>? funscriptTags, Set<String>? funscriptPerformers
});




}
/// @nodoc
class _$MediaFilterCopyWithImpl<$Res>
    implements $MediaFilterCopyWith<$Res> {
  _$MediaFilterCopyWithImpl(this._self, this._then);

  final MediaFilter _self;
  final $Res Function(MediaFilter) _then;

/// Create a copy of MediaFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filterCategory = freezed,Object? funscriptAuthors = freezed,Object? funscriptTags = freezed,Object? funscriptPerformers = freezed,}) {
  return _then(_self.copyWith(
filterCategory: freezed == filterCategory ? _self.filterCategory : filterCategory // ignore: cast_nullable_to_non_nullable
as int?,funscriptAuthors: freezed == funscriptAuthors ? _self.funscriptAuthors : funscriptAuthors // ignore: cast_nullable_to_non_nullable
as Set<String>?,funscriptTags: freezed == funscriptTags ? _self.funscriptTags : funscriptTags // ignore: cast_nullable_to_non_nullable
as Set<String>?,funscriptPerformers: freezed == funscriptPerformers ? _self.funscriptPerformers : funscriptPerformers // ignore: cast_nullable_to_non_nullable
as Set<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaFilter].
extension MediaFilterPatterns on MediaFilter {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaFilter() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaFilter value)  $default,){
final _that = this;
switch (_that) {
case _MediaFilter():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaFilter value)?  $default,){
final _that = this;
switch (_that) {
case _MediaFilter() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? filterCategory,  Set<String>? funscriptAuthors,  Set<String>? funscriptTags,  Set<String>? funscriptPerformers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaFilter() when $default != null:
return $default(_that.filterCategory,_that.funscriptAuthors,_that.funscriptTags,_that.funscriptPerformers);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? filterCategory,  Set<String>? funscriptAuthors,  Set<String>? funscriptTags,  Set<String>? funscriptPerformers)  $default,) {final _that = this;
switch (_that) {
case _MediaFilter():
return $default(_that.filterCategory,_that.funscriptAuthors,_that.funscriptTags,_that.funscriptPerformers);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? filterCategory,  Set<String>? funscriptAuthors,  Set<String>? funscriptTags,  Set<String>? funscriptPerformers)?  $default,) {final _that = this;
switch (_that) {
case _MediaFilter() when $default != null:
return $default(_that.filterCategory,_that.funscriptAuthors,_that.funscriptTags,_that.funscriptPerformers);case _:
  return null;

}
}

}

/// @nodoc


class _MediaFilter extends MediaFilter {
  const _MediaFilter({this.filterCategory, final  Set<String>? funscriptAuthors, final  Set<String>? funscriptTags, final  Set<String>? funscriptPerformers}): _funscriptAuthors = funscriptAuthors,_funscriptTags = funscriptTags,_funscriptPerformers = funscriptPerformers,super._();
  

@override final  int? filterCategory;
 final  Set<String>? _funscriptAuthors;
@override Set<String>? get funscriptAuthors {
  final value = _funscriptAuthors;
  if (value == null) return null;
  if (_funscriptAuthors is EqualUnmodifiableSetView) return _funscriptAuthors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(value);
}

 final  Set<String>? _funscriptTags;
@override Set<String>? get funscriptTags {
  final value = _funscriptTags;
  if (value == null) return null;
  if (_funscriptTags is EqualUnmodifiableSetView) return _funscriptTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(value);
}

 final  Set<String>? _funscriptPerformers;
@override Set<String>? get funscriptPerformers {
  final value = _funscriptPerformers;
  if (value == null) return null;
  if (_funscriptPerformers is EqualUnmodifiableSetView) return _funscriptPerformers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(value);
}


/// Create a copy of MediaFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaFilterCopyWith<_MediaFilter> get copyWith => __$MediaFilterCopyWithImpl<_MediaFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaFilter&&(identical(other.filterCategory, filterCategory) || other.filterCategory == filterCategory)&&const DeepCollectionEquality().equals(other._funscriptAuthors, _funscriptAuthors)&&const DeepCollectionEquality().equals(other._funscriptTags, _funscriptTags)&&const DeepCollectionEquality().equals(other._funscriptPerformers, _funscriptPerformers));
}


@override
int get hashCode => Object.hash(runtimeType,filterCategory,const DeepCollectionEquality().hash(_funscriptAuthors),const DeepCollectionEquality().hash(_funscriptTags),const DeepCollectionEquality().hash(_funscriptPerformers));

@override
String toString() {
  return 'MediaFilter(filterCategory: $filterCategory, funscriptAuthors: $funscriptAuthors, funscriptTags: $funscriptTags, funscriptPerformers: $funscriptPerformers)';
}


}

/// @nodoc
abstract mixin class _$MediaFilterCopyWith<$Res> implements $MediaFilterCopyWith<$Res> {
  factory _$MediaFilterCopyWith(_MediaFilter value, $Res Function(_MediaFilter) _then) = __$MediaFilterCopyWithImpl;
@override @useResult
$Res call({
 int? filterCategory, Set<String>? funscriptAuthors, Set<String>? funscriptTags, Set<String>? funscriptPerformers
});




}
/// @nodoc
class __$MediaFilterCopyWithImpl<$Res>
    implements _$MediaFilterCopyWith<$Res> {
  __$MediaFilterCopyWithImpl(this._self, this._then);

  final _MediaFilter _self;
  final $Res Function(_MediaFilter) _then;

/// Create a copy of MediaFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filterCategory = freezed,Object? funscriptAuthors = freezed,Object? funscriptTags = freezed,Object? funscriptPerformers = freezed,}) {
  return _then(_MediaFilter(
filterCategory: freezed == filterCategory ? _self.filterCategory : filterCategory // ignore: cast_nullable_to_non_nullable
as int?,funscriptAuthors: freezed == funscriptAuthors ? _self._funscriptAuthors : funscriptAuthors // ignore: cast_nullable_to_non_nullable
as Set<String>?,funscriptTags: freezed == funscriptTags ? _self._funscriptTags : funscriptTags // ignore: cast_nullable_to_non_nullable
as Set<String>?,funscriptPerformers: freezed == funscriptPerformers ? _self._funscriptPerformers : funscriptPerformers // ignore: cast_nullable_to_non_nullable
as Set<String>?,
  ));
}


}

// dart format on
