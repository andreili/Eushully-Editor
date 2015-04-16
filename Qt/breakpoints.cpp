#include "breakpoints.h"
#include "ui_breakpoints.h"

Breackpoints::Breackpoints(QWidget *parent) :
    QDockWidget(parent),
    ui(new Ui::Breackpoints)
{
    ui->setupUi(this);
}

Breackpoints::~Breackpoints()
{
    delete ui;
}

void Breackpoints::on_tableWidget_itemChanged(QTableWidgetItem *item)
{
    this->ui->tableWidget->resizeColumnToContents(item->column());
}
