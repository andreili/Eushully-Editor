#ifndef STACK_H
#define STACK_H

#include <QDockWidget>

namespace Ui {
class Stack;
}

class Stack : public QDockWidget
{
    Q_OBJECT
    
public:
    explicit Stack(QWidget *parent = 0);
    ~Stack();
    
private:
    Ui::Stack *ui;
};

#endif // STACK_H
