**Zano**

https://github.com/validierungcc/zano-docker

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

    curl -s -X POST "http://127.0.0.1:11211/json_rpc" -H "Content-Type: application/json" -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"getinfo\"}"