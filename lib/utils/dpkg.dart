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
  static bool appCanInstalled(String pkgName) {
    var _ = Process.runSync("dpkg", [
      "-l",
      pkgName,
    ],).stdout.toString();
    return !_.contains("no packages found matching");
  }
}
