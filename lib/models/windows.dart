/// Json model for windows
class WindowsModel {
  String versionName, downloadUrl, changeLog, sourceUrl, sha256checksum;
  int versionCode, minSupport;

  WindowsModel(
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
