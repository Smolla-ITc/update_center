/// json model for android
class AndroidModel {
  String versionName, downloadUrl, changeLog, sourceUrl;
  int versionCode, minSupport;

  AndroidModel(
    /// string
    this.versionName,
    this.downloadUrl,
    this.changeLog,
    this.sourceUrl,

    /// int
    this.versionCode,
    this.minSupport,
  );
}
