import '../../domain/entities/image_resource.dart';

class ImageResourceJson {
  const ImageResourceJson({
    required this.url,
    required this.thumbnailUrl,
    required this.fileName,
    required this.alt,
  });

  final String url;
  final String? thumbnailUrl;
  final String fileName;
  final String? alt;

  factory ImageResourceJson.fromJson(Map<String, dynamic> json) {
    return ImageResourceJson(
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      fileName: json['fileName'] as String,
      alt: json['alt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'thumbnailUrl': thumbnailUrl,
    'fileName': fileName,
    'alt': alt,
  };

  ImageResource toDomain() => ImageResource(
    url: url,
    thumbnailUrl: thumbnailUrl,
    fileName: fileName,
    alt: alt,
  );
}
