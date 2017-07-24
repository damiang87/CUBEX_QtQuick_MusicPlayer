#ifndef URLSFILELIST_H
#define URLSFILELIST_H

#include <QObject>
#include <QString>
#include <QDir>
#include <QList>
#include <QUrl>

class UrlsFileList: public QObject
{
    Q_OBJECT
public:
    UrlsFileList(QObject *parent = nullptr);
private:

};

#endif // URLSFILELIST_H
