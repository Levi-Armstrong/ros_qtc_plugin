include(../../ros_qtc_plugin.pri)
include($$QTCREATOR_SOURCES/src/qtcreatorplugin.pri)

HEADERS += \
    roslaunch_editor_plugin.h \
    roslaunch_editor.h \
    roslaunch_editor_constants.h \
    roslaunch_highlighter.h \
    roslaunch_indenter.h \
    roslaunch_scanner.h \
    roslaunch_format_token.h \
    roslaunch_autocompleter.h \
    roslaunch_completion_assist.h

SOURCES += \
    roslaunch_editor_plugin.cpp \
    roslaunch_editor.cpp \
    roslaunch_highlighter.cpp \
    roslaunch_indenter.cpp \
    roslaunch_scanner.cpp \
    roslaunch_autocompleter.cpp \
    roslaunch_completion_assist.cpp

RESOURCES += roslaunch_editor.qrc
