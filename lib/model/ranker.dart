class RankerContentDataModel {
  const RankerContentDataModel({
    required this.contentId,
    required this.userId,
    required this.content,
    required this.likeCount,
    required this.contentImageStringUri,
    required this.profileImageStringUri
  });

  final int contentId;
  final String content;
  final int likeCount;
  final String userId;
  final String profileImageStringUri;
  final String contentImageStringUri;

}
