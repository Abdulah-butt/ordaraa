class UpdateUserProfileRequest {
  const UpdateUserProfileRequest({
    required this.displayName,
    required this.locale,
  });

  final String displayName;
  final String locale;

  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'locale': locale,
  };
}
