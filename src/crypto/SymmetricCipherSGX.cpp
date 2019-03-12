#include "SymmetricCipherSGX.h"

#include <QString>

SymmetricCipherSGX::SymmetricCipherSGX()
{

}

bool SymmetricCipherSGX::init(){
    return false;
}
bool SymmetricCipherSGX::setKey(const QByteArray& key){
    return false;
}
bool SymmetricCipherSGX::setIv(const QByteArray& iv){
    return false;
}

QByteArray SymmetricCipherSGX::process(const QByteArray& data, bool* ok){
    return QByteArray();
}
Q_REQUIRED_RESULT bool SymmetricCipherSGX::processInPlace(QByteArray& data){
    return false;
}
Q_REQUIRED_RESULT bool SymmetricCipherSGX::processInPlace(QByteArray& data, quint64 rounds){
    return false;
}

bool SymmetricCipherSGX::reset(){
    return false;
}
int SymmetricCipherSGX::keySize() const{
    return -1;
}
int SymmetricCipherSGX::blockSize() const{
    return -1;
}

QString SymmetricCipherSGX::error() const{
    return QString();
}
