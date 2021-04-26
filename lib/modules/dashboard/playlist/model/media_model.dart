class MediaModel {
  String fieldName,
      originalName,
      encoding,
      mimeType,
      destination,
      filename,
      path,
      size;

  MediaModel(this.fieldName, this.originalName, this.encoding, this.mimeType,
      this.destination, this.filename, this.path, this.size);

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return new MediaModel(
      json['fieldname'],
      json['originalname'],
      json['encoding'],
      json['mimetype'],
      json['destination'],
      json['filename'],
      json['path'],
      json['size'],
    );
  }
}
