import 'package:json_annotation/json_annotation.dart';
part 'Volume.g.dart';

@JsonSerializable()
class Volume {
  String title;
  List<String> authors;
  List<String> categories;
  Thumbnail imageLinks;
  String description;
  String publisher;
  String publishedDate;
  double averageRating;

  Volume(this.title, this.authors, this.categories, this.imageLinks,
      this.description, this.publisher, this.publishedDate, this.averageRating);

  factory Volume.fromJson(Map<String, dynamic> json) => _$VolumeFromJson(json);

  Map<String, dynamic> toJson() => _$VolumeToJson(this);

  @override
  String toString() {
    return 'Volume{title: $title, authors: $authors, categories: $categories, imageLinks: $imageLinks, description: $description, publisher: $publisher, publishedDate: $publishedDate, averageRating: $averageRating}';
  }
}

@JsonSerializable()
class Thumbnail{
  String smallThumbnail, thumbnail;

  Thumbnail({this.smallThumbnail, this.thumbnail});

  factory Thumbnail.fromJson(Map<String, dynamic> json) => _$ThumbnailFromJson(json);

  Map<String, dynamic> toJson() => _$ThumbnailToJson(this);

  @override
  String toString() {
    return 'Thumbnail{smallThumbnail: $smallThumbnail, thumbnail: $thumbnail}';
  }
}