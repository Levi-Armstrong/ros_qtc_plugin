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

#include "roslaunch_editor.h"
#include "roslaunch_editor_constants.h"
#include "roslaunch_editor_plugin.h"
#include "roslaunch_indenter.h"
#include "roslaunch_highlighter.h"
#include "roslaunch_autocompleter.h"

#include <texteditor/texteditoractionhandler.h>
#include <texteditor/texteditorconstants.h>
#include <texteditor/textdocument.h>

#include <utils/qtcassert.h>

#include <QCoreApplication>

using namespace TextEditor;

namespace ROSLaunchEditor {
namespace Internal {

ROSLaunchEditorFactory::ROSLaunchEditorFactory()
{
    setId(Constants::ROS_LAUNCH_EDITOR_ID);
    setDisplayName(QCoreApplication::translate("OpenWith::Editors", Constants::ROS_LAUNCH_EDITOR_DISPLAY_NAME));
    addMimeType(Constants::ROS_LAUNCH_MIME_TYPE);

    setEditorActionHandlers(TextEditorActionHandler::Format
                       | TextEditorActionHandler::UnCommentSelection
                       | TextEditorActionHandler::UnCollapseAll);

    setDocumentCreator([] { return new TextDocument(Constants::ROS_LAUNCH_EDITOR_ID); });
    setIndenterCreator([] { return new ROSLaunchIndenter; });
    setSyntaxHighlighterCreator([] { return new ROSLaunchHighlighter; });
    setCommentDefinition(Utils::CommentDefinition::HashStyle);
    setAutoCompleterCreator([] { return new ROSLaunchAutocompleter; });
    setCompletionAssistProvider(CompletionAssistProvider);
    setParenthesesMatchingEnabled(true);
    setMarksVisible(true);
    setCodeFoldingSupported(true);
}

} // namespace Internal
} // namespace ROSLaunchEditor
