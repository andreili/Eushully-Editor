#ifndef CALLSTACK_H
#define CALLSTACK_H

#include <QDockWidget>

namespace Ui {
class CallStack;
}

class CallStack : public QDockWidget
{
    Q_OBJECT
    
public:
    explicit CallStack(QWidget *parent = 0);
    ~CallStack();
    
private:
    Ui::CallStack *ui;
};

#endif // CALLSTACK_H
