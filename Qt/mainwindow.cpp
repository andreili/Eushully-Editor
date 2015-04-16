#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "qeushullygame.h"
#include "qeushullyfile.h"
#include "qeushullyfs.h"
#include "qeushullybin.h"
#include "qeushullyalf.h"
#include "eushullybineditor.h"
#include "eushullyvariables.h"

QEushullyGame eushully_game;
EushullyVariables *varWin;

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    //game.load("/media/work/VBmashines/JAP Games/Games/Madou Koukaku/");
    eushully_game.load("/media/work/VBmashines/Other/JAP Games/Games/LaDEA/");
    //eushully_game.load("h:/Games/Madou Koukaku/");
    //QEushullyFile file;
    //for (int i=0 ; i<)
    ui->treeWidget->clear();
    QTreeWidgetItem *item;
    item = new QTreeWidgetItem();
    item->setText(0, "Game");
    item->setExpanded(true);
    item->setData(0, Qt::UserRole, 0);
    ui->treeWidget->addTopLevelItem(item);
    eushully_game.get_FS()->tree_fill(item);

    //varWin = new EushullyVariables(0);
    //varWin->show();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_treeWidget_currentItemChanged(QTreeWidgetItem *current, QTreeWidgetItem *previous)
{
    ui->tw_details->setRowCount(2);
    if (current->data(0, Qt::UserRole) != 0)
    {
        QEushullyFile file;
        file.open(current->text(0));
        if (QEushullyBIN::is_format(file))
            ui->tw_details->item(0,0)->setText("Eushully Script File");
        else
            ui->tw_details->item(0,0)->setText("Unknown");
        ui->tw_details->item(0,1)->setText(file.size_human());
        file.close();
        ui->tw_details->resizeColumnsToContents();
    }
    else
    {
        ui->tw_details->item(0,0)->setText(("-"));
        ui->tw_details->item(0,1)->setText(("-"));

        QEushullyALF *alf = eushully_game.get_FS()->get_main_archive();
        int c = alf->get_settings_count();
        ui->tw_details->setRowCount(2 + c);
        for (int i=0 ; i<c ; i++)
        {
            // name
            QTableWidgetItem *item = new QTableWidgetItem();
            item->setText(alf->get_setting_name(i));
            ui->tw_details->setVerticalHeaderItem(2+i, item);
            // value
            item = new QTableWidgetItem();
            item->setText(alf->get_setting_value(i));
            ui->tw_details->setItem(2+i, 0, item);
        }
        ui->tw_details->resizeColumnsToContents();
        ui->tw_details->resizeColumnToContents(1);
    }
}

void MainWindow::on_treeWidget_expanded(const QModelIndex &index)
{
    ui->treeWidget->resizeColumnToContents(0);
}

void MainWindow::on_treeWidget_itemDoubleClicked(QTreeWidgetItem *item, int column)
{
    if (item->data(column, Qt::UserRole) != 0)
    {
        QEushullyFile file;
        file.open(item->text(column));
        if (QEushullyBIN::is_format(file))
        {
            EushullyBinEditor *editor = new EushullyBinEditor(file);
            editor->show();
        }
        file.close();
    }
}

void MainWindow::on_le_filter_textChanged(const QString &arg1)
{
    QTreeWidgetItem *top = ui->treeWidget->topLevelItem(0);
    for (int i=0 ; i<top->childCount() ; i++)
    {
        QTreeWidgetItem *item = top->child(i);
        item->setHidden((item->text(0).indexOf(arg1, 0, Qt::CaseInsensitive) == -1));
    }
}

void MainWindow::on_export_texts()
{
    //
}
