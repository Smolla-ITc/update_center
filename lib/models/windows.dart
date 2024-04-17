/// Json model for windows
class WindowsModel {
  String versionName, downloadUrl, changeLog, sourceUrl;
  int versionCode, minSupport;

  WindowsModel(
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
