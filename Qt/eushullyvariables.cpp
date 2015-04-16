#include "eushullyvariables.h"
#include "ui_eushullyvariables.h"
#include "qeushullygame.h"

extern QEushullyGame eushully_game;

EushullyVariables::EushullyVariables(QWidget *parent) :
    QDockWidget(parent),
    ui(new Ui::EushullyVariables)
{
    ui->setupUi(this);
    this->connect(eushully_game.getVars(),
                  SIGNAL(variable_added(EushullyVariable)),
                  this, SLOT(variableAdded(EushullyVariable)));
}

EushullyVariables::~EushullyVariables()
{
    delete ui;
}

void EushullyVariables::variableAdded(EushullyVariable var)
{
    int row_idx = this->ui->tableWidget->rowCount();
    this->ui->tableWidget->setRowCount(row_idx + 1);

    QTableWidgetItem *item = new QTableWidgetItem();
    item->setText(QString::number(var.name, 16));
    this->ui->tableWidget->setItem(row_idx, 0, item);

    item = new QTableWidgetItem();
    item->setText(QString::number((quint32)var.type, 16));
    this->ui->tableWidget->setItem(row_idx, 1, item);

    item = new QTableWidgetItem();
    item->setText(QString::number(var.value.toUInt(), 16));
    this->ui->tableWidget->setItem(row_idx, 2, item);
}

void EushullyVariables::variableUpdated(EushullyVariable var)
{
    QString name_str = QString::number(var.name, 16);
    for (int i=0 ; i<this->ui->tableWidget->rowCount() ; i++)
        if (this->ui->tableWidget->item(i, 0)->text().compare(name_str) == 0)
        {
            this->ui->tableWidget->item(i, 0)->setText(name_str);
            this->ui->tableWidget->item(i, 1)->setText(QString::number((quint32)var.type, 16));
            this->ui->tableWidget->item(i, 2)->setText(QString::number(var.value.toUInt(), 16));
        }
}
