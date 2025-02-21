FROM eclipse-mosquitto:2.0.20

WORKDIR /mosquitto/config

COPY mosquitto.acl mosquitto.conf ./

RUN touch passwd \
 && mosquitto_passwd -b passwd "joe" "pwdjoe1" \
 && mosquitto_passwd -b passwd "root" "pwdroot1" \
 && chmod 700 passwd \
 && chmod 700 mosquitto.acl

EXPOSE 1883
