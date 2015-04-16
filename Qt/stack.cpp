#include "stack.h"
#include "ui_stack.h"

Stack::Stack(QWidget *parent) :
    QDockWidget(parent),
    ui(new Ui::Stack)
{
    ui->setupUi(this);
}

Stack::~Stack()
{
    delete ui;
}
