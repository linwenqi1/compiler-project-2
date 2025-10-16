package impl.project2;

import framework.project2.Grader;
import framework.project2.MissingSymbolError;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.IntervalSet;
import org.antlr.v4.runtime.misc.ParseCancellationException;

public class Project2ErrorListener extends BaseErrorListener {
    private final Grader grader;
    public Project2ErrorListener(Grader grader) {
        this.grader = grader;
    }

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
        // TODO: extract information
        String missingSymbolName = "unknown";
        int reportLine = line;

        if (recognizer instanceof Parser parser) {
            // 获取缺失 token 类型
            IntervalSet expectedTokens = parser.getExpectedTokens();
            if (expectedTokens.size() > 0) {
                int expectedType = expectedTokens.getMinElement();
                missingSymbolName = parser.getVocabulary().getSymbolicName(expectedType);
            }

            // 行号处理
            if (offendingSymbol instanceof Token token) {
                reportLine = token.getLine(); // 默认下一 token 行
                if (parser.getInputStream() instanceof CommonTokenStream tokens) {
                    int index = token.getTokenIndex();
                    if (index > 0) {
                        Token prev = tokens.get(index - 1);
                        reportLine = prev.getLine(); // 尽量使用前一个 token 行号
                    }
                }
            }
        }
        reportLine = reportLine - 1;  //0-indexed
        if (reportLine < 0) reportLine = 0;
        MissingSymbolError missingSymbol = new MissingSymbolError(missingSymbolName, reportLine);
        this.grader.getWriter().println(missingSymbol);
        throw new ParseCancellationException();
    }
}
