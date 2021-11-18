class ContentDataModel {
  const ContentDataModel(
      {required this.contentId,
      required this.createTime,
      required this.userId,
      required this.visible,
      required this.comment,
      required this.content,
      required this.viewCount,
      required this.badCount,
      required this.likeCount,
      required this.images});

  final int contentId;
  final String content;
  final int likeCount;
  final int badCount;
  final int viewCount;
  final String userId;
  final String createTime;
  final String visible;
  final List<dynamic> comment;
  final List<dynamic> images;

  factory ContentDataModel.fromJson(Map<dynamic, dynamic> json) {
    return ContentDataModel(
      contentId: json['contentseq'],
      content: json['content'],
      userId: json['userid'],
      createTime: json['createtime'],
      visible: json['visible'],
      badCount: json['bad'],
      comment: json['comment'],
      likeCount: json['like'],
      viewCount: json['view'],
      images: json['images'],
    );
  }
}

class ImagesDataModel {
  const ImagesDataModel({required this.originalName, required this.mimetype, required this.destination, required this.filename, required this.path});

  final String originalName;
  final String mimetype;
  final String destination;
  final String filename;
  final String path;

  factory ImagesDataModel.fromJson(Map<dynamic, dynamic> json) {
    return ImagesDataModel(
      destination: json['destination'],
      filename: json['filename'],
      mimetype: json['mimetype'],
      originalName: json['originalname'],
      path: json['path']

    );
  }
}

class CommentDataModel {
  const CommentDataModel({required this.comment, required this.visible, required this.userId, required this.createTime, required this.commentSeq});

  final String comment;
  final int commentSeq;
  final String visible;
  final String userId;
  final String createTime;

  factory CommentDataModel.fromJson(Map<dynamic, dynamic> json) {
    return CommentDataModel(
      visible: json['visible'],
      createTime: json['createTime'],
      userId: json['userId'],
      comment: json['comment'],
      commentSeq: json['commentSeq'],
    );
  }
}

class ResponseContent {
  const ResponseContent({required this.mainDashContent});

  final List<dynamic> mainDashContent;

  factory ResponseContent.fromJson(Map<dynamic, dynamic> json) {
    return ResponseContent(mainDashContent: json['maindashcontent']);
  }
}

class ResponseUserContent {
  const ResponseUserContent({required this.mainDashContent});

  final List<dynamic> mainDashContent;

  factory ResponseUserContent.fromJson(Map<dynamic, dynamic> json) {
    return ResponseUserContent(mainDashContent: json['maindashcontent']);
  }
}
