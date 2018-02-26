/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt Creator.
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation with exceptions as appearing in the file LICENSE.GPL3-EXCEPT
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
****************************************************************************/

#include "roslaunch_editor_plugin.h"
#include "roslaunch_editor.h"
#include "roslaunch_editor_constants.h"
#include "roslaunch_highlighter.h"

#include <coreplugin/icore.h>
#include <coreplugin/coreconstants.h>
#include <coreplugin/documentmanager.h>
#include <coreplugin/fileiconprovider.h>
#include <coreplugin/id.h>
#include <coreplugin/editormanager/editormanager.h>

#include <extensionsystem/pluginmanager.h>

#include <projectexplorer/applicationlauncher.h>
#include <projectexplorer/kitmanager.h>
#include <projectexplorer/localenvironmentaspect.h>
#include <projectexplorer/runconfiguration.h>
#include <projectexplorer/runconfigurationaspects.h>
#include <projectexplorer/project.h>
#include <projectexplorer/projectmanager.h>
#include <projectexplorer/projectnodes.h>
#include <projectexplorer/runnables.h>
#include <projectexplorer/target.h>

#include <texteditor/texteditorconstants.h>

#include <utils/algorithm.h>
#include <utils/detailswidget.h>
#include <utils/pathchooser.h>
#include <utils/qtcprocess.h>
#include <utils/utilsicons.h>
#include <utils/mimetypes/mimedatabase.h>

#include <QtPlugin>
#include <QCoreApplication>
#include <QFormLayout>
#include <QRegExp>

using namespace Core;
using namespace ProjectExplorer;
using namespace ROSLaunchEditor::Constants;
using namespace Utils;

namespace ROSLaunchEditor {
namespace Internal {

static ROSLaunchEditorPlugin *m_instance = 0;

ROSLaunchEditorPlugin::ROSLaunchEditorPlugin()
{
    m_instance = this;
}

ROSLaunchEditorPlugin::~ROSLaunchEditorPlugin()
{
    m_instance = 0;
}

bool ROSLaunchEditorPlugin::initialize(const QStringList &arguments, QString *errorMessage)
{
    Q_UNUSED(arguments)
    Q_UNUSED(errorMessage)

//    QFile mimeFilePath(":roslaunch/ROSLaunchEditor.mimetypes.xml");

//    if (mimeFilePath.open(QIODevice::ReadOnly)) {
//        QByteArray mimeByteArray = mimeFilePath.readAll();

//        if( ! mimeByteArray.isEmpty() )
//            Utils::addMimeTypes(Constants::ROS_LAUNCH_MIME_TYPE, mimeByteArray);
//        else { Q_ASSERT(false); }
//    }

    addAutoReleasedObject(new ROSLaunchEditorFactory);

    return true;
}

void ROSLaunchEditorPlugin::extensionsInitialized()
{
    // Initialize editor actions handler
    // Add MIME overlay icons (these icons displayed at Project dock panel)
    const QIcon icon = QIcon::fromTheme(ROS_LAUNCH_MIME_ICON);
    if (!icon.isNull())
        Core::FileIconProvider::registerIconOverlayForMimeType(icon, ROS_LAUNCH_MIME_TYPE);
}

} // namespace Internal
} // namespace ROSLaunchEditor
