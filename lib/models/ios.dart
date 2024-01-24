/// json model for ios
class IOSModel {
  String versionName, changeLog, sourceUrl;
  int versionCode, minSupport;

  IOSModel(
    /// string
    this.versionName,
    this.changeLog,
    this.sourceUrl,

    /// int
    this.versionCode,
    this.minSupport,
  );
}
