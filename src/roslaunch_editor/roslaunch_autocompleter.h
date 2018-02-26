#ifndef ROSLAUNCH_AUTOCOMPLETER_H
#define ROSLAUNCH_AUTOCOMPLETER_H

#include <texteditor/autocompleter.h>

namespace ROSLaunchEditor {
namespace Internal {

class ROSLaunchAutocompleter : public TextEditor::AutoCompleter
{
public:
    ROSLaunchAutocompleter();

    // Returns the text to complete at the cursor position, or an empty string
    virtual QString autoComplete(QTextCursor &cursor, const QString &text, bool skipChars) const override;

    // Handles backspace. When returning true, backspace processing is stopped
    virtual bool autoBackspace(QTextCursor &cursor) override;

    // Hook to insert special characters on enter. Returns the number of extra blocks inserted.
    virtual int paragraphSeparatorAboutToBeInserted(QTextCursor &cursor) override;

    virtual bool contextAllowsAutoBrackets(const QTextCursor &cursor, const QString &textToInsert = QString()) const override;

    virtual bool contextAllowsAutoQuotes(const QTextCursor &cursor, const QString &textToInsert = QString()) const override;

    virtual bool contextAllowsElectricCharacters(const QTextCursor &cursor) const override;

    // Returns true if the cursor is inside a comment.
    virtual bool isInComment(const QTextCursor &cursor) const override;

    // Returns true if the cursor is inside a string.
    virtual bool isInString(const QTextCursor &cursor) const override;

    virtual QString insertMatchingBrace(const QTextCursor &cursor,
                                        const QString &text,
                                        QChar lookAhead, bool skipChars,
                                        int *skippedChars) const override;

    virtual QString insertMatchingQuote(const QTextCursor &cursor,
                                        const QString &text,
                                        QChar lookAhead, bool skipChars,
                                        int *skippedChars) const override;

    // Returns the text that needs to be inserted
    virtual QString insertParagraphSeparator(const QTextCursor &cursor) const override;
private:


};

} // namespace Internal
} // namespace ROSLaunchEditor


#endif // ROSLAUNCH_AUTOCOMPLETER_H
