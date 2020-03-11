# Compar it 

ComparIt est un outil de comparaison de produits qui permet d'integrer des modeles de produits non fixés. Il dispose d'Api d'insertion de produits  

Techniquement, on s'appuie sur plusieures briques qu'il faut reussir a présenter de facon uniforme:  
1. Un front singlepageapp (Angular 8)
2. Une Api de services (Springboot Java)
3. Une brique de collecte des analytics (Matomo)

# Configuration Docker du produit ComparIt

Ces 3 briques sont présentées par un conteneur chapeau Nginx (reverse-proxy) qui s'assure de proxyfier les flux sans que ces conteneurs de necessite d'etre exposés a l'internet  
Tous les flux transitent par NGINX  

###Packages OS requis si vous ne disposez pas deja de docker sur la machine (ubuntu 18.04)  
`sudo ./install_dependancies.sh`  

Ajouter votre utilisateur au groupe docker  
`sudo usermod -aG docker $USER` ou `sudo vim /etc/group`  

redemarrer le serveur pour verifier que docker demarre autmatiquement avec le serveur et que vous disposiez des bon droits docker a la reconnexion  
`sudo reboot`  

il est necessaire de customiser plsieurs fichiers de configuration pour y declarer les URLS du site web, configurer les comptes de BDD, d'analytics....
liste des fichiers a customiser:
* docker-compose.yml(configuration des conteneurs necessaires au projet)
* nginx.conf (configuration du reverse proxy)
* environment.json (indique au Front les urls des services)

`vim nginx.conf`  
`vim docker-compose.yml`  
`vim environment/environment.json`  

Lancement de ComparIT  
`cd comparIt_docker/`  
`docker-compose up -d`  

# A ne réaliser qu'en vue d'une configuration HTTPS SSL
## Configuration DNS

L'alias DNS a été pris en charge par cloudflare

recuperer le certificat letsencruypt relatif

il faut installer certbot et le plugin pip cloudflare 

>msn@vml2:~$ cat conf_https/certbot_generator.sh 
>certbot certonly \
>  --dns-cloudflare \
>  --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \
>  -d comparit.fr \
>  -d www.comparit.fr \
>  -d back.comparit.fr \
>  -d analytics.comparit.fr

les cles générées peuvent etre utilisées dans la configuration nginx pour assurer la securisation SSL

le fichier nginx.conf.ssl peut etre customisé et remplacer le fichier nginx.conf

