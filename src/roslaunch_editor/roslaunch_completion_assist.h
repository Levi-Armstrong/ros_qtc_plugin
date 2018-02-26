#ifndef ROSLAUNCH_COMPLETION_ASSIST_PROVIDER_H
#define ROSLAUNCH_COMPLETION_ASSIST_PROVIDER_H

#include <texteditor/codeassist/completionassistprovider.h>
#include <texteditor/codeassist/keywordscompletionassist.h>

// See CMAKE as a reference

namespace ROSLaunchEditor {
namespace Internal {

class ROSLaunchCompletionAssist : public TextEditor::KeywordsCompletionAssistProcessor
{
public:
  ROSLaunchCompletionAssist();

  // IAssistProcessor interface
  TextEditor::IAssistProposal *perform(const TextEditor::AssistInterface *interface) override;
};

class ROSLaunchCompletionAssistProvider : public TextEditor::CompletionAssistProvider
{
  Q_OBJECT

public:
  ROSLaunchCompletionAssistProvider();

  TextEditor::IAssistProcessor *createProcessor() const override;

};

}
}
#endif // ROSLAUNCH_COMPLETION_ASSIST_PROVIDER_H
