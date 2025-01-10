**Zano**

https://github.com/validierungcc/eMark-docker

https://www.zano.org/


minimal example compose.yml

     ---
    services:
        zano:
            container_name: zano
            image: vfvalidierung/zano:latest
            restart: unless-stopped
            ports:
                - '11121:11121'
                - '127.0.0.1:11211:11211'
            volumes:
                - 'zano_data:/zano/.Zano'
    volumes:
       zano_data:

**RPC Access**

    curl --user 'zanorpc:<password>' --data-binary '{"jsonrpc":"2.0","id":"curltext","method":"getinfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:4444
