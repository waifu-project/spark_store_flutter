class DownloadTask {
  String? name;
  String? pkgName;
  String? icon;
  String? downloadUrl;
  String? filepath;
  String? totalSize;
  String? downloadSize;
  bool? isDownload;

  DownloadTask({
    this.name,
    this.pkgName,
    this.icon,
    this.downloadUrl,
    this.filepath,
    this.totalSize,
    this.downloadSize,
    this.isDownload,
  });

  @override
  String toString() {
    return 'DownloadTask(name: $name, pkgName: $pkgName, icon: $icon, downloadUrl: $downloadUrl, filepath: $filepath, totalSize: $totalSize, downloadSize: $downloadSize, isDownload: $isDownload)';
  }

  factory DownloadTask.fromJson(Map<String, dynamic> json) => DownloadTask(
        name: json['name'] as String?,
        pkgName: json['pkgName'] as String?,
        icon: json['icon'] as String?,
        downloadUrl: json['download_url'] as String?,
        filepath: json['filepath'] as String?,
        totalSize: json['total_size'] as String?,
        downloadSize: json['download_size'] as String?,
        isDownload: json['is_download'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'pkgName': pkgName,
        'icon': icon,
        'download_url': downloadUrl,
        'filepath': filepath,
        'total_size': totalSize,
        'download_size': downloadSize,
        'is_download': isDownload,
      };

  DownloadTask copyWith({
    String? name,
    String? pkgName,
    String? icon,
    String? downloadUrl,
    String? filepath,
    String? totalSize,
    String? downloadSize,
    bool? isDownload,
  }) {
    return DownloadTask(
      name: name ?? this.name,
      pkgName: pkgName ?? this.pkgName,
      icon: icon ?? this.icon,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      filepath: filepath ?? this.filepath,
      totalSize: totalSize ?? this.totalSize,
      downloadSize: downloadSize ?? this.downloadSize,
      isDownload: isDownload ?? this.isDownload,
    );
  }
}
