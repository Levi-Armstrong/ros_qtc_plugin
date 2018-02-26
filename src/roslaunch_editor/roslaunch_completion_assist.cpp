#include "roslaunch_completion_assist.h"

namespace ROSLaunchEditor {
namespace Internal {

TextEditor::IAssistProcessor *ROSLaunchCompletionAssistProvider::createProcessor() const
{
    return new ROSLaunchCompletionAssist;
}

ROSLaunchCompletionAssist::ROSLaunchCompletionAssist() :
    KeywordsCompletionAssistProcessor(Keywords())
{
    setSnippetGroup(Constants::CMAKE_SNIPPETS_GROUP_ID);
}

TextEditor::IAssistProposal *ROSLaunchCompletionAssist::perform(const TextEditor::AssistInterface *interface)
{
    TextEditor::Keywords kw;
    QString fileName = interface->fileName();
    if (!fileName.isEmpty() && QFileInfo(fileName).isFile()) {
        Project *p = SessionManager::projectForFile(Utils::FileName::fromString(fileName));
        if (p && p->activeTarget()) {
            CMakeTool *cmake = CMakeKitInformation::cmakeTool(p->activeTarget()->kit());
            if (cmake && cmake->isValid())
                kw = cmake->keywords();
        }
    }

    setKeywords(kw);
    return KeywordsCompletionAssistProcessor::perform(interface);
}

}
}
