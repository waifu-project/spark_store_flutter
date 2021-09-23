import 'package:flutter/foundation.dart';

@immutable
class CategoryJson {
  final String? name;
  final String? version;
  final String? filename;
  final String? pkgname;
  final String? author;
  final String? contributor;
  final String? website;
  final String? update;
  final String? size;
  final String? more;
  final String? tags;
  final String? imgUrls;
  final String? icons;

  const CategoryJson({
    this.name,
    this.version,
    this.filename,
    this.pkgname,
    this.author,
    this.contributor,
    this.website,
    this.update,
    this.size,
    this.more,
    this.tags,
    this.imgUrls,
    this.icons,
  });

  @override
  String toString() {
    return 'CategoryJson(name: $name, version: $version, filename: $filename, pkgname: $pkgname, author: $author, contributor: $contributor, website: $website, update: $update, size: $size, more: $more, tags: $tags, imgUrls: $imgUrls, icons: $icons)';
  }

  factory CategoryJson.fromJson(Map<String, dynamic> json) => CategoryJson(
        name: json['Name'] as String?,
        version: json['Version'] as String?,
        filename: json['Filename'] as String?,
        pkgname: json['Pkgname'] as String?,
        author: json['Author'] as String?,
        contributor: json['Contributor'] as String?,
        website: json['Website'] as String?,
        update: json['Update'] as String?,
        size: json['Size'] as String?,
        more: json['More'] as String?,
        tags: json['Tags'] as String?,
        imgUrls: json['img_urls'] as String?,
        icons: json['icons'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Version': version,
        'Filename': filename,
        'Pkgname': pkgname,
        'Author': author,
        'Contributor': contributor,
        'Website': website,
        'Update': update,
        'Size': size,
        'More': more,
        'Tags': tags,
        'img_urls': imgUrls,
        'icons': icons,
      };

  CategoryJson copyWith({
    String? name,
    String? version,
    String? filename,
    String? pkgname,
    String? author,
    String? contributor,
    String? website,
    String? update,
    String? size,
    String? more,
    String? tags,
    String? imgUrls,
    String? icons,
  }) {
    return CategoryJson(
      name: name ?? this.name,
      version: version ?? this.version,
      filename: filename ?? this.filename,
      pkgname: pkgname ?? this.pkgname,
      author: author ?? this.author,
      contributor: contributor ?? this.contributor,
      website: website ?? this.website,
      update: update ?? this.update,
      size: size ?? this.size,
      more: more ?? this.more,
      tags: tags ?? this.tags,
      imgUrls: imgUrls ?? this.imgUrls,
      icons: icons ?? this.icons,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CategoryJson &&
        other.name == name &&
        other.version == version &&
        other.filename == filename &&
        other.pkgname == pkgname &&
        other.author == author &&
        other.contributor == contributor &&
        other.website == website &&
        other.update == update &&
        other.size == size &&
        other.more == more &&
        other.tags == tags &&
        other.imgUrls == imgUrls &&
        other.icons == icons;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      version.hashCode ^
      filename.hashCode ^
      pkgname.hashCode ^
      author.hashCode ^
      contributor.hashCode ^
      website.hashCode ^
      update.hashCode ^
      size.hashCode ^
      more.hashCode ^
      tags.hashCode ^
      imgUrls.hashCode ^
      icons.hashCode;
}
