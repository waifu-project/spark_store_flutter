import 'dart:io';

class DpkgUtil {
  /// check app can install [pkgName]
  ///
  /// if not install.
  /// `stdout` just like
  ///
  /// ```shell
  /// $ dpkg -l macosbigsur-cursorsd
  /// dpkg-query: no packages found matching macosbigsur-cursorsd
  /// ```
  static bool appCanInstalled(String? pkgName) {
    if (pkgName == null) return false;
    var _ = Process.runSync(
      "dpkg",
      [
        "-s",
        pkgName,
      ],
    );
    //.stdout.toString();
    return (_.stderr.toString() == "");
    // return !_.contains("no packages found matching");
  }

  static bool uninstall(String? pkgname) {
    // TODO
    return false;
  }

  static bool install(String? pkgname) {
    // TODO
    return false;
  }
}
