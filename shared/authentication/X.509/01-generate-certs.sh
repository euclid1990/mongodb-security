#!/bin/bash
# http://galeracluster.com/documentation-webpages/sslcert.html

authType="authentication/X.509"
certDir="$HOME/shared/$authType/certs"

rm -rf "$certDir/*.pem"

# Set the hostname
sudo hostname database.mongodb.local

# 1. CA Certificate
# Generate the CA key.
openssl genrsa 2048 > "$certDir/ca-key.pem"
# Using the CA key, generate the CA certificate.
openssl req -new -x509 -nodes -days 365 -subj "/C=US/ST=New York/L=New York City/O=MongoDB/OU=University/CN=root" \
    -key "$certDir/ca-key.pem" -out "$certDir/ca.pem"

# 2. Server Certificate
# Create the server key.
openssl req -newkey rsa:2048 -days 365 \
    -subj "/C=US/ST=New York/L=New York City/O=MongoDB/OU=University/CN=database.mongodb.local" \
    -nodes -keyout "$certDir/server-key.pem" -out "$certDir/server-req.pem"
# Process the server RSA key.
openssl rsa -in "$certDir/server-key.pem" -out "$certDir/server-key.pem"
# Sign the server certificate.
openssl x509 -req -in "$certDir/server-req.pem" -days 365 \
    -CA "$certDir/ca.pem" -CAkey "$certDir/ca-key.pem" -set_serial 01 \
    -out "$certDir/server-cert.pem"
# Concatenate the server certificate and private key
cat "$certDir/server-key.pem" "$certDir/server-cert.pem" > "$certDir/server.pem"

# 3. Client Certificate
# Create the client key.
openssl req -newkey rsa:2048 -days 365 \
    -subj "/C=US/ST=New York/L=New York City/O=MongoDB/OU=MyUniversity/CN=Client" \
    -nodes -keyout "$certDir/client-key.pem" -out "$certDir/client-req.pem"
# Process client RSA key.
# openssl rsa -in "$certDir/client-key.pem" -out "$certDir/client-key.pem"
# Sign the client certificate.
openssl x509 -req -in "$certDir/client-req.pem" -days 365 \
    -CA "$certDir/ca.pem" -CAkey "$certDir/ca-key.pem" -set_serial 01 \
    -out "$certDir/client-cert.pem"
# Concatenate the client certificate and private key
cat "$certDir/client-key.pem" "$certDir/client-cert.pem" > "$certDir/client.pem"

# 4. Verifying the certificates
echo "------ [VERIFYING THE CERTIFICATES] ------"
openssl verify -CAfile "$certDir/ca.pem" "$certDir/server.pem" "$certDir/client.pem"
