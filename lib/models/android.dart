/// json model for android
class AndroidModel {
  String versionName, downloadUrl, changeLog, sourceUrl, sha256checksum;
  int versionCode, minSupport;

  AndroidModel(
    /// string
    this.versionName,
    this.downloadUrl,
    this.changeLog,
    this.sourceUrl,
    this.sha256checksum,

    /// int
    this.versionCode,
    this.minSupport,
  );
}
