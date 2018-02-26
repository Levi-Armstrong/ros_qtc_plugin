#include "roslaunch_autocompleter.h"

namespace ROSLaunchEditor {
namespace Internal {

ROSLaunchAutocompleter::ROSLaunchAutocompleter()
{
  AutoCompleter();
}

// Returns the text to complete at the cursor position, or an empty string
QString ROSLaunchAutocompleter::autoComplete(QTextCursor &cursor, const QString &text, bool skipChars) const
{
  AutoCompleter::autoComplete(cursor, text, skipChars);
}

// Handles backspace. When returning true, backspace processing is stopped
bool ROSLaunchAutocompleter::autoBackspace(QTextCursor &cursor)
{
  AutoCompleter::autoBackspace(cursor);
}

// Hook to insert special characters on enter. Returns the number of extra blocks inserted.
int ROSLaunchAutocompleter::paragraphSeparatorAboutToBeInserted(QTextCursor &cursor)
{
  AutoCompleter::paragraphSeparatorAboutToBeInserted(cursor);
}

bool ROSLaunchAutocompleter::contextAllowsAutoBrackets(const QTextCursor &cursor, const QString &textToInsert = QString()) const
{
  AutoCompleter::contextAllowsAutoBrackets(cursor, textToInsert);
}

bool ROSLaunchAutocompleter::contextAllowsAutoQuotes(const QTextCursor &cursor, const QString &textToInsert = QString()) const
{
  AutoCompleter::contextAllowsAutoQuotes(cursor, textToInsert);
}

bool ROSLaunchAutocompleter::contextAllowsElectricCharacters(const QTextCursor &cursor) const
{
  AutoCompleter::contextAllowsElectricCharacters(cursor);
}

// Returns true if the cursor is inside a comment.
bool ROSLaunchAutocompleter::isInComment(const QTextCursor &cursor) const
{
  AutoCompleter::isInComment(cursor);
}

// Returns true if the cursor is inside a string.
bool ROSLaunchAutocompleter::isInString(const QTextCursor &cursor) const
{
  AutoCompleter::isInString(cursor);
}

QString ROSLaunchAutocompleter::insertMatchingBrace(const QTextCursor &cursor,
                                    const QString &text,
                                    QChar lookAhead, bool skipChars,
                                    int *skippedChars) const
{
  AutoCompleter::insertMatchingBrace(cursor, text, lookAhead, skipChars, skippedChars);
}

QString ROSLaunchAutocompleter::insertMatchingQuote(const QTextCursor &cursor,
                                    const QString &text,
                                    QChar lookAhead, bool skipChars,
                                    int *skippedChars) const
{
  AutoCompleter::insertMatchingQuote(cursor, text, lookAhead, skipChars, skippedChars);
}

// Returns the text that needs to be inserted
QString ROSLaunchAutocompleter::insertParagraphSeparator(const QTextCursor &cursor) const
{
  AutoCompleter::insertParagraphSeparator(cursor);
}

}
}
