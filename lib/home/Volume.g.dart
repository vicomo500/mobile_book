// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Volume.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Volume _$VolumeFromJson(Map<String, dynamic> json) {
  return Volume(
    json['title'] as String,
    (json['authors'] as List)?.map((e) => e as String)?.toList(),
    (json['categories'] as List)?.map((e) => e as String)?.toList(),
    json['imageLinks'] == null
        ? null
        : Thumbnail.fromJson(json['imageLinks'] as Map<String, dynamic>),
    json['description'] as String,
    json['publisher'] as String,
    json['publishedDate'] as String,
    (json['averageRating'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$VolumeToJson(Volume instance) => <String, dynamic>{
      'title': instance.title,
      'authors': instance.authors,
      'categories': instance.categories,
      'imageLinks': instance.imageLinks != null ? instance.imageLinks.toJson() : {"smallThumbnail":null, "thumbnail":null},
      'description': instance.description,
      'publisher': instance.publisher,
      'publishedDate': instance.publishedDate,
      'averageRating': instance.averageRating,
    };

Thumbnail _$ThumbnailFromJson(Map<String, dynamic> json) {
  return Thumbnail(
    smallThumbnail: json['smallThumbnail'] as String,
    thumbnail: json['thumbnail'] as String,
  );
}

Map<String, dynamic> _$ThumbnailToJson(Thumbnail instance) => <String, dynamic>{
      'smallThumbnail': instance.smallThumbnail,
      'thumbnail': instance.thumbnail,
    };
