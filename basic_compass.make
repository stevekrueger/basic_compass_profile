; The Jibe Multimedia, Inc. - Basic/Compass Install Profile
; for more information, see: http://thejibe.com/blog/11/1/getting-started-basic-sass-and-compass-drupal

; Define Drush API and core version
api = 2
core = 6.x

; Admin
projects[admin][subdir] = "contrib"

; Development
projects[devel][subdir] = "development"
projects[compass][subdir] = "development"
projects[compass][version] = "1.x-dev"

; Themes
projects[] = basic
projects[] = rubik
projects[] = tao