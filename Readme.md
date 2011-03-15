Wraps HA interface to add:

 - on / off switch

Server-Setup
============
 - Copy and customize config.example.yml into shared/config.yml
 - add /srv/ha_plus/shared/pids
 - add /srv/ha_plus/shared/log
 - move sudoless_haproxy_switch to /usr/local/bin
 - add `%users ALL=(ALL) NOPASSWD:/usr/local/bin/sudoless_haproxy_switch` to /etc/sudoers

