# Release Checklist

* [ ] Increment package version at the top of [meson.build](../meson.build) and
  [CMakeLists.txt](../CMakeLists.txt)

* [ ] Increment library revision in [meson.build](../meson.build) and
  [CMakeLists.txt](../CMakeLists.txt)

* [ ] If interfaces were added, changed, or deleted, adjust per
  [meson.build](../meson.build) and [CMakeLists.txt](../CMakeLists.txt).
  See the GNU libtool versioning rules for library revision numbering advice:
  http://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html

* [ ] On release day, create a new `release/*` branch and create a release tag.
