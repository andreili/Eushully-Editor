#include "eushullybineditor.h"
#include "ui_eushullybineditor.h"

EushullyBinEditor::EushullyBinEditor(QEushullyFile &file, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::EushullyBinEditor)
{
    ui->setupUi(this);
    this->bin.load(file);
    this->setWindowTitle(this->bin.getName());
    BINHeader header = this->bin.header();

    QTableWidgetItem *item = new QTableWidgetItem();
    item->setText(header.version);
    ui->tw_header->setItem(0, 0, item);

    item = new QTableWidgetItem();
    item->setText(QString::number(header.type));
    ui->tw_header->setItem(1, 0, item);

    item = new QTableWidgetItem();
    item->setText(QString::number(header.size_71));
    ui->tw_header->setItem(2, 0, item);

    item = new QTableWidgetItem();
    item->setText(QString::number(header.size_03));
    ui->tw_header->setItem(3, 0, item);

    item = new QTableWidgetItem();
    item->setText(QString::number(header.size_8f));
    ui->tw_header->setItem(4, 0, item);

    //this->ui->tb_script->setHtml(this->bin.getScript()->getParseResult());
    QEushullyScript script = this->bin.getScript();
    quint32 lines = script->getScriptLineCount();
    for (quint32 i=0 ; i<lines ; i++)
    {
        item = new QTableWidgetItem();
        item->setText(script.getScriptLine(i));
        ui->tw_header->setItem(i, 0, item);
    }
}

EushullyBinEditor::~EushullyBinEditor()
{
    delete ui;
}
