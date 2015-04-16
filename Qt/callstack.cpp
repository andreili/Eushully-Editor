#include "callstack.h"
#include "ui_callstack.h"

CallStack::CallStack(QWidget *parent) :
    QDockWidget(parent),
    ui(new Ui::CallStack)
{
    ui->setupUi(this);
}

CallStack::~CallStack()
{
    delete ui;
}
