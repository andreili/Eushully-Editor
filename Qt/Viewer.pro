#-------------------------------------------------
#
# Project created by QtCreator 2013-08-25T21:29:59
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Viewer
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    qeushullyalf.cpp \
    qeushullyfs.cpp \
    qeushullygame.cpp \
    lzss.cpp \
    qeushullyfile.cpp \
    qeushullybin.cpp \
    eushullybinviewer.cpp \
    qeushullyscript.cpp \
    eushullyvariables.cpp \
    qeushullyvariables.cpp \
    callstack.cpp \
    stack.cpp \
    breakpoints.cpp \
    eushullybineditor.cpp

HEADERS  += mainwindow.h \
    qeushullyalf.h \
    qeushullyfs.h \
    qeushullygame.h \
    lzss.h \
    qeushullyfile.h \
    qeushullybin.h \
    eushullybinviewer.h \
    qeushullyscript.h \
    qeushullyoperations.h \
    eushullyvariables.h \
    qeushullyvariables.h \
    callstack.h \
    stack.h \
    breakpoints.h \
    eushullybineditor.h

FORMS    += mainwindow.ui \
    eushullybinviewer.ui \
    eushullyvariables.ui \
    callstack.ui \
    stack.ui \
    breakpoints.ui \
    eushullybineditor.ui
