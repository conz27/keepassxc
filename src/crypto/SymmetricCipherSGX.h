#ifndef SYMMETRICCIPHERSGX_H
#define SYMMETRICCIPHERSGX_H

#include "SymmetricCipherBackend.h"

class SymmetricCipherSGX : public SymmetricCipherBackend {
public:
    SymmetricCipherSGX();
    virtual ~SymmetricCipherSGX()
    {
    }
    virtual bool init();
    virtual bool setKey(const QByteArray& key);
    virtual bool setIv(const QByteArray& iv);

    virtual QByteArray process(const QByteArray& data, bool* ok);
    Q_REQUIRED_RESULT virtual bool processInPlace(QByteArray& data);
    Q_REQUIRED_RESULT virtual bool processInPlace(QByteArray& data, quint64 rounds);

    virtual bool reset();
    virtual int keySize() const;
    virtual int blockSize() const;

    virtual QString error() const;
};

#endif // SYMMETRICCIPHERSGX_H
