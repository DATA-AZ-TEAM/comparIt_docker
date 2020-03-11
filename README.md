# Comfiguration Docker du produit ComparIt

ComparIt s'appuie sur plusires briques qu'il faut reussir a présenter de facon uniforme:
1. Un front singlepageapp
2. Une Api de services
3. Une brique de collecte des analytics (Matomo)

ces 3 briques sont présentées par un conteneur chapeau Nginx qui s'assure de proxyfier les flux sans que ces conteneurs de necessite d'etre exposés a l'internet
Tous les flux transitent par NGINX

###Packages OS requis

* `sudo apt update`
* `sudo apt install docker.io`
* `sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
* `sudo chmod 755 /usr/local/bin/docker-compose`

activer le service docker sur l'os pour qu'il redémarre automatiquement:
`sudo systemctl enable docker`

Attention, il est nécessaire que l'utilisateur soit membre du groupe docker pour pouvoir avoir acces aux commandes docker, dans le cas contraire toutes les commandes doivent être préfixées de **sudo**

a partir de maintenant la commande `docker ps` doit produire un résultat.

il est necessaire de customiser plsieurs fichiers de configuration pour y declarer les URLS du site web, configurer les comptes de BDD, d'analytics....

liste des fichiers a customiser:
* docker-compose.yml(configuration des conteneurs necessaires au projet)
* nginx.conf (configuration du reverse proxy)
* environment.json (indique au Front les urls des services)

une fois cela fait
* `docker-compose up -d` 

### A ne réaliser qu'en vue d'une configuration HTTPS SSL
## Configuration DNS

L'alias DNS a été pris en charge par cloudflare

la difficulté a été de recuperer le certificat letsencruypt relatif

il faut installer certbot et le plugin pip cloudflare 

>msn@vml2:~$ cat certbot_generator.sh 
>certbot certonly \
>  --dns-cloudflare \
>  --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \
>  -d comparit.fr \
>  -d www.comparit.fr \
>  -d back.comparit.fr \
>  -d analytics.comparit.fr

les cles générées peuvent etre utilisées dans la configuration nginx pour assurer la securisation SSL

