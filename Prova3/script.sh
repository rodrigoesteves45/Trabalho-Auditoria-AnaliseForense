#!/bin/bash
LOGFILE=/var/log/auth.log

for i in $(seq 1 22); do
  echo "Mar 14 02:11:$(printf '%02d' $i) srvdev sshd[1337]: Failed password for invalid user admin from 185.220.101.48 port $((40000+i)) ssh2" >> $LOGFILE
done

for i in $(seq 1 8); do
  echo "Mar 14 01:55:$(printf '%02d' $i) srvdev sshd[1337]: Failed password for root from 92.118.160.5 port $((30000+i)) ssh2" >> $LOGFILE
done

echo 'Mar 14 02:17:03 srvdev sshd[1337]: Accepted publickey for deploy from 10.0.2.55 port 54321 ssh2: RSA SHA256:f97048764b74da156812fa58fc4946610628fbea925b34c21c98e25d83036394' >> $LOGFILE
echo 'Mar 14 02:17:03 srvdev sshd[1337]: pam_unix(sshd:session): session opened for user deploy by (uid=0)' >> $LOGFILE


echo "The keeper tried to sweep the chamber clean. A command was spoken to silence the chronicle of deeds. Yet, the chronicle endured, bound by an unseen journal. While the keeper destroyed with fire, the embers remember still. Sift the ashes. The Glass Prison awaits those who find what was sent before the torches went dark." > clue.txt

KEY=$(openssl rand -hex 16)
IV=$(openssl rand -hex 16)

cat > secret.key <<EOF
KEY=$KEY
IV=$IV
EOF

openssl enc -aes-128-cbc -K "$KEY" -in clue.txt -out clue.aes128 -iv "$IV"
rm clue.txt
openssl pkeyutl -encrypt -inkey /home/deploy/.ssh/id_rsa_backup -in secret.key -out secret.rsa

openssl enc -aes-256-cbc -pbkdf2 -k '10.0.2.55_54321' -in /home/deploy/.ssh/id_rsa_backup -out /home/deploy/.ssh/id_rsa_backup.aes256
rm /home/deploy/.ssh/id_rsa_backup
chown -R deploy:deploy /home/deploy/.ssh
chown root:adm /var/log/auth.log

