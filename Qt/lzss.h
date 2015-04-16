#ifndef LZSS_H
#define LZSS_H

#include <QFile>
#include <QByteArray>

struct LzssSectorHeader {
    quint32 original_length;
    quint32 original_length2; // why?
    quint32 length;
};

void read_sect(QFile &fd, QByteArray &out_buff, quint32& out_len);

#endif // LZSS_H
