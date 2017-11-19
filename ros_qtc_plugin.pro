TEMPLATE  = subdirs
CONFIG   += ordered

config-in.input = $$PWD/installer/in-files/config/config.xml.in
config-in.output = $$PWD/installer/config/config.xml

QMAKE_SUBSTITUTES += config-in

package-in.input = $$PWD/installer/in-files/packages/org.rosindustrial.qtros/meta/package.xml.in
package-in.output = $$PWD/installer/packages/org.rosindustrial.qtros/meta/package.xml

QMAKE_SUBSTITUTES += package-in


SUBDIRS += \
    src \
    share
