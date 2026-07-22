import 'package:equatable/equatable.dart';

class ImageResource extends Equatable {
  const ImageResource({
    required this.url,
    required this.thumbnailUrl,
    required this.fileName,
    required this.alt,
  });

  final String url;
  final String? thumbnailUrl;
  final String fileName;
  final String? alt;

  ImageResource copyWith({
    String? url,
    String? Function()? thumbnailUrl,
    String? fileName,
    String? Function()? alt,
  }) {
    return ImageResource(
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl == null ? this.thumbnailUrl : thumbnailUrl(),
      fileName: fileName ?? this.fileName,
      alt: alt == null ? this.alt : alt(),
    );
  }

  @override
  List<Object?> get props => [url, thumbnailUrl, fileName, alt];
}
