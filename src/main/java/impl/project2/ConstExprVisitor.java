package impl.project2;

import generated.Splc.SplcBaseVisitor;
import generated.Splc.SplcParser;

public class ConstExprVisitor extends SplcBaseVisitor<Integer> {
    @Override
    public Integer visitExpression(SplcParser.ExpressionContext ctx) {
        if (ctx.getChildCount() == 1) {
            String text = ctx.getChild(0).getText();
            try {
                return Integer.parseInt(text);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        else if (ctx.getChildCount() == 2) {
            String op = ctx.getChild(0).getText();
            Integer value = visit(ctx.getChild(1));
            if (value == null) {
                return null;
            }
            Integer result = null;
            switch (op) {
                case "+": result = value; break;
                case "-": result = -value; break;
                default: result = null;
            }
            return result;
        }
        else if (ctx.getChildCount() == 3) {
            if ("(".equals(ctx.getChild(0).getText()) && ")".equals(ctx.getChild(2).getText())) {
                return visit(ctx.getChild(1));
            }
            else {
                Integer left = visit(ctx.getChild(0));
                Integer right = visit(ctx.getChild(2));
                if(left == null || right == null) {
                    return null;
                }
                String op = ctx.getChild(1).getText();
                Integer result = null;
                switch (op) {
                    case "+": result = left + right; break;
                    case "-": result = left - right; break;
                    case "*": result = left * right; break;
                    case "/": result = left / right; break;
                    case "%": result = left % right; break;
                    default: result = null;
                }
                return result;
            }
        }
        return null;
    }
}
