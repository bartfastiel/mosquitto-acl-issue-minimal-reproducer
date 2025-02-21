# mosquitto acl

How to get feedback, if I publish a mqtt message to a topic that is forbidden via acl (access control list) in mosquitto?

This minimal reproducer shows, that I publishing will silently fail.

## Setup

1. Run `run-broker.sh` to build and start a broker via docker.
2. In a new terminal run `run-subcribe.sh` to subscribe to everything.
3. In a new terminal run `run-publish.sh` to publish a message to a forbidden topic, then to a allowed topic.

## Output

### At step `1.`
The broker will output
```
1740151656: mosquitto version 2.0.20 starting
1740151656: Config loaded from /mosquitto/config/mosquitto.conf.
1740151656: Opening ipv4 listen socket on port 1883.
1740151656: mosquitto version 2.0.20 running
```

### At step `2.`
The subscriber will output
```
## this fails 'not authorised.'
Connection error: Connection Refused: not authorised.
## this successfully listens
```
and the broker will output
```
1740151678: New connection from 172.17.0.1:53664 on port 1883.
1740151678: Sending CONNACK to auto-C23B9948-3172-B4A5-A4F9-8BC9BDB3BB2D (0, 5)
1740151678: Client auto-C23B9948-3172-B4A5-A4F9-8BC9BDB3BB2D disconnected, not authorised.
1740151679: New connection from 172.17.0.1:53666 on port 1883.
1740151679: New client connected from 172.17.0.1:53666 as auto-F47E1582-BEF8-2935-B32A-A15E29885899 (p2, c1, k60, u'joe').
1740151679: No will message specified.
1740151679: Sending CONNACK to auto-F47E1582-BEF8-2935-B32A-A15E29885899 (0, 0)
1740151679: Received SUBSCRIBE from auto-F47E1582-BEF8-2935-B32A-A15E29885899
1740151679:     test (QoS 0)
1740151679: auto-F47E1582-BEF8-2935-B32A-A15E29885899 0 test
1740151679:     # (QoS 0)
1740151679: auto-F47E1582-BEF8-2935-B32A-A15E29885899 0 #
1740151679: Sending SUBACK to auto-F47E1582-BEF8-2935-B32A-A15E29885899
```

### At step `3.`

#### Publish to "forbidden" topic

The publisher will output
```
## this fails silently
Client null sending CONNECT
Client null received CONNACK (0)
Client null sending PUBLISH (d0, q0, r0, m1, 'forbidden', ... (2 bytes))
Client null sending DISCONNECT
exit code 0
```
and the broker will output
```
1740151714: New connection from 172.17.0.1:36028 on port 1883.
1740151714: New client connected from 172.17.0.1:36028 as auto-B6A5424D-DEA5-03B5-6EEB-112F322C4FC9 (p2, c1, k60, u'joe').
1740151714: No will message specified.
1740151714: Sending CONNACK to auto-B6A5424D-DEA5-03B5-6EEB-112F322C4FC9 (0, 0)
1740151714: Denied PUBLISH from auto-B6A5424D-DEA5-03B5-6EEB-112F322C4FC9 (d0, q0, r0, m0, 'forbidden', ... (2 bytes))
1740151714: Received DISCONNECT from auto-B6A5424D-DEA5-03B5-6EEB-112F322C4FC9
1740151714: Client auto-B6A5424D-DEA5-03B5-6EEB-112F322C4FC9 disconnected.
```
and the **listener will not output anything!** (so acl was applied)

#### Then publish to "allowed" topic

The publisher will output
```
## this works as expected (matches the allowed topic)
Client null sending CONNECT
Client null received CONNACK (0)
Client null sending PUBLISH (d0, q0, r0, m1, 'allowed', ... (2 bytes))
Client null sending DISCONNECT
exit code 0
```
and the broker will output
```
1740151884: New connection from 172.17.0.1:60274 on port 1883.
1740151884: New client connected from 172.17.0.1:60274 as auto-9BD35683-C933-3608-6679-29A6808EBAB8 (p2, c1, k60, u'joe').
1740151884: No will message specified.
1740151884: Sending CONNACK to auto-9BD35683-C933-3608-6679-29A6808EBAB8 (0, 0)
1740151884: Received PUBLISH from auto-9BD35683-C933-3608-6679-29A6808EBAB8 (d0, q0, r0, m0, 'allowed', ... (2 bytes))
1740151884: Sending PUBLISH to auto-F47E1582-BEF8-2935-B32A-A15E29885899 (d0, q0, r0, m0, 'allowed', ... (2 bytes))
1740151884: Received DISCONNECT from auto-9BD35683-C933-3608-6679-29A6808EBAB8
1740151884: Client auto-9BD35683-C933-3608-6679-29A6808EBAB8 disconnected.
```
and the listener will output
```
allowed hi
```