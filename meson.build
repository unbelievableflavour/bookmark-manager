project('com.github.bartzaalberg.bookmark-manager', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

asresources = gnome.compile_resources(
    'as-resources', 'data/icons/icons.gresource.xml',
    source_dir: 'data/icons',
    c_name: 'as'
)

executable(
    meson.project_name(),
        'src/Application.vala',
        'src/MainWindow.vala',
        'src/ListBoxRow.vala',
        'src/ListBox.vala',
        'src/ConfigFileReader.vala',
        'src/Constants.vala',
        'src/Bookmark.vala',
        'src/StackManager.vala',
        'src/Dialogs/Preferences.vala',
        'src/Dialogs/DeleteConfirm.vala',
        'src/Dialogs/Alert.vala',
        'src/Dialogs/Cheatsheet.vala',
        'src/Views/AddBookmark.vala',
        'src/Views/EditBookmark.vala',
        'src/Views/ListBookmarks.vala',
        'src/Views/EmptyView.vala',
        'src/Views/NotFoundView.vala',
        'src/Components/HeaderBar.vala',
        'src/Components/HeaderLabel.vala',
        'src/Components/BookmarkFormLabel.vala',
        'src/Components/BookmarkFormEntry.vala',
        'src/Components/BookmarkFormCheckButton.vala',
        'src/Components/BookmarkForm.vala',
        'src/Components/Terminal.vala',
    asresources,
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite'),
        dependency('vte-2.91')
    ],
    install: true
)

executable(
    'com.github.bartzaalberg.bookmark-manager-quicklist',
        'src/DesktopFileManager/DesktopFileApplication.vala',
        'src/DesktopFileManager/DesktopFileManager.vala',
        'src/ConfigFileReader.vala',
        'src/Bookmark.vala',
    dependencies: [
        dependency('gtk+-3.0')
    ],
    install: true
)

executable(
    'com.github.bartzaalberg.bookmark-manager-quicklist-polkit',
        'src/Polkit/Application.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('gio-2.0')
    ],
    install: true
)

subdir('data')
subdir('po')

python3 = import('python3').find_python()
run_command(python3, '-c', 'import shutil; shutil.copy("hooks/pre-commit.hook", ".git/hooks/pre-commit")')
