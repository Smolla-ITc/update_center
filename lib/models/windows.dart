/// Json model for windows
class WindowsModel {
  String downloadUrl, versionName, changeLog, sourceUrl, sha256checksum;
  int versionCode, minSupport;

  WindowsModel(
    /// string
    this.downloadUrl,
    this.versionName,
    this.changeLog,
    this.sourceUrl,
    this.sha256checksum,

    /// int
    this.versionCode,
    this.minSupport,
  );
}
